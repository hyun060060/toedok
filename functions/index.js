const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const cors = require("cors")({ origin: true });
const axios = require("axios");
const { google } = require("googleapis");
const fs = require("fs").promises;
const path = require("path");

const GEMINI_API_KEY = defineSecret("GEMINI_API_KEY");

let auth;
try {
  auth = new google.auth.GoogleAuth({
    keyFile: "./toedok-service-account-key.json",
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  console.log("Google Play API 인증 클라이언트 초기화 성공");
} catch (error) {
  console.error("Google Play API 인증 클라이언트 초기화 실패:", error);
  throw error;
}

const androidPublisher = google.androidpublisher({
  version: "v3",
  auth: auth,
});

const PURCHASES_FILE = path.join(__dirname, "purchases.json");

async function readPurchases() {
  try {
    const data = await fs.readFile(PURCHASES_FILE, "utf8");
    return JSON.parse(data);
  } catch (error) {
    if (error.code === "ENOENT") {
      return [];
    }
    console.error("구매 기록 읽기 오류:", error);
    throw error;
  }
}

async function writePurchases(purchases) {
  try {
    await fs.writeFile(PURCHASES_FILE, JSON.stringify(purchases, null, 2));
  } catch (error) {
    console.error("구매 기록 쓰기 오류:", error);
    throw error;
  }
}

exports.analyzeTextV2 = onRequest(
  {
    secrets: [GEMINI_API_KEY],
    timeoutSeconds: 100,
    memory: "512MiB",
  },
  async (req, res) => {
    cors(req, res, async () => {
      if (req.method !== "POST") {
        return res.status(405).json({ error: "Method not allowed" });
      }

      const { conversationLog } = req.body;
      if (!conversationLog) {
        return res.status(400).json({ error: "conversationLog is required" });
      }

      try {
        const apiRes = await axios.post(
          `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${process.env.GEMINI_API_KEY}`,
          {
            contents: [
              {
                parts: [{ text: conversationLog }],
              },
            ],
            generationConfig: {
              temperature: 1.0,
              maxOutputTokens: 1500,
            },
          },
          {
            headers: {
              "Content-Type": "application/json",
            },
            timeout: 100000,
          }
        );

        console.log("Gemini API 응답:", JSON.stringify(apiRes.data));

        if (!apiRes.data.candidates || !apiRes.data.candidates[0]?.content?.parts?.[0]?.text) {
          throw new Error("유효하지 않은 Gemini 응답: candidates 또는 text 누락");
        }

        return res.status(200).json(apiRes.data);
      } catch (err) {
        console.error("Gemini API 요청 실패:", err.message, err.response?.data);
        return res.status(500).json({
          error: "Gemini API 요청 실패",
          message: err.response?.data || err.message,
        });
      }
    });
  }
);

exports.verifyPurchaseV2 = onRequest(
  {
    timeoutSeconds: 30,
    memory: "512MiB",
  },
  async (req, res) => {
    cors(req, res, async () => {
      if (req.method !== "POST") {
        console.error("Invalid method:", req.method);
        return res.status(405).json({ error: "Method not allowed" });
      }

      const { purchaseToken, productId, packageName } = req.body;
      console.log("Received request:", { purchaseToken, productId, packageName });

      if (!purchaseToken || !productId || !packageName) {
        console.error("Missing fields:", { purchaseToken, productId, packageName });
        return res.status(400).json({
          isValid: false,
          error: `Missing required fields: ${[!purchaseToken ? 'purchaseToken' : '', !productId ? 'productId' : '', !packageName ? 'packageName' : ''].filter(Boolean).join(', ')}`,
        });
      }

      try {
        const response = await androidPublisher.purchases.subscriptions.get({
          packageName: packageName,
          subscriptionId: productId,
          token: purchaseToken,
        });

        console.log("Google Play API response:", JSON.stringify(response.data));
        const isValid = response.data && response.data.paymentState === 1;
        const orderId = response.data.orderId;

        if (!isValid) {
          console.log(`Purchase invalid: ${JSON.stringify(response.data)}`);
          return res.status(200).json({ isValid: false });
        }

        const purchases = await readPurchases();
        if (purchases.some((p) => p.orderId === orderId)) {
          console.log(`Duplicate orderId: ${orderId}`);
          return res.status(400).json({ isValid: false, error: "Duplicate orderId" });
        }

        purchases.push({ orderId, purchaseToken, productId, packageName, timestamp: new Date().toISOString() });
        await writePurchases(purchases);
        console.log(`Purchase saved: orderId=${orderId}`);

        console.log(`Purchase verification result: ${isValid}, response: ${JSON.stringify(response.data)}`);
        return res.status(200).json({ isValid: true });
      } catch (error) {
        console.error("Error verifying purchase:", error.message, error.response?.data || error);
        return res.status(500).json({
          isValid: false,
          error: error.message || error.toString(),
        });
      }
    });
  }
);

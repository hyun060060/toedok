/**
 * @firebase-functions:gen1
 * 이 주석은 이 함수가 Firebase 1세대(Gen1) 인프라에서 실행되어야 함을 명시합니다.
 */

const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
app.use(express.json());
app.use(cors({ origin: true }));

// Firebase Functions 환경 변수 로드
const config = functions.config();
const DEEPSEEK_API_KEY = config.deepseek?.api_key;

// 디버깅 로그 (배포 후 콘솔에서 확인 가능)
console.log("functions.config():", config);
console.log("DEEPSEEK_API_KEY:", DEEPSEEK_API_KEY);

// POST /analyzeText 라우트
app.post("/analyzeText", async (req, res) => {
  if (!DEEPSEEK_API_KEY) {
    console.error("DeepSeek API Key is missing");
    return res.status(500).json({ error: "DeepSeek 키 누락" });
  }

  const { conversationLog } = req.body;
  if (!conversationLog) {
    console.error("Missing conversationLog in request body");
    return res.status(400).json({ error: "conversationLog is required" });
  }

  try {
    const apiRes = await axios.post(
      "https://api.deepseek.com/v1/chat/completions",
      {
        model: "deepseek-chat",
        messages: [{ role: "user", content: conversationLog }],
        temperature: 1.0,
        max_tokens: 2000,
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${DEEPSEEK_API_KEY}`,
        },
        timeout: 30000,
      }
    );

    console.log("DeepSeek API Response:", apiRes.data);
    res.status(200).json(apiRes.data);
  } catch (err) {
    console.error("DeepSeek API Error:", err.response?.data || err.message);
    res.status(500).json({
      error: "DeepSeek API 요청 실패",
      message: err.response?.data?.message || err.message,
    });
  }
});

// Firebase 함수로 export (1세대 방식)
exports.api = functions.https.onRequest(app);

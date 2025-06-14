module.exports = {
  env: {
    es2022: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: "module",
  },
  extends: [
    "eslint:recommended",
    "plugin:node/recommended"
  ],
  rules: {
    "no-unused-vars": "off",
    "max-len": ["error", { "code": 120 }],
    "indent": ["error", 2],
    "comma-spacing": "off",
    "comma-dangle": "off", // 쉼표 규칙 비활성화
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "error",
    "quotes": ["error", "double", { "allowTemplateLiterals": true }],
    "eol-last": ["error", "always"],
    "node/no-unsupported-features/es-syntax": "off",
    "no-console": "off"
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true
      },
      rules: {}
    }
  ],
  globals: {}
};

const express = require("express");
const axios = require("axios");
const router = express.Router();

const AI_SERVICE_URL = process.env.AI_SERVICE_URL || "http://ai-assistant-service:4003";

router.post("/analyze", async (req, res, next) => {
  try {
    const r = await axios.post(`${AI_SERVICE_URL}/analyze`, req.body);
    res.json(r.data);
  } catch (e) {
    next(e);
  }
});

router.get("/health", async (req, res, next) => {
  try {
    const r = await axios.get(`${AI_SERVICE_URL}/health`);
    res.json(r.data);
  } catch (e) {
    next(e);
  }
});

module.exports = router;


const express = require("express");
const axios = require("axios");
const router = express.Router();

const AUTH_SERVICE_URL = process.env.AUTH_SERVICE_URL || "http://auth-service:4000";

router.post("/login", async (req, res, next) => {
  try {
    const r = await axios.post(`${AUTH_SERVICE_URL}/login`, req.body);
    res.json(r.data);
  } catch (e) {
    next(e);
  }
});

module.exports = router;

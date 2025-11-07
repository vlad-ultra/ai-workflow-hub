const express = require("express");
const axios = require("axios");
const router = express.Router();

const TASKS_SERVICE_URL = process.env.TASKS_SERVICE_URL || "http://tasks-service:4002";

router.get("/", async (req, res, next) => {
  try {
    const r = await axios.get(`${TASKS_SERVICE_URL}/tasks`);
    res.json(r.data);
  } catch (e) {
    next(e);
  }
});

router.post("/", async (req, res, next) => {
  try {
    const r = await axios.post(`${TASKS_SERVICE_URL}/tasks`, req.body);
    res.json(r.data);
  } catch (e) {
    next(e);
  }
});

module.exports = router;

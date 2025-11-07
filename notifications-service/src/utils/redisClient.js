const Redis = require("ioredis");

const host = process.env.REDIS_HOST || "redis";
const port = process.env.REDIS_PORT || 6379;

const client = new Redis({ host, port });

client.on("error", (err) => {
  console.error("Redis error:", err.message);
});

module.exports = client;

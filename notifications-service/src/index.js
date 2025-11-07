const express = require("express");
const redis = require("./utils/redisClient");
const { sendEmail } = require("./services/email");
const { sendTelegram } = require("./services/telegram");

const app = express();
app.use(express.json());

app.get("/health", (req, res) => {
  res.json({ status: "ok", service: "notifications-service" });
});

// Пример слушателя (в реале тут была бы очередь/канал)
setInterval(async () => {
  // Место для чтения событий из Redis/streams/очереди
}, 5000);

const PORT = process.env.PORT || 4004;
app.listen(PORT, () => console.log(`notifications-service running on ${PORT}`));

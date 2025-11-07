const express = require("express");
const logger = require("./middleware/logger");
const errorHandler = require("./middleware/errorHandler");
const tasksRoutes = require("./routes/tasks");
const authRoutes = require("./routes/auth");
const aiRoutes = require("./routes/ai");

const app = express();
app.use(express.json());
app.use(logger);

app.get("/health", (req, res) => {
  res.json({ status: "ok", service: "api-gateway" });
});

app.use("/tasks", tasksRoutes);
app.use("/auth", authRoutes);
app.use("/ai", aiRoutes);

app.use(errorHandler);

const PORT = 8080;
app.listen(PORT, () => {
  console.log(`API Gateway running on port ${PORT}`);
});

const express = require("express");
const jwt = require("jsonwebtoken");

const app = express();
app.use(express.json());

const PORT = process.env.PORT || 4000;
const JWT_SECRET = process.env.JWT_SECRET || "devsecret";

app.post("/login", (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ error: "email_required" });
  const token = jwt.sign({ sub: email }, JWT_SECRET, { expiresIn: "1h" });
  res.json({ token });
});

app.get("/verify", (req, res) => {
  const auth = req.headers.authorization || "";
  const token = auth.replace("Bearer ", "");
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    res.json({ valid: true, decoded });
  } catch (e) {
    res.status(401).json({ valid: false, error: "invalid_token" });
  }
});

app.get("/health", (req, res) => {
  res.json({ status: "ok", service: "auth-service" });
});

app.listen(PORT, () => console.log(`auth-service running on ${PORT}`));

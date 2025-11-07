const express = require("express");
const app = express();
app.use(express.json());

let users = [
  { id: 1, email: "demo@example.com" }
];

app.get("/users", (req, res) => {
  res.json(users);
});

app.post("/users", (req, res) => {
  const { email } = req.body;
  const id = users.length + 1;
  const user = { id, email };
  users.push(user);
  res.status(201).json(user);
});

app.get("/health", (req, res) => {
  res.json({ status: "ok", service: "user-service" });
});

const PORT = process.env.PORT || 4001;
app.listen(PORT, () => console.log(`user-service running on ${PORT}`));

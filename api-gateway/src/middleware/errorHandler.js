module.exports = (err, req, res, next) => {
  console.error("API Gateway error:", err.message);
  res.status(500).json({ error: "internal_error", details: err.message });
};

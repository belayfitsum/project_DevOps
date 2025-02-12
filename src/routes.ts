import express from "express";
import pool from "./db";

const router = express.Router();

// Insert log
router.post("/log", async (req, res) => {
  try {
    const { data } = req.body;
    const result = await pool.query(
      "INSERT INTO log (data) VALUES ($1) RETURNING *",
      [data]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error" });
  }
});

// Get all logs
router.get("/logs", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM log ORDER BY inserted_at DESC");
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Server error" });
  }
});

export default router;

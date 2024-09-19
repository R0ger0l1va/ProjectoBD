import { pool } from "../../database/db.js";

export const postCobert = async (req, res) => {
  const { nombre_tipo_cobertura } = req.body;
  try {
    const result = await pool.query('SELECT * FROM public.tbtipocobertura_insert($1)', [nombre_tipo_cobertura]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error inserting coverage type:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

export const delCobert = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT public.tbtipocobertura_delete($1)', [id]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error deleting coverage type:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

export const getCobert = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT * FROM public.tbtipocobertura_read($1)', [id]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error reading coverage type:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}



export const putCobert = async (req, res) => {
  const { id } = req.params;
  const { nombre_tipo_cobertura } = req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbtipocobertura_update($1, $2)",
      [id, nombre_tipo_cobertura]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error updating coverage type:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
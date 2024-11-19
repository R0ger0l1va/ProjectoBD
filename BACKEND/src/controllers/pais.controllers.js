import { pool } from "../../database/db.js";

export const postPais = async (req, res) => {
  const  {nombre_pais}  = req.body;
  try {
    const result = await pool.query('SELECT * FROM public.tbpais_insert($1)', [nombre_pais]);
    res.json(result.rows[0]);
  } catch (error) {
    console.log(error);
    console.error('Error inserting country:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

export const delPais = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT public.tbpais_delete($1)', [id]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error deleting country:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

export const putPais = async (req, res) => {
  const { id } = req.params;
  const { nombre_pais } = req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbpais_update($1, $2)",
      [id, nombre_pais]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error updating country:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
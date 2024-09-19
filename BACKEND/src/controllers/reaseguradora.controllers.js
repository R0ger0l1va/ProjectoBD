import { pool } from "../../database/db.js";

export const postReas = async (req, res) => {
  const { id_pais, id_tipo_reaseguro, nombre_compannia_reaseguradora } =
    req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbcompreaseguradora_insert($1, $2, $3)",
      [id_pais, id_tipo_reaseguro, nombre_compannia_reaseguradora]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error inserting reinsurance company:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
}

export const getAllReas = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbcompreaseguradora_read_all()"
    );
    res.json(result.rows);
  } catch (error) {
    console.error("Error reading reinsurance companies:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const putReas = async (req, res) => {
  const { id } = req.params;
  const { id_pais, id_tipo_reaseguro, nombre_compannia_reaseguradora } =
    req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbcompreaseguradora_update($1, $2, $3, $4)",
      [id, id_pais, id_tipo_reaseguro, nombre_compannia_reaseguradora]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error updating reinsurance company:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
}

export const delReas = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query(
      "SELECT public.tbcompreaseguradora_delete($1)",
      [id]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error deleting reinsurance company:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
}
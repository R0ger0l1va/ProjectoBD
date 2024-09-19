import { pool } from "../../database/db";

export const delRecl = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT public.tbreclamacion_delete($1)', [id]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error deleting claim:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

export const getAllRecl = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbreclamacion_read_all()"
    );
    res.json(result.rows);
  } catch (error) {
    console.error("Error reading claims:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};


export const postRecl = async (req, res) => {
  const { numero_poliza, id_estado_reclamacion, id_tipo_siniestro, fecha_siniestro, monto_reclamado, monto_indemnizado } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM public.tbreclamacion_insert($1, $2, $3, $4, $5, $6)',
      [numero_poliza, id_estado_reclamacion, id_tipo_siniestro, fecha_siniestro, monto_reclamado, monto_indemnizado]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error inserting claim:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}


export const putRecl = async (req, res) => {
  const { id } = req.params;
  const { numero_poliza, id_estado_reclamacion, id_tipo_siniestro, fecha_siniestro, monto_reclamado, monto_indemnizado } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM public.tbreclamacion_update($1, $2, $3, $4, $5, $6, $7)',
      [id, numero_poliza, id_estado_reclamacion, id_tipo_siniestro, fecha_siniestro, monto_reclamado, monto_indemnizado]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating claim:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}
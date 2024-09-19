import { pool } from "../../database/db.js";

export const postAgencia = async (req, res) => {
  const { nombre_agencia_seguro, direccion_postal, telefono, correo_electronico, nombre_director_general, nombre_jefe_departamento_seguros, nombre_jefe_departamento_reclamaciones } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM public.tbagenciaseguro_insert($1, $2, $3, $4, $5, $6, $7)',
      [nombre_agencia_seguro, direccion_postal, telefono, correo_electronico, nombre_director_general, nombre_jefe_departamento_seguros, nombre_jefe_departamento_reclamaciones]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error inserting agency:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};

export const getAgencia = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT * FROM public.tbagenciaseguro_read($1)', [id]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error reading agency:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
}

export const delAgencia  = async (req, res) => {
  const { id } = req.params;
  try {
    const result = await pool.query('SELECT public.tbagenciaseguro_delete($1)', [id]);
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error deleting agency:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
};


export const putAgencia = async (req, res) => {
  const { id } = req.params;
  const {
    nombre_agencia_seguro,
    direccion_postal,
    telefono,
    correo_electronico,
    nombre_director_general,
    nombre_jefe_departamento_seguros,
    nombre_jefe_departamento_reclamaciones,
  } = req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbagenciaseguro_update($1, $2, $3, $4, $5, $6, $7, $8)",
      [
        id,
        nombre_agencia_seguro,
        direccion_postal,
        telefono,
        correo_electronico,
        nombre_director_general,
        nombre_jefe_departamento_seguros,
        nombre_jefe_departamento_reclamaciones,
      ]
    );
    res.json(result.rows[0]);
  } catch (error) {
    console.error("Error updating agency:", error);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
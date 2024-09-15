import { pool } from "../../database/db.js";


export const getPoliza = async (req, res) => {
  const id = req.params.id;
  try {
    const result = await pool.query("SELECT * FROM public.tbpoliza_read($1)", [
      id,
    ]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send("Póliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const getPolizas = async (req, res) => {
  const {id_usuario} = req.params
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbpoliza_read_all($1)",
      [id_usuario]
    );
    if (result.rows.length > 0) {
      res.json(result.rows);
    } else {
      res.status(404).send("Póliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
}; 

export const crearPoliza = async (req, res) => {
  const {
    id_agencia_seguro,
    numero_identidad_cliente,
    id_estado_poliza,
    id_tipo_seguro,
    fecha_inicio,
    fecha_fin,
    prima_mensual,
    monto_total_asegurado,
    id_tipo_cobertura,
  } = req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbpoliza_insert($1, $2, $3, $4, $5, $6, $7, $8, $9)",
      [
        id_agencia_seguro,
        numero_identidad_cliente,
        id_estado_poliza,
        id_tipo_seguro,
        fecha_inicio,
        fecha_fin,
        prima_mensual,
        monto_total_asegurado,
        id_tipo_cobertura,
      ]
    );
    res.json(result.rows[0]);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const borrarPoliza = async (req, res) => {
  const id = req.params.id;
  try {
    const result = await pool.query("SELECT public.tbpoliza_delete($1)", [id]);
    if (result.rows[0].tbpoliza_delete) {
      res.send("Póliza eliminada exitosamente");
    } else {
      res.status(404).send("Póliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const updPoliza = async (req, res) => {
  const id = req.params.id;
  const {
    id_agencia_seguro,
    numero_identidad_cliente,
    id_estado_poliza,
    id_tipo_seguro,
    fecha_inicio,
    fecha_fin,
    prima_mensual,
    monto_total_asegurado,
    id_tipo_cobertura,
  } = req.body;

  try {
    const result = await pool.query(
      "SELECT * FROM public.tbpoliza_update($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
      [
        id,
        id_agencia_seguro,
        numero_identidad_cliente,
        id_estado_poliza,
        id_tipo_seguro,
        fecha_inicio,
        fecha_fin,
        prima_mensual,
        monto_total_asegurado,
        id_tipo_cobertura,
      ]
    );

    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send("Póliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
};
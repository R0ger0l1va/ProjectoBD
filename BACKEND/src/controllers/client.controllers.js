import { pool } from "../../database/db.js";

export const getClient = async (req, res) => {
  const {id_cliente} = req.params
  try {
    const result = await pool.query("SELECT * FROM public.tbcliente_read($1)", [
      id_cliente,
    ]);
    
      res.json(result.rows);
    
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const crearCliente = async (req, res) => {
  const {
    numero_id_cliente,
    id_pais,
    id_sexo,
    nombre_cliente,
    apellido_cliente,
    edad,
    direccion_postal,
    telefono,
    correo_electronico,
    carnet_identidad,
  } = req.body;
  try {
    const result = await pool.query(
      "SELECT * from public.tbcliente_insert($1, $2, $3, $4, $5, $6, $7, $8, $9,$10)",
      [
        numero_id_cliente,
        id_pais,
        id_sexo,
        nombre_cliente,
        apellido_cliente,
        edad,
        direccion_postal,
        telefono,
        correo_electronico,
        carnet_identidad,
      ]
    );
    res.json(result.rows[0]);
  } catch (error) {
    res.send(error.message);
  }
};

export const borrarCliente = async (req, res) => {
  const {id} = req.params;
  try {
    const result = await pool.query("SELECT public.tbcliente_delete($1)", [id]);
    if (result.rows[0].tbcliente_delete) {
      res.send("Cliente eliminado exitosamente");
    } else {
      res.status(404).send("Cliente no encontrado");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const actualizarCliente = async (req, res) => {
  
  const {
    numero_id_cliente,
    id_pais,
    id_sexo,
    nombre_cliente,
    apellido_cliente,
    edad,
    direccion_postal,
    telefono,
    correo_electronico,
    carnet_identidad,
  } = req.body;
  try {
    const result = await pool.query(
      "SELECT * FROM public.tbcliente_update($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
      [
        numero_id_cliente,
        id_pais,
        id_sexo,
        nombre_cliente,
        apellido_cliente,
        edad,
        direccion_postal,
        telefono,
        correo_electronico,
        carnet_identidad,
      ]
    );
    
      res.json(result.rows);
    
  } catch (error) {
    console.log(error.message);
    
    res.status(500).send(error.message);
  }
};

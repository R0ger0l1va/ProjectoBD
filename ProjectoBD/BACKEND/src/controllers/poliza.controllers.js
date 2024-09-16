import { pool } from "../../database/db.js";

//todo TODOS los Datos Faltantes

export const getAllAgencias = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM public.tbagenciaseguro_read_all()');
    res.json(result.rows);
  } catch (error) {
    res.status(500).send(error.message);
  }
}

export const getAllTipoSeguros = async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM public.tbtiposeguro_read_all()");
    res.json(result.rows);
  } catch (error) {
    res.status(500).send(error.message);
  }
};

export const getAllCoberturas = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM public.tbtipocobertura_read_all()');
    res.json(result.rows);
  } catch (error) {
    res.status(500).send(error.message);
  }
}

export const getAllClientes =async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM public.tbcliente_read_all()');
    res.json(result.rows);
  } catch (error) {
    res.status(500).send(error.message);
  }
}










//todo Datos Faltantes
 export const getSegurosAgencia = async (req, res) => {
  const {id_agencia_seguro} = req.params;
  try {
    const result = await pool.query("SELECT * FROM public.tbsegurosdeagencia_read($1)", [
      id_agencia_seguro
    ]);
    if (result.rows.length > 0) {
      const nombresTipoSeguro = result.rows.map(
        (row) => row.nombre_tipo_seguro
      );
      res.json(nombresTipoSeguro);
    } else {
      res.status(404).send("Agencia no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
}

export const getEstadoPoliza = async (req, res) => {
  const {id_estado_poliza} = req.params;
  try {
    const result = await pool.query("SELECT * FROM public.tbestadopoliza_read($1)", [
      id_estado_poliza,
    ]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send("Estado de Poliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
}


export const getTipoCobertura = async (req, res) => {
  const { id_tipo_cobertura } = req.params;
  try {
    const result = await pool.query("SELECT * FROM public.tbtipocobertura_read($1)", [
      id_tipo_cobertura,
    ]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send("Póliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
}


export const getAgencia = async (req, res) => {
  const { id_agencia_seguro } = req.params
  try {
    const result = await pool.query("SELECT * FROM public.tbagenciaseguro_read($1)", [
      id_agencia_seguro,
    ]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send("Póliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
}


export const getTipoSeguro = async (req, res) => {
  const { id_tipo_seguro } = req.params;
  try {
    const result = await pool.query("SELECT * FROM public.tbtiposeguro_read($1)", [
      id_tipo_seguro,
    ]);
    if (result.rows.length > 0) {
      res.json(result.rows[0]);
    } else {
      res.status(404).send("Póliza no encontrada");
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
}

//todo CRUD
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
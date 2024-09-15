import { pool } from "../../database/db.js";

export const getUsers = async (req, res) => {
  const { rows } = await pool.query('Select * from "tbUsuarios"');
  res.json({ rows });
};

export const getLoginUser = async (req, res) => {
  const { id_usuario } = req.body;
  console.log(id_usuario);
  try {
    const result = await pool.query(
      "select * from public.tbusuarios_read($1)",
      [id_usuario]
    );
    console.log(result.rows[0].rol);
    res.status(200).json({ result: result.rows[0].rol });
  } catch (error) {
    console.error("Error al obtener el usuario:", error);
    res.status(500).json({ message: "Error interno del servidor" });
  }
};

export const signIn = async (req, res) => {
  const { id_usuario, contrasenna } = req.body;

  try {
    const result = await pool.query(
      "select * from public.tbusuarios_read($1)",
      [id_usuario]
    );
    if (result.rows[0].contrasenna === contrasenna) {
      switch (result.rows[0].rol) {
        case "Cliente":
          res.status(200).json({
            Usuario: result.rows[0],
            message: "Se ha logueado como Vendedor",
          });
          break;
        case "Vendedor":
          res.status(200).json({
            Usuario: result.rows[0],
            message: "Se ha logueado como Vendedor",
          });
          break;
        case "AdminGen":
          res.status(200).json({
            Usuario: result.rows[0],
            message: "Se ha logueado como AdminGen",
          });
          break;
        default:
          res.status(400).json({
            message: "Rol desconocido",
          });
          break;
      }
    } else {
      res.status(401).json({
        message: "contraseña incorrecta",
      });
    }
  } catch (error) {
    res.status(404).json({
      message: "El usuario no existe",
    });
  }
};

export const signUp = async (req, res) => {
  const { id_usuario, nombre_usuario, contrasenna } = req.body;
  try {
    await pool.query("Select public.tbusuarios_insert($1,$2,$3,$4)", [
      id_usuario,
      nombre_usuario,
      contrasenna,
      "Cliente",
    ]);

    res.status(200).json({
      message: "Se ha registrado como Cliente",
      tbUsuarios: { id_usuario, nombre_usuario, contrasenna },
    });
  } catch (error) {
    console.log(error);
    if (error?.code === "23505") {
      return res.status(409).json({ message: "Ya existe este usuario" });
    }
    return res.status(500).json({ message: "Internal Server ERROR" });
  }
};
export const deleteUser = async (req, res) => {
  const { nombre_usuario, contrasenna } = req.body;
  const { result } = await pool.query(
    "SELECT public.tbusuarios_delete($1, $2)",
    [nombre_usuario, contrasenna]
  );
  if (result.rows[0].tbusuarios_delete) {
    res.send("Usuario eliminado exitosamente");
  } else {
    res.status(404).send("No se pudo eliminar el usuario");
  }
};
export const updateUser = async (req, res) => {
  const { id_usuario } = req.params;
  const data = req.body;
  const result = await pool.query(
    "select  public.tbusuarios_update($1,$2,$3,$4)",
    [id_usuario, data.nombre_usuario, data.contrasenna, data.rol]
  );
  console.log(result);
  res.send("actualizando usuario" + id_usuario);
};

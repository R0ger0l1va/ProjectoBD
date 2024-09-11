
import { pool } from "../db.js"

export const getUsers = async (req, res) => {
    const { rows } = await pool.query('Select * from "tbUsuarios"')
    res.json({ rows })
}

export const getUser = async (req, res) => {
    const { rol } = req.params
    const { rows } = await pool.query('select * from "tbUsuarios" where rol = $1', [rol])
    if (rows.length === 0) {
        return res.status(404).json({ message: "Usuario no encontrado" })
    }
    res.json(rows)

}

export const createUser = async (req, res) => {
    try {
        const { id_usuario,nombre_usuario, contrasenna, rol } = req.body
        const result = await pool.query('Select public.tbusuarios_insert($1,$2,$3,$4)',
            [id_usuario,nombre_usuario, contrasenna, rol]
        )
        console.log(result)
        return res.json(result.rows[0])

    } catch (error) {
        console.log(error)
        if (error?.code === "23505") {
            return res.status(409).json({message: "Ya existe este usuario"})
        }
        return res.status(500).json({message: "Internal Server ERROR"})
    }

    

}
export const deleteUser = async (req, res) => {
    const { nombre_usuario, contrasenna } = req.body;
    const { result } = await pool.query(
        'SELECT public.tbusuarios_delete($1, $2)',
        [nombre_usuario, contrasenna]
    );
    if (result.rows[0].tbusuarios_delete) {
        res.send("Usuario eliminado exitosamente");
    } else {
        res.status(404).send("No se pudo eliminar el usuario");
    }

}
export const updateUser = async (req, res) => {
    const { id_usuario } = req.params
    const data = req.body
    const result = await pool.query('select  public.tbusuarios_update($1,$2,$3,$4)',
        [id_usuario, data.nombre_usuario, data.contrasenna, data.rol,]
    )
    console.log(result)
    res.send("actualizando usuario" + id_usuario)


}
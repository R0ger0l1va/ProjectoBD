
import { pool } from "../../database/db.js"

export const getUsers = async (req, res) => {
    const { rows } = await pool.query('Select * from "tbUsuarios"')
    res.json({ rows })
}

export const signIn = async (req, res) => {
    const { id_usuario, contrasenna,rol } = req.body
    if (rol==='Admin') {
        try {
            const result = await pool.query('select * from public.tbusuarios_read($1)', [id_usuario])          
            if (result.rows[0].rol === 'Admin' && result.rows[0].contrasenna === contrasenna) {
                res.send(result)
            }
            else {
                res.status(500).json({
                    message: 'El usuario encontrado no es Admin'

                })
}
        } catch (error) {
            res.status(500).json({
                message: 'Ha ocurrido un error'
                
            })
        }
    }

    else if (rol === "Cliente") {
        try {
            const result = await pool.query('select * from public.tbusuarios_read($1)', [id_usuario])
            if (result.rows[0].rol === 'Cliente' && result.rows[0].contrasenna===contrasenna) {
                res.send(result)
            }
            else {
                res.status(500).json({
                    message: 'El usuario encontrado no es Cliente'

                })
            }
        } catch (error) {
            res.status(500).json({
                message: 'Ha ocurrido un error'

            })
        }
    }
    
    

}

export const signUp = async (req, res) => {
    const { id_usuario, nombre_usuario, contrasenna, rol } = req.body
    if (rol ==='Admin') {
        try {

            await pool.query('Select public.tbusuarios_insert($1,$2,$3,$4)',
                [id_usuario, nombre_usuario, contrasenna, rol]
            );
            
            res.status(200).json({
                message: "Se ha registrado como Admin",
                tbUsuarios: { id_usuario, nombre_usuario, contrasenna },
            });

        } catch (error) {
            console.log(error)
            if (error?.code === "23505") {
                return res.status(409).json({ message: "Ya existe este usuario" })
            }
            return res.status(500).json({ message: "Internal Server ERROR" })
        }
    }
    else if(rol==='Cliente'){
        try {

            await pool.query('Select public.tbusuarios_insert($1,$2,$3,$4)',
                [id_usuario, nombre_usuario, contrasenna, rol]
            );

            res.status(200).json({
                message: "Se ha registrado como Cliente",
                tbUsuarios: { id_usuario, nombre_usuario, contrasenna },
            });

        } catch (error) {
            console.log(error)
            if (error?.code === "23505") {
                return res.status(409).json({ message: "Ya existe este usuario" })
            }
            return res.status(500).json({ message: "Internal Server ERROR" })
        }
        
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
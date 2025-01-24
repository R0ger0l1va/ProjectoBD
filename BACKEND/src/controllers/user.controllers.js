import {pool} from "../../database/db.js";
import jwt from "jsonwebtoken"
import bcryptjs from 'bcryptjs'

export const getSex = async (req, res) => {
    try {
        const result = await pool.query('select * from tbsexo_read_all()')
        res.json(result.rows)
    } catch (error) {
        console.error("Error al obtener los sexos :", error);
        res.status(500).json({message: "Error interno del servidor"});

    }
}

export const getPais = async (req, res) => {
    try {
        const result = await pool.query('select * from tbpais_read_all()')
        res.status(200).json(result.rows)
    } catch (error) {
        console.error("Error al obtener los paises :", error);
        res.status(500).json({message: "Error interno del servidor"});

    }
}

export const getUser = async (req, res) => {
    const {id_usuario} = req.params;
    console.log(id_usuario);
    try {
        const result = await pool.query(
            "select * from public.tbusuarios_read($1)",
            [id_usuario]
        );
        console.log(result.rows[0]);
        res.status(200).json(result.rows);
    } catch (error) {
        console.error("Error al obtener el usuario:", error);
        res.status(500).json({message: "Error interno del servidor"});
    }
};

export const getAllUsers = async (req, res) => {
    try {
        const result = await pool.query(
            "Select * from tbusuarios_read_all()"
        );
        res.json(result.rows);
    } catch (error) {
        console.error("Error al obtener los usuarios:", error);
        res.status(500).send(error.message);
    }

};

export const getLoginUser = async (req, res) => {
    const {id_usuario} = req.body;
    console.log(id_usuario);
    try {
        const result = await pool.query(
            "select * from public.tbusuarios_read($1)",
            [id_usuario]
        );
        console.log(result.rows[0].rol);
        res.status(200).json({result: result.rows[0].rol});
    } catch (error) {
        console.error("Error al obtener el usuario:", error);
        res.status(500).json({message: "Error interno del servidor"});
    }
};

export const postTrabajador = async (req, res) => {
    const {nombre, contrasenna, rol,id_usuario} = req.body;
    const nombre_usuario = nombre
    const salt = await bcryptjs.genSalt(10)
    const hashedPassword = await bcryptjs.hash(contrasenna, salt)
    const token = jwt.sign({user_id: id_usuario,user_rol:rol},
        process.env.JWT_SECRET,
        {expiresIn: "1h"})
    try {
        
        const result = await pool.query(
            "Select * from public.tbusuarios_insert($1,$2,$3)",
            [nombre_usuario, hashedPassword, rol]
        );

        res.status(200).json({
            message: "Se ha registrado como " + rol,
            id_usuario: result.rows[0].id_usuario,
            ok: true,msg: token
        });
    } catch (error) {
        console.log(error);
        if (error?.code === "23505") {
            return res.status(409).json({message: "Ya existe este usuario"});
        }
        return res.status(500).json({message: "Internal Server ERROR"});
    }
};

export const profile = async (req,res)=>{
    try{
        
        
        const result = await pool.query(
            "select * from public.tbusuarios_read($1)",
            [req.user]
        );
        
        return res.json({ok:true,msg: result.rows[0]})

    }
    catch(error){
        console.log(error);
        return res.status(500).json({
            ok:false,
            msg: "Error server"
        })
        
    }
}

export const signIn = async (req, res) => {
    const {id_usuario, contrasenna,nombre_usuario,rol} = req.body;

    try {
        const result = await pool.query(
            "select * from public.tbusuarios_read($1)",
            [id_usuario]
        );
        const token = jwt.sign({user_id: id_usuario,user_rol:rol},
            process.env.JWT_SECRET,
            {expiresIn: "1h"})

        const isMatch = await bcryptjs.compare(contrasenna,result.rows[0].contrasenna)
        if (isMatch) {
           
                
            switch (result.rows[0].rol) {
                case "Cliente":
                    res.status(200).json({
                        Usuario: result.rows[0],
                        message: "Se ha logueado como Cliente",
                        ok: true,msg: token
                    });
                    break;
                case "Trabajador":
                    res.status(200).json({
                        Usuario: result.rows[0],
                        message: "Se ha logueado como Vendedor",
                        ok: true,msg: token
                    });
                    break;
                case "AdminGen":
                    res.status(200).json({
                        Usuario: result.rows[0],
                        message: "Se ha logueado como AdminGen",
                        ok: true,msg: token
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
    const {nombre_usuario, contrasenna} = req.body;

    const salt = await bcryptjs.genSalt(10)
    const hashedPassword = await bcryptjs.hash(contrasenna, salt)

    try {
        const result = await pool.query("Select * from public.tbusuarios_insert($1,$2,$3)", [

            nombre_usuario,
            hashedPassword,
            "Cliente",
        ]);

        const token = jwt.sign({user: nombre_usuario},
            process.env.JWT_SECRET,
            {expiresIn: "1h"})


        res.status(200).json({
            message: "Se ha registrado como Cliente",
            ok: true,
            msg: token,
            id_usuario: result.rows[0].id_usuario,
        });
    } catch (error) {
        console.log(error);
        if (error?.code === "23505") {
            return res.status(409).json({message: "Ya existe este usuario"});
        }
        return res.status(500).json({message: "Internal Server ERROR"});
    }
};
export const deleteUser = async (req, res) => {
    const {id_usuario} = req.params;
    const result = await pool.query(
        "SELECT  public.tbusuarios_delete($1)",
        [id_usuario]
    );
    if (result.rows[0].tbusuarios_delete) {
        res.send("Usuario eliminado exitosamente");
    } else {
        res.status(404).send("No se pudo eliminar el usuario");
    }
};
export const updateUser = async (req, res) => {
    const {id_usuario} = req.params
    const data = req.body;

    const result = await pool.query(
        "select public.tbusuarios_update($1,$2,$3)",
        [id_usuario, data.nombre, data.rol]
    );
    const token = jwt.sign({user_id: id_usuario,user_rol:data.rol},
        process.env.JWT_SECRET,
        {expiresIn: "1h"})

    console.log(result);
    res.send("actualizando usuario" + id_usuario);
    res.json(result.rows[0]);


};

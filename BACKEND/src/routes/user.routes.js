import { Router } from "express"
import { pool } from "../db.js"

const router = Router()
router.get('/users', async (req, res) => {
    const {rows} = await pool.query('Select * from "tbUsuarios"')
    res.json({rows})
})

router.get('/users/:rol',async (req, res) => {
    const { rol } = req.params
    const { rows } = await pool.query('select * from "tbUsuarios" where rol = $1', [rol])
    if (rows.length===0) {
        return res.status(404).json({message: "Usuario no encontrado"})
    }
    res.json(rows)

})
router.post('/users', async(req, res) => {
    const { nombre_usuario, contrasenna, rol } = req.body
    const result = await pool.query('Select public.tbusuarios_insert($1,$2,$3)',
        [nombre_usuario, contrasenna, rol]
    )
    console.log(result)
    return res.json(rows[0])
    
    
})
router.delete('/users',async (req, res) => {
    const { nombre_usuario, contrasenna } = req.body;
    const {result} = await pool.query(
        'SELECT public.tbusuarios_delete($1, $2)',
        [nombre_usuario, contrasenna]
    );
    if (result.rows[0].tbusuarios_delete) {
        res.send("Usuario eliminado exitosamente");
    } else {
        res.status(404).send("No se pudo eliminar el usuario");
    }
    
})
router.put('/users/:id_usuario', async (req, res) => {
    const { id_usuario } = req.params
    const data = req.body
  const result =  await pool.query('select  public.tbusuarios_update($1,$2,$3,$4)',
      [ id_usuario,data.nombre_usuario,data.contrasenna, data.rol,] 
    )     
    console.log(result) 
    res.send("actualizando usuario" + id_usuario)
    
    
})
export default router
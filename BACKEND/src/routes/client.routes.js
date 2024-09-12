import { Router } from "express";

const router = Router()


app.get('/cliente/:id', async (req, res) => {
    const id = req.params.id;
    try {
        const result = await pool.query('SELECT * FROM public.tbcliente_read($1)', [id]);
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).send('Cliente no encontrado');
        }
    } catch (error) {
        res.status(500).send(error.message);
    }
});
app.post('/cliente', async (req, res) => {
    const { id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad } = req.body;
    try {
        const result = await pool.query(
            'SELECT * FROM public.tbcliente_insert($1, $2, $3, $4, $5, $6, $7, $8, $9)',
            [id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad]
        );
        res.json(result.rows[0]);
    } catch (error) {
        res.status(500).send(error.message);
    }
});
app.delete('/cliente/:id', async (req, res) => {
    const id = req.params.id;
    try {
        const result = await pool.query('SELECT public.tbcliente_delete($1)', [id]);
        if (result.rows[0].tbcliente_delete) {
            res.send('Cliente eliminado exitosamente');
        } else {
            res.status(404).send('Cliente no encontrado');
        }
    } catch (error) {
        res.status(500).send(error.message);
    }
});
app.put('/cliente/:id', async (req, res) => {
    const id = req.params.id;
    const { id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad } = req.body;
    try {
        const result = await pool.query(
            'SELECT * FROM public.tbcliente_update($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)',
            [id, id_pais, id_sexo, nombre_cliente, apellido_cliente, edad, direccion_postal, telefono, correo_electronico, carnet_identidad]
        );
        if (result.rows.length > 0) {
            res.json(result.rows[0]);
        } else {
            res.status(404).send('Cliente no encontrado');
        }
    } catch (error) {
        res.status(500).send(error.message);
    }
});
 
export default router
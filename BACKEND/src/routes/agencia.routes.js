import Router from "express"
import { delAgencia, getAgencia, postAgencia, putAgencia } from "../controllers/agencia.controllers.js";

const router = Router()

// Controlador para tbagenciaseguro_delete
router.delete('/delAgencia/:id', delAgencia )

// Controlador para tbagenciaseguro_insert
router.post('/insertAgencia', postAgencia )

// Controlador para tbagenciaseguro_read
router.get('/getAgencia/:id', getAgencia);

// Controlador para tbagenciaseguro_update
router.put('/updAgencia/:id', putAgencia);

export default router
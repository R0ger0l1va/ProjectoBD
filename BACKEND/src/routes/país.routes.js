import { Router } from "express"
import { delPais, postPais, putPais } from "../controllers/pais.controllers.js";

const router = Router()

// Controlador para tbpais_delete
router.delete('/delPais/:id', delPais );

// Controlador para tbpais_insert
router.post('/insertPais', postPais);

// Controlador para tbpais_update
router.put('/updPais/:id', putPais);

export default router
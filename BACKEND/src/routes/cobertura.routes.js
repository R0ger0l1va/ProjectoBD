import { Router } from "express";
import { delCobert, getCobert, postCobert, putCobert } from "../controllers/cobertura.controllers.js";

const router = Router();

// Controlador para tbtipocobertura_delete
router.delete('/delCobertura/:id', delCobert);

// Controlador para tbtipocobertura_insert
router.post('/insertCobertura', postCobert );

// Controlador para tbtipocobertura_read
router.get('/getCobertura/:id', getCobert);

// Controlador para tbtipocobertura_update
router.put('/updCobertura/:id', putCobert);

export default router;

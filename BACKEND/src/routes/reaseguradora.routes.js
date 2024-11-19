import {Router} from "express"
import { delReas, getAllReas, postReas, putReas } from "../controllers/reaseguradora.controllers.js";

const router = Router()

router.delete("/delReaseguradora/:id", delReas);

// Controlador para tbcompreaseguradora_insert
router.post("/insertReaseguradora", postReas);

// Controlador para tbcompreaseguradora_update
router.put("/updReaseguradora/:id", putReas);

// Controlador para tbcompreaseguradora_read_all
router.get("/getReaseguradora", getAllReas);

export default router
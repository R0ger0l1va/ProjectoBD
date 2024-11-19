import { Router } from "express";
import { delRecl, getAllRecl, postRecl, putRecl } from "../controllers/reclamaciones.controllers.js";

const router = Router()

// Controlador para tbreclamacion_delete
router.delete("/delReclamacion/:id", delRecl);

// Controlador para tbreclamacion_insert
router.post("/insertReclamacion", postRecl);

// Controlador para tbreclamacion_update
router.put("/updReclamacion/:id", putRecl);

// Controlador para tbreclamacion_read_all
router.get("/getReclamacion", getAllRecl);


export default router
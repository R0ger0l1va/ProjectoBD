import { Router } from "express";

const router = Router()

// Controlador para tbreclamacion_delete
router.delete("/delReclamacion/:id");

// Controlador para tbreclamacion_insert
router.post("/insertReclamacion");

// Controlador para tbreclamacion_update
router.put("/updReclamacion/:id");

// Controlador para tbreclamacion_read_all
router.get("/getReclamacion");


export default router
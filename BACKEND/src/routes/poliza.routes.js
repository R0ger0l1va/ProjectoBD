import { Router } from "express";
import {
  borrarPoliza,
  crearPoliza,
  getPoliza,
  getPolizas,
  updPoliza,
} from "../controllers/poliza.controllers.js";

const router = Router();

router.get("/getPoliza", getPoliza);
router.get("/getPolizas",getPolizas)
router.post("/postPoliza", crearPoliza);
router.delete("/delPoliza", borrarPoliza);
router.put("/actPoliza", updPoliza);

export default router;

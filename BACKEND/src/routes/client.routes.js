import { Router } from "express";
import {
  actualizarCliente,
  borrarCliente,
  crearCliente,
  getClient,
} from "../controllers/client.controllers.js";

const router = Router();

router.get("/getCliente", getClient);
router.post("/postCliente", crearCliente);
router.delete("/delCliente", borrarCliente);
router.put("/updCliente", actualizarCliente);

export default router;

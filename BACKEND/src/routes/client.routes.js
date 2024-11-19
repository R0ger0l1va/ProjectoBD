import { Router } from "express";
import {
  actualizarCliente,
  borrarCliente,
  crearCliente,
  getClient,
} from "../controllers/client.controllers.js";

const router = Router();

router.get("/getCliente/:id_cliente", getClient);
router.post("/postCliente", crearCliente);
router.delete("/delCliente/:id", borrarCliente);
router.put("/updCliente/:id", actualizarCliente);

export default router;

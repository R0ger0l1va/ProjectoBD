import { Router } from "express";
import {
  actualizarCliente,
  borrarCliente,
  crearCliente,
  getClient,
} from "../controllers/client.controllers.js";
import { verifyRoles, verifyToken } from "../middlewares/jwt.middleware.js";

const router = Router();

router.get("/getCliente/:id_cliente",verifyToken,verifyRoles(['AdminGen','Trabajador']), getClient);
router.post("/postCliente",verifyToken,verifyRoles(['AdminGen','Trabajador']), crearCliente);
router.delete("/delCliente/:id",verifyToken,verifyRoles(['AdminGen','Trabajador']), borrarCliente);
router.put("/updCliente/:id", actualizarCliente);

export default router;

import { Router } from "express";
import {
  actualizarCliente,
  borrarCliente,
  crearCliente,
  getClient,
} from "../controllers/client.controllers";

const router = Router();

app.get("/getCliente", getClient);
app.post("/postCliente", crearCliente);
app.delete("/delCliente", borrarCliente);
app.put("/updCliente", actualizarCliente);

export default router;

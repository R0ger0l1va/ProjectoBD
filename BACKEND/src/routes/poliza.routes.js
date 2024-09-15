import { Router } from "express";
import {
  borrarPoliza,
  crearPoliza,
  getAgencia,
  getEstadoPoliza,
  getPoliza,
  getPolizas,
  getSegurosAgencia,
  getTipoCobertura,
  getTipoSeguro,
  updPoliza,
} from "../controllers/poliza.controllers.js";

const router = Router();

//todo obtener dato Faltante de Poliza
router.get("/getSegurosAgencia/:id_agencia_seguro",getSegurosAgencia)
router.get("/getTipoSeguro/:id_tipo_seguro",getTipoSeguro)
router.get('/getTipoCobertura/:id_tipo_cobertura',getTipoCobertura);
router.get("/getAgencia/:id_agencia_seguro",getAgencia);
router.get("/getEstadoPoliza/:id_estado_poliza", getEstadoPoliza);

//todo CRUD Polizas
router.get("/getPoliza", getPoliza);
router.get("/getPolizas/:id_usuario", getPolizas);
router.post("/postPoliza", crearPoliza);
router.delete("/delPoliza", borrarPoliza);
router.put("/actPoliza", updPoliza);

export default router;

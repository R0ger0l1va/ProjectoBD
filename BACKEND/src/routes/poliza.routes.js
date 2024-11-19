import {Router} from "express";
import {
  borrarPoliza,
  crearPoliza,
  getAgencia,
  getAllAgencias,
  getAllClientes,
  getAllCoberturas,
  getAllPolizas,
  getAllTipoSeguros,
  getEstadoPoliza,
  getPoliza,
  getPolizas,
  getSegurosAgencia,
  getTipoCobertura,
  getTipoSeguro,
  sortPolizas,
  updPoliza,
} from "../controllers/poliza.controllers.js";

const router = Router();

//todo Operaciones Auxiliares
router.get('/sortPolizas', sortPolizas)


//todo Obtener todos los datos de Tabla de datos faltantes de Poliza
router.get('/getAllPolizas', getAllPolizas)
router.get('/getAllClientes', getAllClientes)
router.get("/getAllAgencias", getAllAgencias);
router.get("/getAllCoberturas", getAllCoberturas);
router.get("/getAllTipoSeguros", getAllTipoSeguros);


//todo obtener dato Faltante de Poliza
router.get("/getSegurosAgencia/:id_agencia_seguro", getSegurosAgencia)
router.get("/getTipoSeguro/:id_tipo_seguro", getTipoSeguro)
router.get('/getTipoCobertura/:id_tipo_cobertura', getTipoCobertura);
router.get("/getAgencia/:id_agencia_seguro", getAgencia);
router.get("/getEstadoPoliza/:id_estado_poliza", getEstadoPoliza);

//todo CRUD Polizas
router.get("/getPoliza/:id", getPoliza);
router.get("/getPolizas/:id_usuario", getPolizas);
router.post("/postPoliza", crearPoliza);
router.delete("/delPoliza/:id", borrarPoliza);
router.put("/actPoliza", updPoliza);

export default router;

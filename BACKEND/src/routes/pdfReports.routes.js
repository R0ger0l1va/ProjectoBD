import { Router } from "express";
import {
  pdf_getAgencia,
  pdf_Report2,
  pdf_report3,
  pdf_report4,
  pdf_report5,
  pdf_report6,
  pdf_salida1,
  pdf_salida2,
  pdf_salida3,
  pdf_salida4,
  pdf_salida5,
  pdf_salida6,
  
} from "../controllers/reportsPDF.controllers.js";

const router = Router();


//todo REPORTES
router.get("/gen-pdf_getAgencia/:id", pdf_getAgencia);
router.get("/gen-pdf_report2/:id", pdf_Report2);
router.get("/gen-pdf_report3/:idCompRe/:idAgencia", pdf_report3);
router.get("/gen-pdf_report4/:fechaInicio/:fechaFin", pdf_report4);
router.get("/gen-pdf_report5",pdf_report5);
router.get("/gen-pdf_report6/:anno",pdf_report6);

//todo SALIDAS
router.get("/gen-pdf_salida1",pdf_salida1);
router.get("/gen-pdf_salida2",pdf_salida2);
router.get("/gen-pdf_salida3",pdf_salida3);
router.get("/gen-pdf_salida4",pdf_salida4);
router.get("/gen-pdf_salida5",pdf_salida5);
router.get("/gen-pdf_salida6",pdf_salida6);


export default router;

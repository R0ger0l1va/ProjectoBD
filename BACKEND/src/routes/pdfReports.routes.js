import { Router } from "express";
import { pdf_getAgencia } from "../controllers/reportsPDF.controllers.js";

const router = Router();

router.get("/gen-pdf_getAgencia/:id", pdf_getAgencia);
router.get('/gen-pdf_report2/:id',)

export default router;

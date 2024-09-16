import { Router } from "express";
import { pdf_getAgencia } from "../controllers/reportsPDF.controllers.js";

const router = Router();

router.get("/gen-pdf_getAgencia/:id", pdf_getAgencia);

export default router;

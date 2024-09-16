import { Router } from "express"
import { jsPDF } from "jspdf"
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const router = Router()

router.get('/generate-pdf', (req, res) => {
    const doc = new jsPDF();

    doc.text("Hello world!", 10, 10);
    doc.text("This is a sample PDF generated using jsPDF.", 10, 20);

    const pdf = doc.output();
    const savePath = path.join(__dirname,'out','sample.pdf')
    fs.mkdirSync(path.dirname(savePath), { recursive: true });
    fs.writeFileSync(savePath, pdf, "binary");
    res.contentType("application/pdf");
    res.send(pdf);
}) 

export default router
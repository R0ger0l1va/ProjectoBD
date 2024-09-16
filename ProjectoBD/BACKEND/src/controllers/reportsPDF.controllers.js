import { pool } from "../../database/db.js";
import { jsPDF } from "jspdf";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const pdf_getAgencia = async (req, res) => {
  const id_agencia_seguro = req.params.id

  try {
    const result = await pool.query(
      "SELECT * FROM obtener_agencia_dadoid($1)",
      [id_agencia_seguro]
    );
    console.log("Resultado de la consulta:", result.rows); // Imprimir los resultados de la consulta

    const data = result.rows[0];

    const doc = new jsPDF();
    doc.text(`ID Agencia Seguro: ${data.id_agencia_seguro}`, 10, 10);
    doc.text(`Nombre Agencia Seguro: ${data.nombre_agencia_seguro}`, 10, 20);
    doc.text(`Dirección Postal: ${data.direccion_postal}`, 10, 30);
    doc.text(`Teléfono: ${data.telefono}`, 10, 40);
    doc.text(`Correo Electrónico: ${data.correo_electronico}`, 10, 50);
    doc.text(
      `Nombre Director General: ${data.nombre_director_general}`,
      10,
      60
    );
    doc.text(
      `Nombre Jefe Departamento Seguros: ${data.nombre_jefe_departamento_seguros}`,
      10,
      70
    );
    doc.text(
      `Nombre Jefe Departamento Reclamaciones: ${data.nombre_jefe_departamento_reclamaciones}`,
      10,
      80
    );

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "pdfs",
      `reporte_agencia_${id_agencia_seguro}.pdf`
    );

    // Asegúrate de que el directorio exista
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    res.status(500).send("Error al generar el PDF");
  }
};

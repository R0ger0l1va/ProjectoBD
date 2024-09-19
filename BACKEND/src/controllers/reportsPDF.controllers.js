import { pool } from "../../database/db.js";
import "jspdf-autotable";
import { jsPDF } from "jspdf";
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";



const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const pdf_getAgencia = async (req, res) => {
  const id_agencia_seguro = req.params.id;

  try {
    const result = await pool.query(
      "SELECT * FROM obtener_agencia_dadoid($1)",
      [id_agencia_seguro]
    );
    console.log("Resultado de la consulta:", result.rows);

    const data = result.rows[0];

    const doc = new jsPDF();


    // Add the table to the PDF
    doc.autoTable({
      head: [["Campo", "Valor"]],
      body: [
        ["ID Agencia Seguro", data.id_agencia_seguro],
        ["Nombre Agencia Seguro", data.nombre_agencia_seguro],
        ["Direccion Postal", data.direccion_postal],
        ["Telefono", data.telefono],
        ["Correo Electronico", data.correo_electronico],
        ["Nombre Director General", data.nombre_director_general],
        [
          "Nombre Jefe Departamento Seguros",
          data.nombre_jefe_departamento_seguros,
        ],
        [
          "Nombre Jefe Departamento Reclamaciones",
          data.nombre_jefe_departamento_reclamaciones,
        ],
      ],
    });

    // Add a title to the PDF
    doc.setFontSize(18);
    doc.text("Reporte de Agencia de Seguros", 14, 10);

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `reporte_agencia_${id_agencia_seguro}.pdf`
    );

    // Ensure the directory exists
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    res.status(500).send("Error al generar el PDF");
  }
};

export const pdf_Report2 = async (req, res) => {
  const id_cliente = req.params.id;

  try {
    const clienteResult = await pool.query(
      "SELECT * FROM obtener_cliente_dadoid($1)",
      [id_cliente]
    );
    const clienteData = clienteResult.rows[0];

    if (!clienteData) {
      return res
        .status(404)
        .send("No se encontró el cliente con el ID proporcionado.");
    }

    const polizasResult = await pool.query(
      "SELECT * FROM obtener_polizas_activas_cantidad_dadoCliente($1)",
      [id_cliente]
    );
    const polizasData = polizasResult.rows;

    const doc = new jsPDF();

    // Add the client data table to the PDF
    doc.autoTable({
      head: [["Campo", "Valor"]],
      body: [
        ["Nombre Cliente", clienteData.nombre_cliente],
        ["Numero Identidad Cliente", clienteData.numero_identidad_cliente],
        ["Telefono", clienteData.telefono],
        ["Direccion Postal", clienteData.direccion_postal],
        ["Correo Electronico", clienteData.correo_electronico],
      ],
    });

    // Add a title to the PDF
    doc.setFontSize(18);
    doc.text("Reporte de Cliente", 14, 10);

    let yPosition = doc.lastAutoTable.finalY + 10;

    for (const poliza of polizasData) {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 10;
      }

      doc.autoTable({
        startY: yPosition,
        head: [["Campo", "Valor"]],
        body: [["Numero de Poliza", poliza.numero_poliza]],
      });

      yPosition = doc.lastAutoTable.finalY + 10;

      const primasResult = await pool.query(
        "SELECT obtener_valor_total_primas_dado_poliza($1) AS valor_total_primas",
        [poliza.numero_poliza]
      );
      const valorTotalPrimas = primasResult.rows[0].valor_total_primas;

      doc.autoTable({
        startY: yPosition,
        head: [["Campo", "Valor"]],
        body: [["Valor Total de Primas", valorTotalPrimas]],
      });

      yPosition = doc.lastAutoTable.finalY + 10;

      const reclamacionesResult = await pool.query(
        "SELECT * FROM obtener_reclamaciones_dado_polizaid($1)",
        [poliza.numero_poliza]
      );
      const reclamacionesData = reclamacionesResult.rows;

      for (const reclamacion of reclamacionesData) {
        if (yPosition > 280) {
          doc.addPage();
          yPosition = 10;
        }

        doc.autoTable({
          startY: yPosition,
          head: [["Campo", "Valor"]],
          body: [
            ["Numero de Reclamacion", reclamacion.numero_reclamacion],
            ["Fecha de Siniestro", reclamacion.fecha_siniestro],
            ["Monto Reclamado", reclamacion.monto_reclamado],
            ["Monto Indemnizado", reclamacion.monto_indemnizado],
          ],
        });

        yPosition = doc.lastAutoTable.finalY + 10;
      }
    }

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `reporte_cliente_${id_cliente}.pdf`
    );

    // Ensure the directory exists
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    res.status(500).send("Error al generar el PDF");
  }
};

export const pdf_report3 = async (req, res) => {
  const idCompRe = req.params.idCompRe;
  const idAgencia = req.params.idAgencia;

  try {
    const compReResult = await pool.query(
      "SELECT * FROM obtener_CompRe_dadoID($1)",
      [idCompRe]
    );
    const compReData = compReResult.rows[0];

    if (!compReData) {
      return res
        .status(404)
        .send(
          "No se encontró la compañía reaseguradora con el ID proporcionado."
        );
    }

    const participacionResult = await pool.query(
      "SELECT * FROM obtener_pParticipacion_dado_idAgen_idCompRe($1, $2)",
      [idCompRe, idAgencia]
    );
    const participacionData = participacionResult.rows;

    const doc = new jsPDF();

    // Add the company data table to the PDF
    doc.autoTable({
      head: [["Campo", "Valor"]],
      body: [
        ["Nombre Compañia Reaseguradora", compReData.nombre_compannia_reaseguradora],
        ["Nombre Pais", compReData.nombre_pais],
        ["Nombre Tipo Reaseguro", compReData.nombre_tipo_reaseguro],
      ],
    });

    // Add a title to the PDF
    doc.setFontSize(18);
    doc.text("Reporte de Compañía Reaseguradora", 14, 10);

    let yPosition = doc.lastAutoTable.finalY + 10;

    for (const participacion of participacionData) {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 10;
      }

      doc.autoTable({
        startY: yPosition,
        head: [["Campo", "Valor"]],
        body: [
          ["Nombre Tipo Seguro", participacion.nombre_tipo_seguro],
          ["Porciento Participacion", participacion.porciento_participacion],
        ],
      });

      yPosition = doc.lastAutoTable.finalY + 10;
    }

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `reporte_comp_reaseguradora_${idCompRe}_agencia_${idAgencia}.pdf`
    );

    // Ensure the directory exists
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    res.status(500).send("Error al generar el PDF");
  }
};

export const pdf_report4 = async (req, res) => {
  const fechaInicio = req.params.fechaInicio;
  const fechaFin = req.params.fechaFin;

  try {
    const polizasResult = await pool.query(
      "SELECT * FROM obtener_polizas_emitidas_dado_periodo_tiempo($1, $2)",
      [fechaInicio, fechaFin]
    );
    const polizasData = polizasResult.rows;

    if (polizasData.length === 0) {
      return res
        .status(404)
        .send(
          "No se encontraron pólizas emitidas en el periodo de tiempo proporcionado."
        );
    }

    const doc = new jsPDF();

    // Add a title to the PDF
    doc.setFontSize(18);
    doc.text("Reporte de Pólizas Emitidas", 14, 10);

    let yPosition = 20;

    polizasData.forEach((poliza, index) => {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 20; // Reiniciar la posición Y para la nueva página
      }

      doc.autoTable({
        startY: yPosition,
        head: [["Campo", "Valor"]],
        body: [
          ["Número de Póliza", poliza.numero_poliza],
          ["Nombre Cliente", poliza.nombre_cliente],
          ["Nombre Tipo Seguro", poliza.nombre_tipo_seguro],
          ["Fecha Inicio", poliza.fecha_inicio],
          ["Fecha Fin", poliza.fecha_fin],
          ["Prima Mensual", poliza.prima_mensual],
          ["Nombre Estado Póliza", poliza.nombre_estado_poliza],
        ],
      });

      yPosition = doc.lastAutoTable.finalY + 10;
    });

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `reporte_polizas_${fechaInicio}_a_${fechaFin}.pdf`
    );

    // Ensure the directory exists
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    res.status(500).send("Error al generar el PDF");
  }
};

export const pdf_report5 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM reporte_estado_reclamaciones"
    );

    const doc = new jsPDF();

    // Add a title to the PDF
    doc.setFontSize(18);
    doc.text("Reporte de Estado de Reclamaciones", 14, 10);

    let yPosition = 20;

    result.rows.forEach((row, index) => {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 20; // Reiniciar la posición Y para la nueva página
      }

      doc.autoTable({
        startY: yPosition,
        head: [["Campo", "Valor"]],
        body: [
          ["Numero Reclamacion", row.numero_reclamacion],
          ["Nombre Cliente", row.nombre_cliente],
          ["Numero Poliza", row.numero_poliza],
          ["Tipo Seguro", row.nombre_tipo_seguro],
          ["Tipo Siniestro", row.nombre_siniestro],
          ["Estado Reclamación", row.nombre_estado_reclamacion],
          ["Fecha Siniestro", row.fecha_siniestro],
          ["Monto Reclamado", row.monto_reclamado],
          ["Monto Indemnizado", row.monto_indemnizado],
        ],
      });

      yPosition = doc.lastAutoTable.finalY + 10;
    });

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      "reporte_estado_reclamaciones.pdf"
    );

    // Ensure the directory exists
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    res.status(500).send("Error al generar el PDF");
  }
};

export const pdf_report6 = async (req, res) => {
  const { anno } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM obtener_ingresos_mensuales_por_concepto_primas_dado_anno($1)",
      [anno]
    );

    const doc = new jsPDF();

    // Add a title to the PDF
    doc.setFontSize(18);
    doc.text("Reporte de Ingresos Mensuales por Concepto de Primas", 14, 10);

    let yPosition = 20;

    result.rows.forEach((row, index) => {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 20; // Reiniciar la posición Y para la nueva página
      }

      doc.autoTable({
        startY: yPosition,
        head: [["Campo", "Valor"]],
        body: [
          ["Año", row.anno],
          ["Mes", row.mes],
          ["Monto Pagado", row.monto_pagado],
        ],
      });

      yPosition = doc.lastAutoTable.finalY + 10;
    });

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `Primas_mensuales_dado_anno_${anno}.pdf`
    );

    // Ensure the directory exists
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error("Error al generar el PDF:", error);
    res.status(500).send("Error al generar el PDF");
  }
};


export const pdf_salida1 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM salida_cliente_con_cantidad_reclamacion_rechazada"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Clientes con Reclamaciones Rechazadas", 14, 22);

    // Agregar datos en formato de tabla
    doc.autoTable({
      startY: 30,
      head: [["Campo", "Valor"]],
      body: result.rows.map((row, index) => [
        [`Cliente ${index + 1}`, ""],
        ["Nombre Cliente", row.nombre_cliente],
        ["Numero Identidad Cliente", row.numero_identidad_cliente],
        ["Cantidad Reclamaciones Rechazadas", row.count],
      ]),
    });

    // Guardar el PDF
    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      "reporte_reclamaciones_rechazadas.pdf"
    );

    // Asegúrate de que el directorio exista
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");
    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error generando el reporte");
  }
};

export const pdf_salida2 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM salida_cliente_con_cantidad_reclamacion_aprobada"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Clientes con Reclamaciones Aprobadas", 14, 22);

    // Agregar datos en formato de tabla
    doc.autoTable({
      startY: 30,
      head: [["Campo", "Valor"]],
      body: result.rows.map((row, index) => [
        [`Cliente ${index + 1}`, ""],
        ["Nombre Cliente", row.nombre_cliente],
        ["Numero Identidad Cliente", row.numero_identidad_cliente],
        ["Cantidad Reclamaciones Aprobadas", row.count],
        ["Suma Total Aprobada", row.sum],
      ]),
    });

    // Guardar el PDF
    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      "reporte_reclamaciones_aprobadas.pdf"
    );

    // Asegúrate de que el directorio exista
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");
    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error generando el reporte");
  }
};


export const pdf_salida3 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM salida_listado_polizas_vencidas"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Pólizas Vencidas", 14, 22);

    // Agregar datos en formato de tabla
    doc.autoTable({
      startY: 30,
      head: [["Campo", "Valor"]],
      body: result.rows.map((row, index) => [
        [`Poliza ${index + 1}`, ""],
        ["Numero Poliza", row.numero_poliza],
        ["Nombre Cliente", row.nombre_cliente],
        ["Tipo de Seguro", row.nombre_tipo_seguro],
        ["Fecha Inicio", row.fecha_inicio],
        ["Fecha Fin", row.fecha_fin],
        ["Monto Total Asegurado", row.monto_total_asegurado],
      ]),
    });

    // Guardar el PDF
    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      "reporte_polizas_vencidas.pdf"
    );

    // Asegúrate de que el directorio exista
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");
    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error generando el reporte");
  }
};

export const pdf_salida4 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM salida_listado_reaseguradoras"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Reaseguradoras", 14, 22);

    // Agregar datos en formato de tabla
    doc.autoTable({
      startY: 30,
      head: [["Campo", "Valor"]],
      body: result.rows.map((row, index) => [
        [`Reaseguradora ${index + 1}`, ""],
        ["Nombre Compañía Reaseguradora", row.nombre_compannia_reaseguradora],
        ["Nombre Pais", row.nombre_pais],
        ["Nombre Tipo Reaseguro", row.nombre_tipo_reaseguro],
      ]),
    });

    // Guardar el PDF
    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      "reporte_reaseguradoras.pdf"
    );

    // Asegúrate de que el directorio exista
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error generando el reporte");
  }
};

export const pdf_salida5 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM salida_listado_reclamaciones"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Listado de Reclamaciones", 14, 22);

    // Agregar datos en formato de tabla
    doc.autoTable({
      startY: 30,
      head: [["Campo", "Valor"]],
      body: result.rows.map((row, index) => [
        [`Reclamacion ${index + 1}`, ""],
        ["Nombre Cliente", row.nombre_cliente],
        ["Numero Poliza", row.numero_poliza],
        ["Tipo de Seguro", row.nombre_tipo_seguro],
        ["Numero Reclamacion", row.numero_reclamacion],
        ["Nombre Siniestro", row.nombre_siniestro],
        ["Fecha Siniestro", row.fecha_siniestro],
        ["Monto Reclamado", row.monto_reclamado],
        ["Estado Reclamación", row.nombre_estado_reclamacion],
        ["Monto Indemnizado", row.monto_indemnizado],
      ]),
    });

    // Guardar el PDF
    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      "reporte_listado_reclamaciones.pdf"
    );

    // Asegúrate de que el directorio exista
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error generando el reporte");
  }
};

export const pdf_salida6 = async (req, res) => {
  try {
    const resultClientes = await pool.query(
      "SELECT * FROM reporte_roger_clientes"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Clientes y sus Pólizas", 14, 22);

    // Agregar datos de clientes en formato de tabla
    for (const row of resultClientes.rows) {
      if (resultClientes.rows.indexOf(row) > 0) {
        doc.addPage();
      }

      doc.autoTable({
        startY: 30,
        head: [["Campo", "Valor"]],
        body: [
          ["Número Identidad Cliente", row.numero_identidad_cliente],
          ["Nombre Pais", row.nombre_pais],
          ["Sexo", row.nombre_sexo],
          ["Nombre Cliente", row.nombre_cliente],
          ["Apellido Cliente", row.apellido_cliente],
          ["Telefono", row.telefono],
          ["Correo Electronico", row.correo_electronico],
          ["Carnet Identidad", row.carnet_identidad],
        ],
      });

      // Obtener pólizas del cliente
      const resultPolizas = await pool.query(
        "SELECT * FROM roger_obtener_poliza_dado_cliente($1)",
        [row.numero_identidad_cliente]
      );

      doc.autoTable({
        startY: doc.lastAutoTable.finalY + 10,
        head: [["Campo", "Valor"]],
        body: resultPolizas.rows.map((poliza, index) => [
          [`Poliza ${index + 1}`, ""],
          ["Numero Poliza", poliza.numero_poliza],
          ["Agencia Seguro", poliza.nombre_agencia_seguro],
          ["Estado Poliza", poliza.nombre_estado_poliza],
          ["Tipo Seguro", poliza.nombre_tipo_seguro],
          ["Fecha Inicio", poliza.fecha_inicio],
          ["Fecha Fin", poliza.fecha_fin],
          ["Prima Mensual", poliza.prima_mensual],
          ["Monto Total Asegurado", poliza.monto_total_asegurado],
          ["Tipo Cobertura", poliza.nombre_tipo_cobertura],
        ]),
      });
    }

    // Guardar el PDF
    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      "reporte_clientes_polizas.pdf"
    );

    // Asegúrate de que el directorio exista
    fs.mkdirSync(path.dirname(savePath), { recursive: true });

    fs.writeFileSync(savePath, pdf, "binary");

    res.contentType("application/pdf");
    res.send(pdf);
  } catch (error) {
    console.error(error);
    res.status(500).send("Error generando el reporte");
  }
};
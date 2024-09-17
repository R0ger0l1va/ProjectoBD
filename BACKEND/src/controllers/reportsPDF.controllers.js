import { pool } from "../../database/db.js";
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
    console.log("Resultado de la consulta:", result.rows); // Imprimir los resultados de la consulta

    const data = result.rows[0];

    const doc = new jsPDF();
    let yPosition = 10;

    const addText = (text) => {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 10; // Reiniciar la posición Y para la nueva página
      }
      doc.text(text, 10, yPosition);
      yPosition += 10;
    };

    addText(`ID Agencia Seguro: ${data.id_agencia_seguro}`);
    addText(`Nombre Agencia Seguro: ${data.nombre_agencia_seguro}`);
    addText(`Direccion Postal: ${data.direccion_postal}`);
    addText(`Telefono: ${data.telefono}`);
    addText(`Correo Electronico: ${data.correo_electronico}`);
    addText(`Nombre Director General: ${data.nombre_director_general}`);
    addText(
      `Nombre Jefe Departamento Seguros: ${data.nombre_jefe_departamento_seguros}`
    );
    addText(
      `Nombre Jefe Departamento Reclamaciones: ${data.nombre_jefe_departamento_reclamaciones}`
    );

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
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

export const pdf_Report2 = async (req, res) => {
  const id_cliente = req.params.id;

  try {
    // Ejecutar la función obtener_cliente_dadoid
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

    // Ejecutar la función obtener_polizas_activas_cantidad_dadoCliente
    const polizasResult = await pool.query(
      "SELECT * FROM obtener_polizas_activas_cantidad_dadoCliente($1)",
      [id_cliente]
    );
    const polizasData = polizasResult.rows;

    // Crear el PDF
    const doc = new jsPDF();
    doc.text(`Nombre Cliente: ${clienteData.nombre_cliente}`, 10, 10);
    doc.text(
      `Numero Identidad Cliente: ${clienteData.numero_identidad_cliente}`,
      10,
      20
    );
    doc.text(`Telefono: ${clienteData.telefono}`, 10, 30);
    doc.text(`Direccion Postal: ${clienteData.direccion_postal}`, 10, 40);
    doc.text(`Correo Electronico: ${clienteData.correo_electronico}`, 10, 50);

    let yPosition = 60;
    for (const poliza of polizasData) {
      doc.text(`Numero de Poliza: ${poliza.numero_poliza}`, 10, yPosition);
      yPosition += 10;

      // Ejecutar la función obtener_valor_total_primas_dado_poliza
      const primasResult = await pool.query(
        "SELECT obtener_valor_total_primas_dado_poliza($1) AS valor_total_primas",
        [poliza.numero_poliza]
      );
      const valorTotalPrimas = primasResult.rows[0].valor_total_primas;
      doc.text(`Valor Total de Primas: ${valorTotalPrimas}`, 10, yPosition);
      yPosition += 10;

      // Ejecutar la función obtener_reclamaciones_dado_polizaid
      const reclamacionesResult = await pool.query(
        "SELECT * FROM obtener_reclamaciones_dado_polizaid($1)",
        [poliza.numero_poliza]
      );
      const reclamacionesData = reclamacionesResult.rows;

      for (const reclamacion of reclamacionesData) {
        doc.text(
          `Numero de Reclamacion: ${reclamacion.numero_reclamacion}`,
          10,
          yPosition
        );
        yPosition += 10;
        doc.text(
          `Fecha de Siniestro: ${reclamacion.fecha_siniestro}`,
          10,
          yPosition
        );
        yPosition += 10;
        doc.text(
          `Monto Reclamado: ${reclamacion.monto_reclamado}`,
          10,
          yPosition
        );
        yPosition += 10;
        doc.text(
          `Monto Indemnizado: ${reclamacion.monto_indemnizado}`,
          10,
          yPosition
        );
        yPosition += 10;
      }
    }

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `reporte_cliente_${id_cliente}.pdf`
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

export const pdf_report3 = async (req, res) => {
  const idCompRe = req.params.idCompRe;
  const idAgencia = req.params.idAgencia;

  try {
    // Ejecutar la función obtener_CompRe_dadoID
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

    // Ejecutar la función obtener_pParticipacion_dado_idAgen_idCompRe
    const participacionResult = await pool.query(
      "SELECT * FROM obtener_pParticipacion_dado_idAgen_idCompRe($1, $2)",
      [idCompRe, idAgencia]
    );
    const participacionData = participacionResult.rows;

    // Crear el PDF
    const doc = new jsPDF();
    doc.text(
      `Nombre Compañia Reaseguradora: ${compReData.nombre_compannia_reaseguradora}`,
      10,
      10
    );
    doc.text(`Nombre Pais: ${compReData.nombre_pais}`, 10, 20);
    doc.text(
      `Nombre Tipo Reaseguro: ${compReData.nombre_tipo_reaseguro}`,
      10,
      30
    );

    let yPosition = 40;
    for (const participacion of participacionData) {
      doc.text(
        `Nombre Tipo Seguro: ${participacion.nombre_tipo_seguro}`,
        10,
        yPosition
      );
      yPosition += 10;
      doc.text(
        `Porciento Participacion: ${participacion.porciento_participacion}`,
        10,
        yPosition
      );
      yPosition += 10;
    }

    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `reporte_comp_reaseguradora_${idCompRe}_agencia_${idAgencia}.pdf`
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

export const pdf_report4 = async (req, res) => {
    const fechaInicio = req.params.fechaInicio;
    const fechaFin = req.params.fechaFin;

    try {
        // Ejecutar la función obtener_polizas_emitidas_dado_periodo_tiempo
        const polizasResult = await pool.query('SELECT * FROM obtener_polizas_emitidas_dado_periodo_tiempo($1, $2)', [fechaInicio, fechaFin]);
        const polizasData = polizasResult.rows;

        if (polizasData.length === 0) {
            return res.status(404).send('No se encontraron pólizas emitidas en el periodo de tiempo proporcionado.');
        }

        // Crear el PDF
        const doc = new jsPDF();
        let yPosition = 10;

        polizasData.forEach((poliza, index) => {
             if (yPosition > 280) {
               doc.addPage();
               yPosition = 20; // Reiniciar la posición Y para la nueva página
             }
            doc.text(`Póliza ${index + 1}`, 10, yPosition);
            yPosition += 10;
            doc.text(`Número de Póliza: ${poliza.numero_poliza}`, 10, yPosition);
            yPosition += 10;
            doc.text(`Nombre Cliente: ${poliza.nombre_cliente}`, 10, yPosition);
            yPosition += 10;
            doc.text(`Nombre Tipo Seguro: ${poliza.nombre_tipo_seguro}`, 10, yPosition);
            yPosition += 10;
            doc.text(`Fecha Inicio: ${poliza.fecha_inicio}`, 10, yPosition);
            yPosition += 10;
            doc.text(`Fecha Fin: ${poliza.fecha_fin}`, 10, yPosition);
            yPosition += 10;
            doc.text(`Prima Mensual: ${poliza.prima_mensual}`, 10, yPosition);
            yPosition += 10;
            doc.text(`Nombre Estado Póliza: ${poliza.nombre_estado_poliza}`, 10, yPosition);
            yPosition += 20; // Añadir espacio entre pólizas
        });

        const pdf = doc.output();
        const savePath = path.join(
          __dirname,
          '../../out',
          `reporte_polizas_${fechaInicio}_a_${fechaFin}.pdf`
        );

        // Asegúrate de que el directorio exista
        fs.mkdirSync(path.dirname(savePath), { recursive: true });

        fs.writeFileSync(savePath, pdf, 'binary');

        res.contentType("application/pdf");
        res.send(pdf);
    } catch (error) {
        console.error('Error al generar el PDF:', error);
        res.status(500).send('Error al generar el PDF');
    }
}

export const pdf_report5 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM reporte_estado_reclamaciones"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Estado de Reclamaciones", 14, 22);

    // Agregar datos sin formato de tabla
    let yPosition = 30;
      result.rows.forEach((row, index) => {
         if (yPosition > 280) {
           doc.addPage();
           yPosition = 20; // Reiniciar la posición Y para la nueva página
         }
      doc.setFontSize(12);
      doc.text(`Reclamacion ${index + 1}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Numero Reclamacion: ${row.numero_reclamacion}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Nombre Cliente: ${row.nombre_cliente}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Numero Poliza: ${row.numero_poliza}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Tipo Seguro: ${row.nombre_tipo_seguro}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Tipo Siniestro: ${row.nombre_siniestro}`, 14, yPosition);
      yPosition += 10;
      doc.text(
        `Estado Reclamación: ${row.nombre_estado_reclamacion}`,
        14,
        yPosition
      );
      yPosition += 10;
      doc.text(`Fecha Siniestro: ${row.fecha_siniestro}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Monto Reclamado: ${row.monto_reclamado}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Monto Indemnizado: ${row.monto_indemnizado}`, 14, yPosition);
      yPosition += 20; // Espacio adicional entre reclamaciones
    });

    // Guardar el PDF
   const pdf = doc.output();
   const savePath = path.join(
     __dirname,
     "../../out",
     'reporte_estado_reclamaciones.pdf'
   );

   // Asegúrate de que el directorio exista
   fs.mkdirSync(path.dirname(savePath), { recursive: true });

   fs.writeFileSync(savePath, pdf, "binary");

  } catch (error) {
    console.error(error);
    res.status(500).send("Error generando el reporte");
  }
}

export const pdf_report6 = async (req, res) => {
  const { anno } = req.params;

  try {
    const result = await pool.query(
      "SELECT * FROM obtener_ingresos_mensuales_por_concepto_primas_dado_anno($1)",
      [anno]
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Ingresos Mensuales por Concepto de Primas", 14, 22);

    // Agregar datos sin formato de tabla
    let yPosition = 30;
    result.rows.forEach((row, index) => {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 20; // Reiniciar la posición Y para la nueva página
      }
      doc.setFontSize(12);
      doc.text(`Ingreso ${index + 1}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Año: ${row.anno}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Mes: ${row.mes}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Monto Pagado: ${row.monto_pagado}`, 14, yPosition);
      yPosition += 20; // Espacio adicional entre ingresos
    });

    // Guardar el PDF
     const pdf = doc.output();
     const savePath = path.join(
       __dirname,
       "../../out",
       `Primas_mensuales_dado_anno.pdf`
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


export const pdf_salida1 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM salida_cliente_con_cantidad_reclamacion_rechazada"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Clientes con Reclamaciones Rechazadas", 14, 22);

    // Agregar datos sin formato de tabla
    let yPosition = 30;
      result.rows.forEach((row, index) => {
         if (yPosition > 280) {
           doc.addPage();
           yPosition = 20; // Reiniciar la posición Y para la nueva página
         }
      doc.setFontSize(12);
      doc.text(`Cliente ${index + 1}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Nombre Cliente: ${row.nombre_cliente}`, 14, yPosition);
      yPosition += 10;
      doc.text(
        `Numero Identidad Cliente: ${row.numero_identidad_cliente}`,
        14,
        yPosition
      );
      yPosition += 10;
      doc.text(
        `Cantidad Reclamaciones Rechazadas: ${row.count}`,
        14,
        yPosition
      );
      yPosition += 20; // Espacio adicional entre clientes
    });

    // Guardar el PDF
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
        const result = await pool.query("SELECT * FROM salida_cliente_con_cantidad_reclamacion_aprobada");

        const doc = new jsPDF();

        // Título del reporte
        doc.setFontSize(18);
        doc.text("Reporte de Clientes con Reclamaciones Aprobadas", 14, 22);

        // Agregar datos sin formato de tabla
        let yPosition = 30;
        result.rows.forEach((row, index) => {
             if (yPosition > 280) {
               doc.addPage();
               yPosition = 20; // Reiniciar la posición Y para la nueva página
             }
            doc.setFontSize(12);
            doc.text(`Cliente ${index + 1}`, 14, yPosition);
            yPosition += 10;
            doc.text(`Nombre Cliente: ${row.nombre_cliente}`, 14, yPosition);
            yPosition += 10;
            doc.text(`Numero Identidad Cliente: ${row.numero_identidad_cliente}`, 14, yPosition);
            yPosition += 10;
            doc.text(`Cantidad Reclamaciones Aprobadas: ${row.count}`, 14, yPosition);
            yPosition += 10;
            doc.text(`Suma Total Aprobada: ${row.sum}`, 14, yPosition);
            yPosition += 20; // Espacio adicional entre clientes
        });

        // Guardar el PDF
         const pdf = doc.output();
         const savePath = path.join(
           __dirname,
           "../../out",
           `reporte_reclamaciones_aprobadas.pdf`
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
}


export const pdf_salida3 = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM salida_listado_polizas_vencidas"
    );

    const doc = new jsPDF();

    // Título del reporte
    doc.setFontSize(18);
    doc.text("Reporte de Pólizas Vencidas", 14, 22);

    // Agregar datos sin formato de tabla
    let yPosition = 30;
      result.rows.forEach((row, index) => {
         if (yPosition > 280) {
           doc.addPage();
           yPosition = 20; // Reiniciar la posición Y para la nueva página
         }
      doc.setFontSize(12);
      doc.text(`Poliza ${index + 1}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Numero Poliza: ${row.numero_poliza}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Nombre Cliente: ${row.nombre_cliente}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Tipo de Seguro: ${row.nombre_tipo_seguro}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Fecha Inicio: ${row.fecha_inicio}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Fecha Fin: ${row.fecha_fin}`, 14, yPosition);
      yPosition += 10;
      doc.text(
        `Monto Total Asegurado: ${row.monto_total_asegurado}`,
        14,
        yPosition
      );
      yPosition += 20; // Espacio adicional entre pólizas
    });

    // Guardar el PDF
     const pdf = doc.output();
     const savePath = path.join(
       __dirname,
       "../../out",
       `reporte_polizas_vencidas.pdf`
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

    // Agregar datos sin formato de tabla
    let yPosition = 30;
    result.rows.forEach((row, index) => {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 20; // Reiniciar la posición Y para la nueva página
      }
      doc.setFontSize(12);
      doc.text(`Reaseguradora ${index + 1}`, 14, yPosition);
      yPosition += 10;
      doc.text(
        `Nombre Compañía Reaseguradora: ${row.nombre_compannia_reaseguradora}`,
        14,
        yPosition
      );
      yPosition += 10;
      doc.text(`Nombre Pais: ${row.nombre_pais}`, 14, yPosition);
      yPosition += 10;
      doc.text(
        `Nombre Tipo Reaseguro: ${row.nombre_tipo_reaseguro}`,
        14,
        yPosition
      );
      yPosition += 20; // Espacio adicional entre reaseguradoras
    });

    // Guardar el PDF
    const pdf = doc.output();
    const savePath = path.join(
      __dirname,
      "../../out",
      `reporte_reaseguradoras.pdf`
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

    // Agregar datos sin formato de tabla
    let yPosition = 30;
    result.rows.forEach((row, index) => {
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 20; // Reiniciar la posición Y para la nueva página
      }
      doc.setFontSize(12);
      doc.text(`Reclamacion ${index + 1}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Nombre Cliente: ${row.nombre_cliente}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Numero Poliza: ${row.numero_poliza}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Tipo de Seguro: ${row.nombre_tipo_seguro}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Numero Reclamacion: ${row.numero_reclamacion}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Nombre Siniestro: ${row.nombre_siniestro}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Fecha Siniestro: ${row.fecha_siniestro}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Monto Reclamado: ${row.monto_reclamado}`, 14, yPosition);
      yPosition += 10;
      doc.text(
        `Estado Reclamación: ${row.nombre_estado_reclamacion}`,
        14,
        yPosition
      );
      yPosition += 10;
      doc.text(`Monto Indemnizado: ${row.monto_indemnizado}`, 14, yPosition);
      yPosition += 20; // Espacio adicional entre reclamaciones
    });

    // Guardar el PDF
     const pdf = doc.output();
     const savePath = path.join(
       __dirname,
       "../../out",
       `reporte_listado_reclamaciones.pdf`
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

    // Agregar datos de clientes sin formato de tabla
    for (const row of resultClientes.rows) {
      if (resultClientes.rows.indexOf(row) > 0) {
        doc.addPage();
      }
      let yPosition = 30;
      doc.setFontSize(12);
      doc.text(`Cliente`, 14, yPosition);
      yPosition += 10;
      doc.text(
        `Número Identidad Cliente: ${row.numero_identidad_cliente}`,
        14,
        yPosition
      );
      yPosition += 10;
      doc.text(`Nombre Pais: ${row.nombre_pais}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Sexo: ${row.nombre_sexo}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Nombre Cliente: ${row.nombre_cliente}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Apellido Cliente: ${row.apellido_cliente}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Telefono: ${row.telefono}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Correo Electronico: ${row.correo_electronico}`, 14, yPosition);
      yPosition += 10;
      doc.text(`Carnet Identidad: ${row.carnet_identidad}`, 14, yPosition);
      yPosition += 10;

      // Obtener pólizas del cliente
      const resultPolizas = await pool.query(
        "SELECT * FROM roger_obtener_poliza_dado_cliente($1)",
        [row.numero_identidad_cliente]
      );
      doc.text(`Polizas:`, 14, yPosition);
      yPosition += 10;
      resultPolizas.rows.forEach((poliza, index) => {
        if (yPosition > 220) {
          doc.addPage();
          yPosition = 20; // Reiniciar la posición Y para la nueva página
        }
        doc.text(`Poliza ${index + 1}`, 14, yPosition);
        yPosition += 10;
        doc.text(`Numero Poliza: ${poliza.numero_poliza}`, 14, yPosition);
        yPosition += 10;
        doc.text(
          `Agencia Seguro: ${poliza.nombre_agencia_seguro}`,
          14,
          yPosition
        );
        yPosition += 10;
        doc.text(
          `Estado Poliza: ${poliza.nombre_estado_poliza}`,
          14,
          yPosition
        );
        yPosition += 10;
        doc.text(`Tipo Seguro: ${poliza.nombre_tipo_seguro}`, 14, yPosition);
        yPosition += 10;
        doc.text(`Fecha Inicio: ${poliza.fecha_inicio}`, 14, yPosition);
        yPosition += 10;
        doc.text(`Fecha Fin: ${poliza.fecha_fin}`, 14, yPosition);
        yPosition += 10;
        doc.text(`Prima Mensual: ${poliza.prima_mensual}`, 14, yPosition);
        yPosition += 10;
        doc.text(
          `Monto Total Asegurado: ${poliza.monto_total_asegurado}`,
          14,
          yPosition
        );
        yPosition += 10;
        doc.text(
          `Tipo Cobertura: ${poliza.nombre_tipo_cobertura}`,
          14,
          yPosition
        );
        yPosition += 20; // Espacio adicional entre pólizas
      });

      yPosition += 20; // Espacio adicional entre clientes

      // Verificar si se necesita una nueva página
      if (yPosition > 280) {
        doc.addPage();
        yPosition = 20; // Reiniciar la posición Y para la nueva página
      }
    }

    // Guardar el PDF
     const pdf = doc.output();
     const savePath = path.join(
       __dirname,
       "../../out",
       `reporte_clientes_polizas.pdf`
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
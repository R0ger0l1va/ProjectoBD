<template>
  <v-container class="report-generator">
    <h2 class="text-center">Generador de Reportes</h2>

    <v-card class="report-section">
      <v-card-title>
        <h3>Reportes sin Parámetros</h3>
      </v-card-title>
      <v-card-text>
        <v-row>
          <v-col cols="12"
                 md="4">
            <v-btn @click="generateReport('ReporteDeEstadoReclamacion')"
                   color="light-blue"
                   class="w-100">Estado Reclamación
            </v-btn>
          </v-col>
          <v-col cols="12"
                 md="4">
            <v-btn @click="generateReport('ReporteListadoReclamaciones')"
                   color="light-blue"
                   class="w-100">Listado Reclamaciones
            </v-btn>
          </v-col>
          <v-col cols="12"
                 md="4">
            <v-btn @click="generateReport('ReporteClientesYPolizas')"
                   color="light-blue"
                   class="w-100">Clientes y Pólizas
            </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Vista previa del PDF -->
    <div v-if="pdfUrl"
         class='pdf-viewer'>
      <h3>Vista previa del PDF</h3>
      <iframe :src='pdfUrl'
              width='100%'
              height='500px'></iframe>
      <a :href='pdfUrl'
         download
         class='download-button'>Descargar PDF</a>
    </div>

  </v-container>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ReportGenerator',
  data() {
    return {
      pdfUrl: null,
    }
  },
  methods: {
    async generateReport(reportType) {
      try {
        let response;
        switch (reportType) {
          case 'ReporteDeEstadoReclamacion':
            response = await axios.get('/gen-pdf_report5', {responseType: 'blob'});
            break;
          case 'ReporteListadoReclamaciones':
            response = await axios.get('/gen-pdf_salida5', {responseType: 'blob'});
            break;
          case 'ReporteClientesYPolizas':
            response = await axios.get('/gen-pdf_salida6', {responseType: 'blob'}); // Cambia la URL según tu API
            break;
        }

        this.displayPdf(response.data);
      } catch (error) {
        console.error('Error generating report:', error);
        alert('Error al generar el reporte. Por favor, intente de nuevo.');
      }
    },

    displayPdf(pdfBlob) {
      const pdfUrl = URL.createObjectURL(pdfBlob);
      this.pdfUrl = pdfUrl;
    }
  }
}
</script>

<style scoped>
.report-generator {
  max-width: 800px;
  margin: 0 auto;
}

.pdf-viewer {
  margin-top: 30px;
}

.download-button {
  display: inline-block;
  margin-top: 10px;
}
</style>


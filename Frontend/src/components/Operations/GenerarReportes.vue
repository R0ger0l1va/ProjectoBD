<template>
  <div class="report-generator">
    <h2>Generador de Reportes</h2>

    <div class="report-section">
      <h3>Reportes con Parámetros</h3>
      <div class="report-options">
        <div class="report-option">
          <label for="agenciaId">Reporte de Agencia:</label>
          <input v-model="agenciaId" type="text" id="agenciaId" placeholder="ID de Agencia" />
          <button @click="generateReport('getAgencia')">Generar</button>
        </div>

        <div class="report-option">
          <label for="report2Id">Cliente Determinado:</label>
          <input v-model="report2Id" type="text" id="report2Id" placeholder="ID para Reporte 2" />
          <button @click="generateReport('FichaDeClienteDeterminado')">Generar</button>
        </div>

        <div class="report-option">
          <label for="idCompRe">Reaseguradora Asociada Agencia:</label>
          <input v-model="idCompRe" type="text" id="idCompRe" placeholder="ID CompRe" />
          <input v-model="idAgencia" type="text" placeholder="ID Agencia" />
          <button @click="generateReport('FichaDeReaseguradoAsociadaAgencia')">Generar</button>
        </div>

        <div class="report-option">
          <label for="fechaInicio">Polizas Emitidas en Periodo de Tiempo:</label>
          <input v-model="fechaInicio" type="date" id="fechaInicio" />
          <input v-model="fechaFin" type="date" placeholder="Fecha Fin" />
          <button @click="generateReport('ReporteDePolizasEmitidasEnPeriodoDeTiempo')">
            Generar
          </button>
        </div>

        <div class="report-option">
          <label for="anno">Ingresos Mensuales Concepto de Prima:</label>
          <input v-model="anno" type="number" id="anno" placeholder="Año" />
          <button @click="generateReport('ReporteIngresosMensualesConceptoPrima')">Generar</button>
        </div>
      </div>
    </div>

    <div class="report-section">
      <h3>Reportes sin Parámetros</h3>
      <div class="report-options">
        <div class="report-option">
          <button @click="generateReport('ReporteDeEstadoReclamacion')">Estado Reclamacion</button>
        </div>
        <div class="report-option">
          <button @click="generateReport('ReporteClientesReclamacionesRechazadas')">
            Clientes Reclamaciones Rechazadas
          </button>
        </div>
        <div class="report-option">
          <button @click="generateReport('ReporteClientesReclamacionesAprobadas')">
            Clientes Reclamaciones Aprobadas
          </button>
        </div>
        <div class="report-option">
          <button @click="generateReport('ReportePolizasVencidas')">Polizas Vencidas</button>
        </div>
        <div class="report-option">
          <button @click="generateReport('ReporteReaseguradoras')">Reaseguradoras</button>
        </div>
        <div class="report-option">
          <button @click="generateReport('ReporteListadoReclamaciones')">
            Listado Reclamaciones
          </button>
        </div>
        <div class="report-option">
          <button @click="generateReport('ReporteClientesYPolizas')">Clientes y Polizas</button>
        </div>
      </div>
    </div>

    <div v-if="pdfUrl" class="pdf-viewer">
      <h3>Vista previa del PDF</h3>
      <iframe :src="pdfUrl" width="100%" height="500px"></iframe>
      <a :href="pdfUrl" download class="download-button">Descargar PDF</a>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ReportGenerator',
  data() {
    return {
      agenciaId: '',
      report2Id: '',
      idCompRe: '',
      idAgencia: '',
      fechaInicio: '',
      fechaFin: '',
      anno: new Date().getFullYear(),
      pdfUrl: null
    }
  },
  methods: {
    async generateReport(reportType) {
      try {
        let response
        switch (reportType) {
          case 'getAgencia':
            response = await axios.get(`/gen-pdf_getAgencia/${this.agenciaId}`, {
              responseType: 'blob'
            })
            break
          case 'FichaDeClienteDeterminado':
            response = await axios.get(`/gen-pdf_report2/${this.report2Id}`, {
              responseType: 'blob'
            })
            break
          case 'FichaDeReaseguradoAsociadaAgencia':
            response = await axios.get(`/gen-pdf_report3/${this.idCompRe}/${this.idAgencia}`, {
              responseType: 'blob'
            })
            break
          case 'ReporteDePolizasEmitidasEnPeriodoDeTiempo':
            response = await axios.get(`/gen-pdf_report4/${this.fechaInicio}/${this.fechaFin}`, {
              responseType: 'blob'
            })
            break
          case 'ReporteDeEstadoReclamacion':
            response = await axios.get('/gen-pdf_report5', { responseType: 'blob' })
            break
          case 'ReporteIngresosMensualesConceptoPrima':
            response = await axios.get(`/gen-pdf_report6/${this.anno}`, { responseType: 'blob' })
            break
          case 'ReporteClientesReclamacionesRechazadas':
            response = await axios.get('/gen-pdf_salida1', { responseType: 'blob' })

            break
          case 'ReporteClientesReclamacionesAprobadas':
                        response = await axios.get('/gen-pdf_salida2', { responseType: 'blob' })

            break
          case 'ReportePolizasVencidas':
                        response = await axios.get('/gen-pdf_salida3', { responseType: 'blob' })

            break
          case 'ReporteReaseguradoras':
                        response = await axios.get('/gen-pdf_salida4', { responseType: 'blob' })

            break
          case 'ReporteListadoReclamaciones':
                        response = await axios.get('/gen-pdf_salida5', { responseType: 'blob' })

            break
          case 'ReporteClientesYPolizas':
                        response = await axios.get('/gen-pdf_salida6', { responseType: 'blob' })

            break
        }
        this.displayPdf(response.data)
      } catch (error) {
        console.error('Error generating report:', error)
        alert('Error al generar el reporte. Por favor, intente de nuevo.')
      }
    },
    displayPdf(pdfBlob) {
      const pdfUrl = URL.createObjectURL(pdfBlob)
      this.pdfUrl = pdfUrl
    }
  }
}
</script>

<style scoped>
.report-generator {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  font-family: Arial, sans-serif;
}

h2,
h3 {
  color: #333;
  margin-bottom: 20px;
}

.report-section {
  margin-bottom: 30px;
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
}

.report-options {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
}

.report-option {
  display: flex;
  flex-direction: column;
  gap: 5px;
  width: calc(50% - 7.5px);
}

label {
  font-weight: bold;
  margin-bottom: 5px;
}

input,
button {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

input {
  margin-bottom: 5px;
}

button {
  background-color: #4caf50;
  color: white;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #45a049;
}

.pdf-viewer {
  margin-top: 30px;
}

.download-button {
  display: inline-block;
  margin-top: 10px;
  padding: 10px 15px;
  background-color: #008cba;
  color: white;
  text-decoration: none;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.download-button:hover {
  background-color: #007b9a;
}
</style>

<template>
  <div class="report-generator">
    <h2>Generador de Reportes y Salidas</h2>
    
    <div class="report-section">
      <h3>Reportes</h3>
      <div class="report-options">
        <div class="report-option">
          <label for="agenciaId">Reporte de Agencia:</label>
          <input v-model="agenciaId" type="text" id="agenciaId" placeholder="ID de Agencia">
          <button @click="generateReport('getAgencia')">Generar</button>
        </div>
        
        <div class="report-option">
          <label for="report2Id">Reporte 2:</label>
          <input v-model="report2Id" type="text" id="report2Id" placeholder="ID para Reporte 2">
          <button @click="generateReport('report2')">Generar</button>
        </div>
        
        <div class="report-option">
          <label for="idCompRe">Reporte 3:</label>
          <input v-model="idCompRe" type="text" id="idCompRe" placeholder="ID CompRe">
          <input v-model="idAgencia" type="text" placeholder="ID Agencia">
          <button @click="generateReport('report3')">Generar</button>
        </div>
        
        <div class="report-option">
          <label for="fechaInicio">Reporte 4:</label>
          <input v-model="fechaInicio" type="date" id="fechaInicio">
          <input v-model="fechaFin" type="date" placeholder="Fecha Fin">
          <button @click="generateReport('report4')">Generar</button>
        </div>
        
        <div class="report-option">
            <label>Reporte 5:</label>
          <button @click="generateReport('report5')">Generar Reporte 5</button>
        </div>
        
        <div class="report-option">
          <label for="anno">Reporte 6:</label>
          <input v-model="anno" type="number" id="anno" placeholder="Año">
          <button @click="generateReport('report6')">Generar</button>
        </div>
      </div>
    </div>
    
    <div class="report-section">
      <h3>Salidas</h3>
      <div class="report-options">
        <button v-for="n in 6" :key="`salida${n}`" @click="generateSalida(n)">
          Generar Salida {{ n }}
        </button>
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
import axios from 'axios';

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
        let response;
        switch (reportType) {
          case 'getAgencia':
            response = await axios.get(`/gen-pdf_getAgencia/${this.agenciaId}`, { responseType: 'blob' });
            break;
          case 'report2':
            response = await axios.get(`/gen-pdf_report2/${this.report2Id}`, { responseType: 'blob' });
            break;
          case 'report3':
            response = await axios.get(`/gen-pdf_report3/${this.idCompRe}/${this.idAgencia}`, { responseType: 'blob' });
            break;
          case 'report4':
            response = await axios.get(`/gen-pdf_report4/${this.fechaInicio}/${this.fechaFin}`, { responseType: 'blob' });
            break;
          case 'report5':
            response = await axios.get('/gen-pdf_report5', { responseType: 'blob' });
            break;
          case 'report6':
            response = await axios.get(`/gen-pdf_report6/${this.anno}`, { responseType: 'blob' });
            break;
        }
        this.displayPdf(response.data);
      } catch (error) {
        console.error('Error generating report:', error);
        alert('Error al generar el reporte. Por favor, intente de nuevo.');
      }
    },
    async generateSalida(salidaNumber) {
      try {
        const response = await axios.get(`/gen-pdf_salida${salidaNumber}`, { responseType: 'blob' });
        this.displayPdf(response.data);
      } catch (error) {
        console.error('Error generating salida:', error);
        alert('Error al generar la salida. Por favor, intente de nuevo.');
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
  padding: 20px;
  font-family: Arial, sans-serif;
}

h2, h3 {
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
}

input, button {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

button {
  background-color: #4CAF50;
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
  background-color: #008CBA;
  color: white;
  text-decoration: none;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.download-button:hover {
  background-color: #007B9A;
}
</style>
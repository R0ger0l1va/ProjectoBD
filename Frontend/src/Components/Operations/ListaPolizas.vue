<template>
  <div class="lista-polizas">
    <h2>Lista de Pólizas</h2>
    <table>
      <thead>
        <tr>
          <th>Empresa</th>
          <th>Cliente</th>
          <th>Número de Póliza</th>
          <th>Fecha de Inicio</th>
          <th>Fecha de Fin</th>
          <th>Monto de Cobertura</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="poliza in polizas" :key="poliza.policyNumber">
          <td>{{ poliza.companyName }}</td>
          <td>{{ poliza.clientName }}</td>
          <td>{{ poliza.policyNumber }}</td>
          <td>{{ formatDate(poliza.startDate) }}</td>
          <td>{{ formatDate(poliza.endDate) }}</td>
          <td>{{ formatCurrency(poliza.coverageAmount) }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'ListaPolizas',
  data() {
    return {
      polizas: [
        {
          companyName: 'Seguros XYZ',
          clientName: 'Juan Pérez',
          policyNumber: 'POL-12345',
          startDate: '2023-01-01',
          endDate: '2023-12-31',
          coverageAmount: 100000
        },
        {
          companyName: 'Aseguradora ABC',
          clientName: 'María Gómez',
          policyNumber: 'POL-67890',
          startDate: '2023-02-15',
          endDate: '2024-02-14',
          coverageAmount: 150000
        }
        // Aquí se agregarían más pólizas
      ]
    }
  },
  methods: {
    formatDate(dateString) {
      const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
      return new Date(dateString).toLocaleDateString(undefined, options);
    },
    formatCurrency(amount) {
      return new Intl.NumberFormat('es-ES', { style: 'currency', currency: 'EUR' }).format(amount);
    }
  }
}
</script>

<style scoped>
.lista-polizas {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f0f0f0;
}

h2 {
  text-align: center;
  color: #4a5d23;
  margin-bottom: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #7d8f69;
}

th {
  background-color: #4a5d23;
  font-weight: bold;
  color: #fff;
}

tr:nth-child(even) {
  background-color: #e8e8e8;
}

tr:hover {
  background-color: #d0d8c0;
}

@media (max-width: 768px) {
  table, thead, tbody, th, td, tr {
    display: block;
  }

  thead tr {
    position: absolute;
    top: -9999px;
    left: -9999px;
  }

  tr {
    margin-bottom: 15px;
    border: 1px solid #7d8f69;
  }

  td {
    border: none;
    position: relative;
    padding-left: 50%;
  }

  td:before {
    content: attr(data-label);
    position: absolute;
    left: 6px;
    width: 45%;
    padding-right: 10px;
    white-space: nowrap;
    font-weight: bold;
    color: #4a5d23;
  }
}
</style>
<template>
  <div class="listado">
    <h2>Registro de Pólizas</h2>
    <div class="filtros">
      <div class="campo">
        <label for="filtroTipo">Filtrar por tipo:</label>
        <select id="filtroTipo" v-model="filtro.tipo">
          <option value="">Todos</option>
          <option value="creada">Creada</option>
          <option value="modificada">Modificada</option>
          <option value="eliminada">Eliminada</option>
        </select>
      </div>
      <div class="campo">
        <label for="filtroEstado">Filtrar por estado:</label>
        <select id="filtroEstado" v-model="filtro.estado">
          <option value="">Todos</option>
          <option value="activa">Activa</option>
          <option value="inactiva">Inactiva</option>
        </select>
      </div>
      <div class="campo">
        <label for="filtroMonto">Monto mínimo de cobertura:</label>
        <input id="filtroMonto" v-model.number="filtro.montoMinimo" type="number" />
      </div>
    </div>
    <table>
      <thead>
        <tr>
          <th>Número de Póliza</th>
          <th>Empresa</th>
          <th>Monto de Cobertura</th>
          <th>Tipo</th>
          <th>Estado</th>
          <th>Cliente</th>
          <th>Fecha de Inicio</th>
          <th>Fecha de Fin</th>
          <th>Prima mensual</th>
          <th>Ultimo pago</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="poliza in polizasFiltradas" :key="poliza.numeroPoliza">
          <td>{{ poliza.numeroPoliza }}</td>
          <td>{{ poliza.empresa }}</td>
          <td>{{ poliza.montoCobertura }}</td>
          <td>{{ poliza.tipo }}</td>
          <td>{{ poliza.estado }}</td>
          <td>{{ poliza.cliente }}</td>
          <td>{{ poliza.fechaInicio }}</td>
          <td>{{ poliza.fechaFin }}</td>
          <td>{{ poliza.primaMensual }}</td>
          <td>{{ poliza.ultimoPago }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'ListarPolizas',
  data() {
    return {
      polizas: [
        {
          numeroPoliza: '001',
          empresa: 'Empresa A',
          montoCobertura: 10000,
          tipo: 'creada',
          estado: 'activa',
          cliente: 'Mauro',
          fechaInicio: '2023-01-01',
          fechaFin: '2023-12-31',
          primaMensual: 10000,
          ultimoPago: 15000
        },
        {
          numeroPoliza: '002',
          empresa: 'Empresa B',
          montoCobertura: 20000,
          tipo: 'modificada',
          estado: 'activa',
          cliente: 'Ricardo',
          fechaInicio: '2022-01-01',
          fechaFin: '2023-3-31',
          primaMensual: 8000,
          ultimoPago: 8001
        },
        {
          numeroPoliza: '003',
          empresa: 'Empresa C',
          montoCobertura: 15000,
          tipo: 'eliminada',
          estado: 'inactiva',
          cliente: 'Roger',
          fechaInicio: '2023-02-08',
          fechaFin: '2023-11-31',
          primaMensual: 15000,
          ultimoPago: 14000
        }
      ],
      filtro: {
        tipo: '',
        estado: '',
        montoMinimo: 0
      }
    }
  },
  computed: {
    polizasFiltradas() {
      return this.polizas.filter(
        (poliza) =>
          (!this.filtro.tipo || poliza.tipo === this.filtro.tipo) &&
          (!this.filtro.estado || poliza.estado === this.filtro.estado) &&
          poliza.montoCobertura >= this.filtro.montoMinimo
      )
    }
  }
}
</script>

<style scoped>
.listado {
  background-color: #9E9B9B;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}

.filtros {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.campo {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input,
select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  border: 1px solid #ddd;
  
  padding: 8px;
  text-align: left;
}

th {
  background-color: #44917c;
  font-weight: bold;
}

tr {
  background-color: #f9f9f9;
}

tr:hover {
  background-color: #51FD26;
}
</style>

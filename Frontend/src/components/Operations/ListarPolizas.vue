<template>
  <div class="listado">
    <h2>Registro de Pólizas</h2>
    <div class="filtros">
      <div class="campo">
        <label for="filtroAgencia">Filtrar por Agencia:</label>
        <select id="filtroAgencia" v-model="filtro.id_agencia_seguro">
          <option value="">Todas</option>
          <option v-for="agencia in agencias" :key="agencia.id" :value="agencia.id">
            {{ agencia.nombre }}
          </option>
        </select>
      </div>
      <div class="campo">
        <label for="filtroTipoSeguro">Filtrar por Tipo de Seguro:</label>
        <select id="filtroTipoSeguro" v-model="filtro.id_tipo_seguro">
          <option value="">Todos</option>
          <option v-for="tipo in tiposSeguro" :key="tipo.id" :value="tipo.id">
            {{ tipo.nombre }}
          </option>
        </select>
      </div>
      <div class="campo">
        <label for="filtroEstado">Filtrar por Estado:</label>
        <select id="filtroEstado" v-model="filtro.id_estado_poliza">
          <option value="">Todos</option>
          <option value="1">Activa</option>
          <option value="2">Inactiva</option>
        </select>
      </div>
      <div class="campo">
        <label for="filtroPrimaMinima">Prima Mensual Mínima:</label>
        <input id="filtroPrimaMinima" v-model.number="filtro.prima_mensual_minima" type="number" min="0" step="0.01" />
      </div>
    </div>
    <table>
      <thead>
        <tr>
          <th>Número de Póliza</th>
          <th>Agencia</th>
          <th>Tipo de Seguro</th>
          <th>Cobertura</th>
          <th>Prima Mensual</th>
          <th>Estado</th>
          <th>Cliente</th>
          <th>Fecha de Inicio</th>
          <th>Fecha de Fin</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="poliza in polizasFiltradas" :key="poliza.numero_poliza">
          <td>{{ poliza.numero_poliza }}</td>
          <td>{{ getAgenciaNombre(poliza.id_agencia_seguro) }}</td>
          <td>{{ getTipoSeguroNombre(poliza.id_tipo_seguro) }}</td>
          <td>{{ getTipoCoberturaNombre(poliza.id_tipo_cobertura) }}</td>
          <td>{{ poliza.prima_mensual }}</td>
          <td>{{ getEstadoNombre(poliza.id_estado_poliza) }}</td>
          <td>{{ getClienteNombre(poliza.numero_identidad_cliente) }}</td>
          <td>{{ formatDate(poliza.fecha_inicio) }}</td>
          <td>{{ formatDate(poliza.fecha_fin) }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ListarPolizas',
  data() {
    return {
      polizas: [],
      agencias: [],
      tiposSeguro: [],
      tiposCoberturas: [],
      clientes: [],
      filtro: {
        id_agencia_seguro: '',
        id_tipo_seguro: '',
        id_estado_poliza: '',
        prima_mensual_minima: 0
      }
    }
  },
  computed: {
    polizasFiltradas() {
      return this.polizas.filter(poliza => 
        (!this.filtro.id_agencia_seguro || poliza.id_agencia_seguro === this.filtro.id_agencia_seguro) &&
        (!this.filtro.id_tipo_seguro || poliza.id_tipo_seguro === this.filtro.id_tipo_seguro) &&
        (!this.filtro.id_estado_poliza || poliza.id_estado_poliza === this.filtro.id_estado_poliza) &&
        poliza.prima_mensual >= this.filtro.prima_mensual_minima
      )
    }
  },
  methods: {
    async fetchData() {
      try {
        const [polizasRes, agenciasRes, tiposSeguroRes, tiposCoberturaRes, clientesRes] = await Promise.all([
          axios.get('/getAllPolizas'),
          axios.get('/getAllAgencias'),
          axios.get('/getAllTipoSeguros'),
          axios.get('/getAllCoberturas'),
          axios.get('/getAllClientes'),
        ])
        
        this.polizas = polizasRes.data
        this.agencias = agenciasRes.data.map(agencia => ({
          id: agencia.id_agencia_seguro,
          nombre: agencia.nombre_agencia_seguro
        }))
        this.tiposSeguro = tiposSeguroRes.data.map(tipo => ({
          id: tipo.id_tipo_seguro,
          nombre: tipo.nombre_tipo_seguro
        }))
        this.tiposCoberturas = tiposCoberturaRes.data.map(cobertura => ({
          id: cobertura.id_tipo_cobertura,
          nombre: cobertura.nombre_tipo_cobertura
        }))
        this.clientes = clientesRes.data.map(cliente => ({
          id: cliente.numero_identidad_cliente,
          nombre: cliente.nombre_cliente
        }))
      } catch (error) {
        console.error('Error fetching data:', error)
        alert('Error al cargar los datos. Por favor, intente de nuevo.')
      }
    },
    getAgenciaNombre(id) {
      const agencia = this.agencias.find(a => a.id === id)
      return agencia ? agencia.nombre : 'Desconocida'
    },
    getTipoSeguroNombre(id) {
      const tipo = this.tiposSeguro.find(t => t.id === id)
      return tipo ? tipo.nombre : 'Desconocido'
    },
    getTipoCoberturaNombre(id) {
      const cobertura = this.tiposCoberturas.find(c => c.id === id)
      return cobertura ? cobertura.nombre : 'Desconocida'
    },
    getClienteNombre(id) {
      const cliente = this.clientes.find(c => c.id === id)
      return cliente ? cliente.nombre : 'Desconocido'
    },
    getEstadoNombre(id) {
      return id === 1 ? 'Activa' : 'Inactiva'
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: '2-digit', day: '2-digit' }
      return new Date(dateString).toLocaleDateString(undefined, options)
    }
  },
  mounted() {
    this.fetchData()
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
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 20px;
}

.campo {
  flex: 1;
  min-width: 200px;
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
  margin-top: 20px;
}

th,
td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: left;
}

th {
  background-color: #44917c;
  color: white;
  font-weight: bold;
}

tr {
  background-color: #f9f9f9;
}

tr:nth-child(even) {
  background-color: #f2f2f2;
}

tr:hover {
  background-color: #e6ffe6;
}
</style>
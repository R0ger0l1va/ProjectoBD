<template>
  <div class="formulario">
    <h2>Modificar/Eliminar Póliza de Seguro</h2>
    <form @submit.prevent="buscarPoliza">
      <div class="campo">
        <label for="numeroPoliza">Número de Póliza:</label>
        <input id="numeroPoliza" v-model="numeroPoliza" required />
      </div>
      <button type="submit" class="boton-submit">Buscar Póliza</button>
    </form>

    <form v-if="polizaEncontrada" @submit.prevent="modificarPoliza">
      <div class="campo">
        <label for="agencia">Agencia:</label>
        <select id="agencia" v-model="poliza.id_agencia_seguro" required>
          <option v-for="agencia in agencias" :key="agencia.id" :value="agencia.id">
            {{ agencia.nombre }}
          </option>
        </select>
      </div>
      <div class="campo">
        <label for="tipoSeguro">Tipo de Seguro:</label>
        <select id="tipoSeguro" v-model="poliza.id_tipo_seguro" required>
          <option v-for="tipo in tiposSeguro" :key="tipo.id" :value="tipo.id">
            {{ tipo.nombre }}
          </option>
        </select>
      </div>
      <div class="campo">
        <label for="tipoCobertura">Cobertura:</label>
        <select id="tipoCobertura" v-model="poliza.id_tipo_cobertura" required>
          <option v-for="cobertura in tiposCoberturas" :key="cobertura.id" :value="cobertura.id">
            {{ cobertura.nombre }}
          </option>
        </select>
      </div>
      <div class="campo">
        <label for="primaMensual">Pago Mensual:</label>
        <input
          id="primaMensual"
          v-model.number="poliza.prima_mensual"
          type="number"
          step="0.01"
          min="0"
          required
        />
      </div>
      <div class="campo">
        <label for="fechaInicio">Fecha de Inicio:</label>
        <input id="fechaInicio" v-model="poliza.fecha_inicio" type="date" required />
      </div>
      <div class="campo">
        <label for="fechaFin">Fecha de Finalización:</label>
        <input id="fechaFin" v-model="poliza.fecha_fin" type="date" required />
      </div>
      <div class="campo">
        <label for="cliente">Cliente:</label>
        <select id="cliente" v-model="poliza.numero_identidad_cliente" required>
          <option v-for="cliente in clientes" :key="cliente.id" :value="cliente.id">
            {{ cliente.nombre }}
          </option>
        </select>
      </div>
      <div class="botones">
        <button type="submit" class="boton-submit">Modificar Póliza</button>
        <button type="button" @click="eliminarPoliza" class="boton-eliminar">
          Eliminar Póliza
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'ModificarPoliza',
  data() {
    return {
      numeroPoliza: '',
      polizaEncontrada: false,
      poliza: {
        numero_poliza: '',
        id_agencia_seguro: '',
        numero_identidad_cliente: '',
        id_estado_poliza: 3,
        id_tipo_seguro: '',
        fecha_inicio: '',
        fecha_fin: '',
        prima_mensual: '',
        monto_total_asegurado: 0.0,
        id_tipo_cobertura: ''
      },
      agencias: [],
      tiposSeguro: [],
      tiposCoberturas: [],
      clientes: []
    }
  },
  methods: {
    async buscarPoliza() {
      try {
        const response = await axios.get(`/getPoliza/${this.numeroPoliza}`)
        this.poliza = response.data
        this.polizaEncontrada = true
      } catch (error) {
        console.error('Error buscando la póliza:', error)
        alert('No se encontró la póliza o hubo un error en la búsqueda.')
        this.polizaEncontrada = false
      }
    },
    async modificarPoliza() {
      try {
        await axios.put('/actPoliza', this.poliza)
        alert('Póliza modificada con éxito')
      } catch (error) {
        console.error('Error modificando la póliza:', error)
        alert('Error al modificar la póliza')
      }
    },
    async eliminarPoliza() {
      if (confirm('¿Está seguro de que desea eliminar esta póliza?')) {
        try {
          await axios.delete('/delPoliza', { poliza: { numero_poliza: this.poliza.numero_poliza } })
          alert('Póliza eliminada con éxito')
          this.polizaEncontrada = false
          this.numeroPoliza = ''
        } catch (error) {
          console.error('Error eliminando la póliza:', error)
          alert('Error al eliminar la póliza')
        }
      }
    },
    async fetchData() {
      try {
        const [agenciasRes, tiposSeguroRes, tiposCoberturaRes, clientesRes] = await Promise.all([
          axios.get('/getAllAgencias'),
          axios.get('/getAllTipoSeguros'),
          axios.get('/getAllCoberturas'),
          axios.get('/getAllClientes'),
        ])
        this.agencias = agenciasRes.data.map((agencia) => ({
          id: agencia.id_agencia_seguro,
          nombre: agencia.nombre_agencia_seguro
        }))
        this.tiposCoberturas = tiposCoberturaRes.data.map((cobertura) => ({
          id: cobertura.id_tipo_cobertura,
          nombre: cobertura.nombre_tipo_cobertura
        }))
        this.tiposSeguro = tiposSeguroRes.data.map((tipo) => ({
          id: tipo.id_tipo_seguro,
          nombre: tipo.nombre_tipo_seguro
        }))
        this.clientes = clientesRes.data.map((cliente) => ({
          id: cliente.numero_identidad_cliente,
          nombre: cliente.nombre_cliente
        }))
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    }
  },
  mounted() {
    this.fetchData()
  }
}
</script>

<style scoped>
.formulario {
  background-color: #9E9B9B;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}

.campo {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input, select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.botones {
  display: flex;
  justify-content: space-between;
  margin-top: 20px;
}

.boton-submit,
.boton-eliminar {
  padding: 10px 15px;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 4px;
  font-size: 14px;
}

.boton-submit {
  background-color: #4caf50;
}

.boton-eliminar {
  background-color: #f44336;
}

.error-message {
  color: red;
  font-size: 12px;
  margin-top: 5px;
}
</style>
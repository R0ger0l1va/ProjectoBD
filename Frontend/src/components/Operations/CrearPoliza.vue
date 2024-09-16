<template>
  <div class="formulario">
    <h2>Crear Póliza de Seguro</h2>
    <form @submit.prevent="crearPoliza">
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
        <select id="cliente" v-model="poliza.numero_identidad_cliente" @change="fetchPolizas" required>
          <option v-for="cliente in clientes" :key="cliente.id" :value="cliente.id">
            {{ cliente.nombre }}
          </option>
        </select>
      </div>
      <div class="campo">
        <label for="numeroPoliza">Número de Póliza:</label>
        <input
          id="numeroPoliza"
          v-model.number="poliza.numero_poliza"
          type="number"
          required
          :class="{ error: polizaExistente }"
        />
        <span v-if="polizaExistente" class="error-message">Este número de póliza ya existe</span>
      </div>
      <button type="submit" class="boton-submit" :disabled="!formValido">Crear Póliza</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'CrearPoliza',
  data() {
    return {
      poliza: {
        numero_poliza: '',
        id_agencia_seguro: '',
        numero_identidad_cliente: '',
        id_estado_poliza: 3, // Asumiendo que 1 es el ID para "Activa"
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
      clientes: [],
      polizasExistentes: []
    }
  },
  computed: {
    polizaExistente() {
      return this.polizasExistentes.includes(this.poliza.numero_poliza)
    },
    formValido() {
      return (
        !this.polizaExistente &&
        this.poliza.numero_poliza &&
        this.poliza.id_agencia_seguro &&
        this.poliza.numero_identidad_cliente &&
        this.poliza.id_tipo_seguro &&
        this.poliza.fecha_inicio &&
        this.poliza.fecha_fin &&
        this.poliza.prima_mensual &&
        this.poliza.id_tipo_cobertura
      )
    }
  },
  methods: {
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
        console.log(this.agencias)
        console.log(this.tiposSeguro)
        console.log(this.tiposCoberturas)
        console.log(this.clientes)

        console.log(this.poliza.id_agencia_seguro)
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    },
     async fetchPolizas() {
       try {
        console.log(this.poliza);
        
        const res = await axios.get(`/getPolizas/${this.poliza.numero_identidad_cliente}`);
        this.polizasExistentes = res.data.map(p => p.numero_poliza);
        console.log(this.polizasExistentes);
        
      } catch (error) {
        console.error('Error fetching policies:', error);
      }
    },
    async crearPoliza() {
      if (!this.formValido) {
        alert('Por favor, complete todos los campos correctamente.')
        return
      }

      try {
        await axios.post('/postPoliza', this.poliza)
        alert('Póliza creada con éxito')
        // Reset form
        Object.keys(this.poliza).forEach((key) => (this.poliza[key] = ''))
      } catch (error) {
        console.error('Error creating policy:', error)
        alert('Error al crear la póliza')
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
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  max-width: 500px;
  margin: 0 auto;
}

.campo {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

input,
select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 14px;
}

input[type='number']::-webkit-inner-spin-button,
input[type='number']::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

.boton-submit {
  padding: 10px 15px;
  background-color: #4caf50;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 4px;
  font-size: 16px;
  width: 100%;
  transition: background-color 0.3s ease;
}

.boton-submit:hover {
  background-color: #45a049;
}

.boton-submit:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.error {
  border-color: #ff0000;
}

.error-message {
  color: #ff0000;
  font-size: 12px;
  margin-top: 5px;
  display: block;
}
</style>

<template>
  <div class="poliza-ops">
    <h2>Operaciones de Póliza de Seguro</h2>
    <div class="operation-selector">
      <button @click="currentOperation = 'crear'" :class="{ active: currentOperation === 'crear' }">Crear</button>
      <button @click="currentOperation = 'modificar'" :class="{ active: currentOperation === 'modificar' }">Modificar</button>
      <button @click="currentOperation = 'eliminar'" :class="{ active: currentOperation === 'eliminar' }">Eliminar</button>
    </div>

    <div v-if="currentOperation === 'crear'" class="formulario">
      <h3>Crear Póliza de Seguro</h3>
      <form @submit.prevent="crearPoliza">
        <div class="campo">
          <label for="agencia">Agencia:</label>
          <select id="agencia" v-model="poliza.id_agencia_seguro" @change="segurosDeAgencias" required>
            <option v-for="agencia in agencias" :key="agencia.id" :value="agencia.id">
              {{ agencia.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="tipoSeguro">Tipo de Seguro:</label>
          <select id="tipoSeguro" v-model="poliza.id_tipo_seguro" @change="compararNombre" required>
            <option v-for="tipo in tiposSeguro" :key="tipo.id" :value="tipo.id">
              {{ tipo.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="tipoCobertura">Cobertura:</label>
          <select id="tipoCobertura" v-model="poliza.id_tipo_cobertura" @change="calcularPagoMensual" required>
            <option v-for="cobertura in tiposCoberturas" :key="cobertura.id" :value="cobertura.id">
              {{ cobertura.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="fechaInicio">Fecha de Inicio:</label>
          <input id="fechaInicio" v-model="poliza.fecha_inicio" type="date" @change="calcularPagoMensual" required />
        </div>
        <div class="campo">
          <label for="fechaFin">Fecha de Finalización:</label>
          <input id="fechaFin" v-model="poliza.fecha_fin" type="date" @change="calcularPagoMensual" required />
        </div>
        <div class="campo">
          <label for="cliente">Cliente:</label>
          <select id="cliente" v-model="poliza.numero_identidad_cliente" required>
            <option v-for="cliente in clientes" :key="cliente.id" :value="cliente.id">
              {{ cliente.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label>Pago Mensual Calculado:</label>
          <span>{{ poliza.prima_mensual }}</span>
        </div>
        <button type="submit" class="boton-submit" :disabled="!formValido">Crear Póliza</button>
      </form>
    </div>

    <div v-if="currentOperation === 'modificar'" class="formulario">
      <h3>Modificar Póliza de Seguro</h3>
      <form @submit.prevent="buscarPoliza">
        <div class="campo">
          <label for="buscarNumeroPoliza">Número de Póliza:</label>
          <select id="buscarNumeroPoliza" v-model="numeroPolizaBusqueda" required>
            <option v-for="poliza in polizasExistentes" :key="poliza" :value="poliza">
              {{ poliza }}
            </option>
          </select>
        </div>
        <button type="submit" class="boton-submit">Buscar Póliza</button>
      </form>

      <form v-if="polizaEncontrada" @submit.prevent="modificarPoliza">
        <div class="campo">
          <label for="agenciaModificar">Agencia:</label>
          <select id="agenciaModificar" v-model="poliza.id_agencia_seguro" @change="segurosDeAgencias" required>
            <option v-for="agencia in agencias" :key="agencia.id" :value="agencia.id">
              {{ agencia.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="tipoSeguroModificar">Tipo de Seguro:</label>
          <select id="tipoSeguroModificar" v-model="poliza.id_tipo_seguro" required>
            <option v-for="tipo in tiposSeguro" :key="tipo.id" :value="tipo.id">
              {{ tipo.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="tipoCoberturaModificar">Cobertura:</label>
          <select id="tipoCoberturaModificar" v-model="poliza.id_tipo_cobertura" required>
            <option v-for="cobertura in tiposCoberturas" :key="cobertura.id" :value="cobertura.id">
              {{ cobertura.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="fechaInicioModificar">Fecha de Inicio:</label>
          <input id="fechaInicioModificar" v-model="poliza.fecha_inicio" type="date" required />
        </div>
        <div class="campo">
          <label for="fechaFinModificar">Fecha de Finalización:</label>
          <input id="fechaFinModificar" v-model="poliza.fecha_fin" type="date" required />
        </div>
        <div class="campo">
          <label for="clienteModificar">Cliente:</label>
          <select id="clienteModificar" v-model="poliza.numero_identidad_cliente" required>
            <option v-for="cliente in clientes" :key="cliente.id" :value="cliente.id">
              {{ cliente.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="ultimoPago">Último Pago:</label>
          <input
            id="ultimoPago"
            v-model.number="poliza.monto_total_asegurado"
            type="number"
            step="0.01"
            min="0"
            required
          />
        </div>
        <button type="submit" class="boton-submit">Modificar Póliza</button>
      </form>
    </div>

    <div v-if="currentOperation === 'eliminar'" class="formulario">
      <h3>Eliminar Póliza de Seguro</h3>
      <form @submit.prevent="eliminarPoliza">
        <div class="campo">
          <label for="eliminarNumeroPoliza">Número de Póliza:</label>
          <select id="eliminarNumeroPoliza" v-model="numeroPolizaBusqueda" required>
            <option v-for="poliza in polizasExistentes" :key="poliza" :value="poliza">
              {{ poliza }}
            </option>
          </select>
        </div>
        <button type="submit" class="boton-eliminar">Eliminar Póliza</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'PolizaOps',
  data() {
    return {
      currentOperation: 'crear',
      numeroPolizaBusqueda: '',
      polizaEncontrada: false,
      poliza: {
        numero_poliza: 0,
        id_agencia_seguro: 0,
        numero_identidad_cliente: 0,
        id_estado_poliza: 3,
        id_tipo_seguro: 0,
        fecha_inicio: '',
        fecha_fin: '',
        prima_mensual: 0.0,
        monto_total_asegurado: 0.0,
        id_tipo_cobertura: 0,
      },
      agencias: [],
      segurosAge: [],
      tiposSeguro: [],
      tiposCoberturas: [],
      clientes: [],
      polizasExistentes: []
    }
  },
  computed: {
    formValido() {
      return (
        this.poliza.id_agencia_seguro &&
        this.poliza.numero_identidad_cliente &&
        this.poliza.id_tipo_seguro &&
        this.poliza.fecha_inicio &&
        this.poliza.fecha_fin &&
        this.poliza.id_tipo_cobertura
      )
    },
    fechasValidas() {
      if (this.poliza.fecha_inicio && this.poliza.fecha_fin) {
        return new Date(this.poliza.fecha_inicio) < new Date(this.poliza.fecha_fin)
      }
      return true
    }
  },
  methods: {
    async buscarPoliza() {
      try {
        const response = await axios.get(`/getPoliza/${this.numeroPolizaBusqueda}`)
        this.poliza = response.data
        this.polizaEncontrada = true
      } catch (error) {
        console.error('Error buscando la póliza:', error)
        alert('No se encontró la póliza o hubo un error en la búsqueda.')
        this.polizaEncontrada = false
      }
    },
    async fetchData() {
      try {
        const [agenciasRes, tiposCoberturaRes, clientesRes, polizasRes] = await Promise.all([
          axios.get('/getAllAgencias'),
          axios.get('/getAllCoberturas'),
          axios.get('/getAllClientes'),
          axios.get('/getAllPolizas'),
        ])
        this.agencias = agenciasRes.data.map((agencia) => ({
          id: agencia.id_agencia_seguro,
          nombre: agencia.nombre_agencia_seguro
        }))

        this.tiposCoberturas = tiposCoberturaRes.data.map((cobertura) => ({
          id: cobertura.id_tipo_cobertura,
          nombre: cobertura.nombre_tipo_cobertura
        }))
        
        this.clientes = clientesRes.data.map((cliente) => ({
          id: cliente.numero_identidad_cliente,
          nombre: cliente.nombre_cliente
        }))
        this.polizasExistentes = polizasRes.data.map(p => p.numero_poliza)
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    },
    async segurosDeAgencias() {
      try {
        if (this.poliza.id_agencia_seguro) {
           const tiposSeguroRes = await axios.get('/getAllTipoSeguros')
          this.tiposSeguro = tiposSeguroRes.data.map((tipo) => ({
          id: tipo.id_tipo_seguro,
          nombre: tipo.nombre_tipo_seguro
        }))
          const segAge = await axios.get(`/getSegurosAgencia/${this.poliza.id_agencia_seguro}`)
          this.segurosAge = segAge.data
          console.log(this.segurosAge);
           console.log(this.tiposSeguro);
          
          this.tiposSeguro = this.tiposSeguro.filter(tipo => 
            this.segurosAge.some(seguro => seguro === tipo.nombre)
          )
          console.log(JSON.stringify(this.tiposSeguro) );
          
          this.poliza.id_tipo_seguro = '' // Reset the selected insurance type
        }
      } catch (error) {
        alert(error.response + " " + "No se ha encontrado ningún seguro de esta Agencia")
        this.tiposSeguro = []
      }
    },
    calcularPagoMensual() {
      if (this.poliza.fecha_inicio && this.poliza.fecha_fin && this.poliza.id_tipo_cobertura) {
        const inicio = new Date(this.poliza.fecha_inicio)
        const fin = new Date(this.poliza.fecha_fin)
        const diasDiferencia = (fin - inicio) / (1000 * 60 * 60 * 24)
        const cobertura = this.tiposCoberturas.find(c => c.id === this.poliza.id_tipo_cobertura)
        console.log(cobertura.id);
        
          switch (cobertura.id) {
            case 1:
              this.poliza.prima_mensual = (5000 * diasDiferencia/30).toFixed(2)
              break;
              case 2:
              this.poliza.prima_mensual =(3000 *diasDiferencia/30).toFixed(2)
              break;
              case 3:
              this.poliza.prima_mensual =(1000 * diasDiferencia/30).toFixed(2)
              break;
            default:
               this.poliza.prima_mensual = 0

              break;
          }
        
      }
    },
    async compararNombre() {
      const token = sessionStorage.getItem('token')
      if (this.currentOperation === 'crear' || this.currentOperation === 'modificar') {
        try {
          const response = await axios.get(`/getCliente/${this.poliza.numero_identidad_cliente}`,{
          headers:{
            Authorization:`Bearer ${token}`
          }
        })
          this.nombreExistente = response.data.exists
          if (this.nombreExistente) {
            alert('Ya existe un seguro con este nombre.')
          }
        } catch (error) {
          console.error('Error al verificar el nombre:', error)
        }
      }
    },
    async crearPoliza() {
      if (!this.formValido) {
        alert('Por favor, complete todos los campos correctamente.')
        return
      }

      if (!this.fechasValidas) {
        alert('La fecha de finalización debe ser posterior a la fecha de inicio.')
        return
      }

      try {
        await axios.post('/postPoliza', this.poliza)
        alert('Póliza creada con éxito')
        this.resetForm()
      } catch (error) {
        console.error('Error creating policy:', error)
        alert('Error al crear la póliza')
      }
    },

    async modificarPoliza() {
      if (!this.formValido) {
        alert('Por favor, complete todos los campos correctamente.')
        return
      }

      if (!this.fechasValidas) {
        alert('La fecha de finalización debe ser posterior a la fecha de inicio.')
        return
      }

      try {
        await axios.put('/actPoliza', this.poliza)
        alert('Póliza modificada con éxito')
        this.resetForm()
      } catch (error) {
        console.error('Error modificando la póliza:', error)
        alert('Error al modificar la póliza')
      }
    },
    async eliminarPoliza() {
      if (confirm('¿Está seguro de que desea eliminar esta póliza?')) {
        try {
          await axios.delete(`/delPoliza/${this.numeroPolizaBusqueda}`)
          alert('Póliza eliminada con éxito')
          this.resetForm()
        } catch (error) {
          console.error('Error eliminando la póliza:', error)
          alert('Error al eliminar la póliza')
        }
      }
    },
    resetForm() {
      this.polizaEncontrada = false
      this.numeroPolizaBusqueda = ''
      Object.keys(this.poliza).forEach((key) => (this.poliza[key] = 3))
    }
  },
  mounted() {
    this.fetchData()
  }, watch: {
    'poliza.fecha_inicio': function() {
      this.calcularPagoMensual()
    },
    'poliza.fecha_fin': function() {
      this.calcularPagoMensual()
    },
    'poliza.id_tipo_cobertura': function() {
      this.calcularPagoMensual()
    },
    'poliza.id_tipo_seguro': function() {
      this.compararNombre()
    }
  },
}
</script>

<style scoped>
.poliza-ops {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.operation-selector {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.operation-selector button {
  flex: 1;
  padding: 10px;
  background-color: #f0f0f0;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

.operation-selector button.active {
  background-color: #4caf50;
  color: white;
}

.formulario {
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
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
  transition: background-color 0.3s ease;
}

.boton-submit {
  background-color: #4caf50;
}

.boton-submit:hover {
  background-color: #45a049;
}

.boton-submit:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.boton-eliminar {
  background-color: #f44336;
}

.boton-eliminar:hover {
  background-color: #d32f2f;
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
<template>
  <div class="formulario">
    <h2>Modificar/Eliminar Póliza de Seguro</h2>
    <form @submit.prevent="modificarPoliza">
      <div class="campo">
        <label for="numeroPoliza">Número de Póliza:</label>
        <input id="numeroPoliza" v-model="numeroPoliza" required />
      </div>
      <div class="campo">
        <label for="empresa">Empresa:</label>
        <input id="empresa" v-model="poliza.empresa" />
      </div>
      <div class="campo">
        <label for="montoCobertura">Monto de Cobertura:</label>
        <input id="montoCobertura" v-model.number="poliza.montoCobertura" type="number" />
      </div>
      <div class="campo">
        <label for="fechaInicio">Fecha de Inicio:</label>
        <input id="fechaInicio" v-model="poliza.fechaInicio" type="date" />
      </div>
      <div class="campo">
        <label for="fechaFin">Fecha de Finalización:</label>
        <input id="fechaFin" v-model="poliza.fechaFin" type="date" />
      </div>
      <div class="campo">
        <label for="nombreCliente">Nombre del Cliente:</label>
        <input id="nombreCliente" v-model="poliza.nombreCliente" />
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
export default {
  name: 'ModificarPoliza',
  data() {
    return {
      numeroPoliza: '',
      poliza: {
        empresa: '',
        montoCobertura: null,
        fechaInicio: '',
        fechaFin: '',
        nombreCliente: ''
      }
    }
  },
  methods: {
    modificarPoliza() {
      console.log('Póliza modificada:', this.poliza)
      alert('Póliza modificada con éxito')
    },
    eliminarPoliza() {
      console.log('Póliza eliminada:', this.numeroPoliza)
      alert('Póliza eliminada con éxito')
    }
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

input {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.botones {
  display: flex;
  justify-content: space-between;
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
</style>

<template>
  <div class="formulario">
    <h2>Crear Póliza de Seguro</h2>
    <form @submit.prevent="crearPoliza">
      <div class="campo">
        <label for="empresa">Empresa:</label>
        <input id="empresa" v-model="poliza.empresa" required />
      </div>
      <div class="campo">
        <label for="montoCobertura">Monto de Cobertura:</label>
        <input id="montoCobertura" v-model.number="poliza.montoCobertura" type="number" required />
      </div>
      <div class="campo">
        <label for="fechaInicio">Fecha de Inicio:</label>
        <input id="fechaInicio" v-model="poliza.fechaInicio" type="date" required />
      </div>
      <div class="campo">
        <label for="fechaFin">Fecha de Finalización:</label>
        <input id="fechaFin" v-model="poliza.fechaFin" type="date" required />
      </div>
      <div class="campo">
        <label for="nombreCliente">Nombre del Cliente:</label>
        <input id="nombreCliente" v-model="poliza.nombreCliente" required />
      </div>
      <div class="campo">
        <label for="numeroPoliza">Número de Póliza:</label>
        <input id="numeroPoliza" v-model="poliza.numeroPoliza" required />
      </div>
      <button type="submit" class="boton-submit">Crear Póliza</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'CrearPoliza',
  data() {
    return {
      poliza: {
        empresa: '',
        montoCobertura: null,
        fechaInicio: '',
        fechaFin: '',
        nombreCliente: '',
        numeroPoliza: ''
      }
    }
  },
  methods: {
    crearPoliza() {
      console.log('Póliza creada:', this.poliza)
      this.poliza = {
        empresa: '',
        montoCobertura: null,
        fechaInicio: '',
        fechaFin: '',
        nombreCliente: '',
        numeroPoliza: ''
      }
      alert('Póliza creada con éxito')
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

.boton-submit {
  padding: 10px 15px;
  background-color: #4caf50;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 4px;
  font-size: 14px;
}
</style>

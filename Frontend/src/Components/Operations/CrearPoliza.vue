<template>
  <div class="crear-poliza">
    <h2>Crear Nueva Póliza</h2>
    <form @submit.prevent="crearPoliza">
      <div class="form-group">
        <label for="companyName">Empresa Aseguradora:</label>
        <input type="text" id="companyName" v-model="nuevaPoliza.companyName" required>
      </div>
      <div class="form-group">
        <label for="clientName">Nombre del Cliente:</label>
        <input type="text" id="clientName" v-model="nuevaPoliza.clientName" required>
      </div>
      <div class="form-group">
        <label for="policyNumber">Número de Póliza:</label>
        <input type="text" id="policyNumber" v-model="nuevaPoliza.policyNumber" required>
      </div>
      <div class="form-group">
        <label for="startDate">Fecha de Inicio:</label>
        <input type="date" id="startDate" v-model="nuevaPoliza.startDate" required>
      </div>
      <div class="form-group">
        <label for="endDate">Fecha de Finalización:</label>
        <input type="date" id="endDate" v-model="nuevaPoliza.endDate" required>
      </div>
      <div class="form-group">
        <label for="coverageAmount">Monto de Cobertura:</label>
        <input type="number" id="coverageAmount" v-model="nuevaPoliza.coverageAmount" required>
      </div>
      <button type="submit">Crear Póliza</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'CrearPoliza',
  data() {
    return {
      nuevaPoliza: {
        companyName: '',
        clientName: '',
        policyNumber: '',
        startDate: '',
        endDate: '',
        coverageAmount: null
      }
    }
  },
  methods: {
    crearPoliza() {
      // Aquí iría la lógica para crear la póliza
      console.log('Nueva póliza creada:', this.nuevaPoliza);
      // Resetear el formulario
      this.nuevaPoliza = {
        companyName: '',
        clientName: '',
        policyNumber: '',
        startDate: '',
        endDate: '',
        coverageAmount: null
      };
    }
  }
}
</script>

<style scoped>
.crear-poliza {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f0f0f0;
  border-radius: 8px;
  color: #333;
}

h2 {
  text-align: center;
  color:#44917c;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  color:#44917c;
}

input {
  width: 100%;
  padding: 8px;
  border: 1px solid #7d8f69;
  border-radius: 4px;
  background-color: #ffffff;
  color: #333;
  transition: border-color 0.3s;
}

input:focus {
  border-color:#44917c;
  outline: none;
}

button {
  width: 100%;
  padding: 10px;
  background-color:#44917c;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #3a4a1c;
}

button:active {
  background-color: #2a3615;
}
</style>
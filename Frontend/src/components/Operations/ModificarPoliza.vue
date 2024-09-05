<template>
  <div class="modificar-poliza">
    <h2>Modificar Póliza</h2>
    <form @submit.prevent="actualizarPoliza">
      <div class="form-group">
        <label for="companyName">Empresa Aseguradora:</label>
        <input type="text" id="companyName" v-model="polizaActual.companyName" required>
      </div>
      <div class="form-group">
        <label for="clientName">Nombre del Cliente:</label>
        <input type="text" id="clientName" v-model="polizaActual.clientName" required>
      </div>
      <div class="form-group">
        <label for="policyNumber">Número de Póliza:</label>
        <input type="text" id="policyNumber" v-model="polizaActual.policyNumber" required>
      </div>
      <div class="form-group">
        <label for="startDate">Fecha de Inicio:</label>
        <input type="date" id="startDate" v-model="polizaActual.startDate" required>
      </div>
      <div class="form-group">
        <label for="endDate">Fecha de Finalización:</label>
        <input type="date" id="endDate" v-model="polizaActual.endDate" required>
      </div>
      <div class="form-group">
        <label for="coverageAmount">Monto de Cobertura:</label>
        <input type="number" id="coverageAmount" v-model="polizaActual.coverageAmount" required>
      </div>
      <button type="submit">Actualizar Póliza</button>
    </form>
    <button @click="eliminarPoliza" class="delete-button">Eliminar Póliza</button>
  </div>
</template>

<script>
export default {
  name: 'ModificarPoliza',
  props: {
    polizaId: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      polizaActual: {
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
    actualizarPoliza() {
      // Aquí iría la lógica para actualizar la póliza
      console.log('Póliza actualizada:', this.polizaActual);
    },
    eliminarPoliza() {
      // Aquí iría la lógica para eliminar la póliza
      console.log('Póliza eliminada:', this.polizaId);
    }
  },
  mounted() {
    // Aquí se cargarían los datos de la póliza actual
    // Por ahora, usaremos datos de ejemplo
    this.polizaActual = {
      companyName: 'Seguros XYZ',
      clientName: 'Juan Pérez',
      policyNumber: 'POL-12345',
      startDate: '2023-01-01',
      endDate: '2023-12-31',
      coverageAmount: 100000
    };
  }
}
</script>

<style scoped>
.modificar-poliza {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f0f0f0;
  border-radius: 8px;
  color: #333;
}

h2 {
  text-align: center;
  color: #44917c;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  color: #44917c;
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
  border-color: #44917c;
  outline: none;
}

button {
  width: 100%;
  padding: 10px;
  background-color: #44917c;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
  margin-bottom: 10px;
}

button:hover {
  background-color: #3a4a1c;
}

button:active {
  background-color: #2a3615;
}

.delete-button {
  background-color: #8B0000;
}

.delete-button:hover {
  background-color: #6B0000;
}

.delete-button:active {
  background-color: #4B0000;
}
</style>
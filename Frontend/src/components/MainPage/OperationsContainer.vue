<template>
  <div class="operations-container">
    <div class="operations-wrapper">
      <div class="operations-content">
        <h2 class="operations-title">Operaciones Principales</h2>
        <p class="operations-subtitle">Trabajo con Polizas de Seguro</p>
        <div class="operations-grid">
          <div 
            v-for="(op, index) in operations" 
            :key="index" 
            class="operation-card"
            :class="{ 'selected': selectedOperation === index }"
            @click="selectOperation(index)"
          >
            <div class="operation-card-content">
              <h3 class="operation-card-title">{{ op.name }}</h3>
              <p class="operation-card-description">{{ op.description }}</p>
            </div>
          </div>
          <button class="boton-accion"
      :class="{ 'activo': selectedOperation !== null }"
      @click="realizarAccion"  ><h3>Seleccionar</h3></button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useRouter } from 'vue-router'

export default {
  name: 'OperationsContainer',
  data() {
    return {
      selectedOperation: null,
      operations: [
        {
          name: "Crear Poliza",
          ruta: '/crearPoliza',
          description: "Introducir los datos especificos de un cliente en el formulario para crear una poliza de seguro."
        },
        {
          name: "Modificar Poliza ",
          ruta: '/modPoliza',
          description: "Introducir datos en el formulario y segun el id del cliente poder eliminar o actualizar la poliza de seguro."
        },
        {
          name: "Lista de Seguros",
          ruta: '/listPoliza',
          description: "Registro de todos los seguros junto con su estado actual."
        }
      ]
    }
  },
  methods: {
    selectOperation(index) {
      this.selectedOperation = index;
    },

    realizarAccion() {
      if (this.seleccionado !== null) {
        const rutaSeleccionada = this.operations[this.selectedOperation].ruta;
        // Aquí puedes usar vue-router para navegar a la ruta seleccionada
        this.$router.push(rutaSeleccionada) // this.$router.push(rutaSeleccionada);
        console.log(`Navegando a: ${rutaSeleccionada}`);
      }
    }
  }
}
</script>


<style scoped>

.boton-accion {
  position: relative;
  width: 80%;
  max-width: 300px;
  right: -290px;
  margin-top: 20px;
  padding: 10px 20px;
  background-color: #44917c;
  color: white;
  border: none;
  border-radius: 20px;
  font-size: 1em;
  cursor: pointer;
  transition: background-color 0.3s ease;
  opacity: 0.6;
}

.boton-accion.activo {
  opacity: 1;
}

.boton-accion:hover {
  background-color: #45a049;
}

.boton-accion:active {
  transform: scale(0.98);}



.operations-container {
  padding: 24px;
  background-color: #f3f4f6;
  min-height: 100vh;
}

.operations-wrapper {
  width: 100%;
  max-width: 896px;
  margin: 0 auto;
  background-color: #ffffff;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  border-radius: 40px;
  overflow: hidden;
}

.operations-content {
  padding: 24px;
}

.operations-title {
  font-size: 24px;
  font-weight: bold;
  text-align: center;
  margin-bottom: 8px;
}

.operations-subtitle {
  text-align: center;
  color: #6b7280;
  margin-bottom: 24px;
}

.operations-grid {
  display: grid;
  gap: 16px;
}

@media (min-width: 768px) {
  .operations-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

.operation-card {
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
}

.operation-card:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.operation-card.selected {
  box-shadow: 0 0 0 2px #44917c;
}

.operation-card-content {
  padding: 16px;
}

.operation-card-title {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 8px;
}

.operation-card-description {
  font-size: 14px;
  color: #6b7280;
}
</style>
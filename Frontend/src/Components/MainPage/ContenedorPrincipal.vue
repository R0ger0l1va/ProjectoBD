<template>
  <div class="contenedor-principal">
    <h2>{{ nombreContenedor }}</h2>
    <div class="subcontenedores">
      <div
        v-for="(subcontenedor, index) in subcontenedores"
        :key="index"
        class="subcontenedor"
        :class="{ 'seleccionado': seleccionado === index }"
        @click="seleccionar(index)"
      >
        <h3>{{ subcontenedor.nombre }}</h3>
        <p>{{ subcontenedor.descripcion }}</p>
      </div>
    </div>
    <button
      class="boton-accion"
      :class="{ 'activo': seleccionado !== null }"
      @click="realizarAccion"
    >
      Ir al componente seleccionado
    </button>
  </div>
</template>

<script>
export default {
  name: 'ContenedorPrincipal',
  data() {
    return {
      nombreContenedor: 'Contenedor Principal',
      subcontenedores: [
        { nombre: 'Subcontenedor 1', descripcion: 'Descripción breve del subcontenedor 1', ruta: '/componente1' },
        { nombre: 'Subcontenedor 2', descripcion: 'Descripción breve del subcontenedor 2', ruta: '/componente2' },
        { nombre: 'Subcontenedor 3', descripcion: 'Descripción breve del subcontenedor 3', ruta: '/componente3' },
        { nombre: 'Subcontenedor 4', descripcion: 'Descripción breve del subcontenedor 4', ruta: '/componente4' },
      ],
      seleccionado: null
    }
  },
  methods: {
    seleccionar(index) {
      this.seleccionado = index;
    },
    realizarAccion() {
      if (this.seleccionado !== null) {
        const rutaSeleccionada = this.subcontenedores[this.seleccionado].ruta;
        // Aquí puedes usar vue-router para navegar a la ruta seleccionada
        // this.$router.push(rutaSeleccionada);
        console.log(`Navegando a: ${rutaSeleccionada}`);
      }
    }
  }
}
</script>

<style scoped>
.contenedor-principal {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f0f0f0;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h2 {
  text-align: center;
  color: #333;
}

.subcontenedores {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-around;
  margin-bottom: 20px;
}

.subcontenedor {
  width: calc(50% - 20px);
  margin: 10px;
  padding: 15px;
  background-color: #fff;
  border: 2px solid #ddd;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.subcontenedor:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.subcontenedor.seleccionado {
  border-color: #4CAF50;
  background-color: #E8F5E9;
}

.subcontenedor h3 {
  margin-top: 0;
  color: #2c3e50;
}

.subcontenedor p {
  color: #666;
  font-size: 0.9em;
}

.boton-accion {
  display: block;
  width: 80%;
  max-width: 300px;
  margin: 20px auto 0;
  padding: 10px 20px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
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
  transform: scale(0.98);
}

@media (max-width: 600px) {
  .subcontenedor {
    width: 100%;
  }
}
</style>
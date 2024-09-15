<template>
  <div class="contenedor-principal">
    <h1 class="titulo-principal">Sistema de Gestión de Pólizas de Seguro</h1>
    <h2 class="titulo-principal"> Operador: {{nombreOperador}}</h2>
    <div >
      <div class="contenedores">
        <div v-for="(operacion, index) in operacionesVisibles" :key="index" class="contenedor"
          :class="{ 'seleccionado': seleccionado === index }" @click="seleccionar(index)" @mouseover="hover = index"
          @mouseleave="hover = null">
          <h2>{{ operacion.nombre }}</h2>
          <p>{{ operacion.descripcion }}</p>
        </div>
      </div>
      <button @click="mostrarComponente" :disabled="seleccionado === null" class="boton-principal">
        {{ seleccionado !== null ? `Mostrar ${operacionesVisibles[seleccionado].nombre}` : 'Seleccione una operación' }}
      </button>

      <div v-if="componenteActivo" class="componente-activo">
        <button @click="ocultarComponente" class="boton-regresar">Regresar</button>
        <component :is="componenteActivo"></component>
      </div>
    </div>
  </div>
</template>

<script>
import CrearPoliza from '../Operations/CrearPoliza.vue';
import ModificarPoliza from '../Operations/ModificarPoliza.vue';
import ListarPolizas from '../Operations/ListarPolizas.vue';
import Reclamacion from '../Operations/Reclamacion.vue';
import CrearUsuario from '../Operations/CrearUsuario.vue';
import LoginRegister from '../Login/LoginRegister.vue';

export default {
  name: 'GestorPolizas',
  components: {
    CrearPoliza,
    ModificarPoliza,
    ListarPolizas,
    Reclamacion,
    CrearUsuario,
    LoginRegister
  },
  data() {
    return {
      operaciones: [
        { nombre: 'Crear Póliza', descripcion: 'Crea una nueva póliza de seguro', componente: CrearPoliza },
        { nombre: 'Modificar Póliza', descripcion: 'Modifica o elimina una póliza existente', componente: ModificarPoliza },
        { nombre: 'Listar Pólizas', descripcion: 'Muestra todas las pólizas con opciones de filtrado', componente: ListarPolizas },
        { nombre: 'Reclamación', descripcion: 'Realiza una reclamación de seguro', componente: Reclamacion },
        { nombre: 'Crear Usuario', descripcion: 'Crea un nuevo trabajador o cliente', componente: CrearUsuario }
      ],
      seleccionado: null,
      nombreOperador: '',
      hover: null,
      userType : null,
      componenteActivo: null,
      isAdminG: false,
      isLoggedIn: false
    }
  },

  computed: {
    operacionesVisibles() {
      if (this.isAdminG) {
        return this.operaciones;
      } else if (this.isLoggedIn) {
        return this.operaciones.filter(op => op.nombre !== 'Crear Usuario');
      } else {
        return [];
      }
    }
  },

  created() {
    const userType = JSON.parse(sessionStorage.getItem("session"));
    this.nombreOperador = userType.nombre_usuario
    
    if (userType.rol === 'AdminGen') {
      this.isAdminG = true;
      this.isLoggedIn = true;
    } else if (userType.rol === 'Vendedor') {
      this.isLoggedIn = true;
    }
  },
 
  
  methods: {
    seleccionar(index) {
      this.seleccionado = index;
    },
    mostrarComponente() {
      if (this.seleccionado !== null) {
        this.componenteActivo = this.operacionesVisibles[this.seleccionado].componente;
      }
    },
    
    ocultarComponente() {
      this.componenteActivo = null;
      this.seleccionado = null;
    },
   
     
  }
}
</script>

<style scoped>
.contenedor-principal {
  font-family: Arial, sans-serif;
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f5f5f5;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.titulo-principal {
  text-align: center;
  color: #333;
  margin-bottom: 30px;
}

.contenedores {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  margin-bottom: 20px;
}

.contenedor {
  border: 1px solid #ccc;
  padding: 15px;
  width: calc(33.33% - 10px);
  margin-bottom: 15px;
  cursor: pointer;
  transition: all 0.3s ease;
  background-color: white;
  border-radius: 5px;
}

.contenedor:hover {
  background-color: #f0f0f0;
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.seleccionado {
  background-color: #e0e0e0;
  border: 2px solid #4CAF50;
}

.boton-principal {
  display: block;
  margin: 20px auto;
  padding: 10px 20px;
  background-color: #4CAF50;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 5px;
  font-size: 16px;
  transition: background-color 0.3s ease;
}

.boton-principal:hover {
  background-color: #45a049;
}

.boton-principal:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.componente-activo {
  margin-top: 20px;
  border: 1px solid #ccc;
  padding: 20px;
  background-color: white;
  border-radius: 5px;
}

.boton-regresar {
  margin-bottom: 10px;
  padding: 5px 10px;
  background-color: #f44336;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 3px;
}
</style>
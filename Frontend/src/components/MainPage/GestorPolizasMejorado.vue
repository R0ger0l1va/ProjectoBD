<template>
  <div class="contenedor-principal">
    <h1 class="titulo-principal">Sistema de Gestión de Pólizas de Seguro</h1>
    <h2 class="titulo-principal">Operador: {{ nombreOperador }}</h2>
    <div class="contenido">
      <div class="contenedores">
        <div
          v-for="(operacion, index) in operacionesVisibles"
          :key="index"
          class="contenedor"
          :class="{ 'seleccionado': seleccionado === index }"
          @click="seleccionar(index)"
        >
          <h2>{{ operacion.nombre }}</h2>
          <p>{{ operacion.descripcion }}</p>
        </div>
      </div>
      <div v-if="componenteActivo" class="componente-activo">
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
import GenerarReportes from '../Operations/GenerarReportes.vue';
import DatosAgencia from '../Operations/DatosAgencia.vue';
import PolizaOps from '../Operations/PolizaOps.vue';

export default {
  name: 'GestorPolizas',
  components: {
    CrearPoliza,
    ModificarPoliza,
    ListarPolizas,
    Reclamacion,
    CrearUsuario,
    GenerarReportes,
    DatosAgencia,
    PolizaOps
  },
  data() {
    return {
      operaciones: [
        { nombre: 'Crear Póliza', descripcion: 'Crea una nueva póliza de seguro', componente: CrearPoliza },
        { nombre: 'Modificar Póliza', descripcion: 'Modifica o elimina una póliza existente', componente: ModificarPoliza },
        { nombre: 'Listar Pólizas', descripcion: 'Muestra todas las pólizas con opciones de filtrado', componente: ListarPolizas },
        { nombre: 'Reclamación', descripcion: 'Realiza una reclamación de seguro', componente: Reclamacion },
        { nombre: 'Crear Usuario', descripcion: 'Crea un nuevo trabajador o cliente', componente: CrearUsuario },
        { nombre: 'Generar Reportes y Salidas', descripcion: 'Genera reportes en PDF de la base de datos', componente: GenerarReportes },
        { nombre: 'Datos De la Empresa', descripcion: 'Operaciones con los datos Adicionales de la Empresa', componente: DatosAgencia },
                { nombre: 'Pol', descripcion: 'Operaciones con los datos Adicionales de la Empresa', componente: PolizaOps }

      ],
      seleccionado: null,
      nombreOperador: '',
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
        return this.operaciones.filter(op => op.nombre !== 'Crear Usuario' && op.nombre !== 'Generar Reportes y Salidas' && op.nombre !== 'Datos De la Empresa');
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
      this.componenteActivo = this.operacionesVisibles[index].componente;
    }
  }
}
</script>

<style scoped>
.contenedor-principal {
  font-family: Arial, sans-serif;
  max-width: 1200px;
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

.contenido {
  display: flex;
  gap: 20px;
}

.contenedores {
  flex: 0 0 300px;
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.contenedor {
  border: 1px solid #ccc;
  padding: 15px;
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

.componente-activo {
  flex: 1;
  border: 1px solid #ccc;
  padding: 20px;
  background-color: white;
  border-radius: 5px;
}

h2 {
  margin-top: 0;
  color: #333;
}

p {
  color: #666;
  font-size: 14px;
}
</style>
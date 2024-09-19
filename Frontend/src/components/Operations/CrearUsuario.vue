<template>
  <div class="formulario">
    <h2>Crear Trabajador/Cliente</h2>
    <form @submit.prevent="crearUsuario">
      <div class="campo">
        <label for="tipoUsuario">Tipo de Usuario:</label>
        <select id="tipoUsuario" v-model="usuario.tipo" required @change="resetForm">
          <option value="trabajador">Trabajador</option>
          <option value="cliente">Cliente</option>
        </select>
      </div>

      <!-- Campos comunes -->
      <div class="campo">
        <label for="nombre">Nombre:</label>
        <input id="nombre" v-model="usuario.nombre" required @blur="validateName">
        <span v-if="errors.nombre" class="error-message">{{ errors.nombre }}</span>
      </div>
      <div class="campo">
        <label for="password">Contraseña:</label>
        <input id="password" v-model="usuario.password" type="password" required>
      </div>

      <!-- Campos específicos para Trabajador -->
      <div v-if="usuario.tipo === 'trabajador'">
        <div class="campo">
          <label for="rol">Rol:</label>
          <select id="rol" v-model="usuario.rol" required>
            <option value="AdminG">AdminG</option>
            <option value="Vendedor">Vendedor</option>
          </select>
        </div>
      </div>

      <!-- Campos específicos para Cliente -->
      <div v-if="usuario.tipo === 'cliente'">
        <div class="campo">
          <label for="apellido">Apellido:</label>
          <input id="apellido" v-model="usuario.apellido">
        </div>
        <div class="campo">
          <label for="numeroIdentidad">Número de Identidad:</label>
          <input id="numeroIdentidad" v-model="usuario.numeroIdentidad">
        </div>
        <div class="campo">
          <label for="sexo">Sexo:</label>
          <select id="sexo" v-model="usuario.sexo" required>
            <option value="masculino">Masculino</option>
            <option value="femenino">Femenino</option>
          </select>
        </div>
        <div class="campo">
          <label for="edad">Edad:</label>
          <input id="edad" v-model="usuario.edad" type="number" required>
        </div>
        <div class="campo">
          <label for="direccionPostal">Dirección Postal:</label>
          <input id="direccionPostal" v-model="usuario.direccionPostal">
        </div>
        <div class="campo">
          <label for="telefono">Teléfono:</label>
          <input id="telefono" v-model="usuario.telefono">
        </div>
        <div class="campo">
          <label for="email">Email:</label>
          <input id="email" v-model="usuario.email" type="email" required>
        </div>
      </div>

      <button type="submit" class="boton-submit">Crear Usuario</button>
    </form>

    <!-- Sección para modificar o eliminar trabajador -->
    <div v-if="usuario.tipo === 'trabajador'" class="operaciones-trabajador">
      <h3>Modificar o Eliminar Trabajador</h3>
      <div class="campo">
        <label for="idTrabajador">ID del Trabajador:</label>
        <select id="idTrabajador" v-model="idTrabajadorOperacion" @change="buscarTrabajador">
          <option v-for="id in trabajadoresIds" :key="id" :value="id">{{ id }}</option>
        </select>
      </div>

      <form v-if="trabajadorEncontrado" @submit.prevent="modificarTrabajador">
        <div class="campo">
          <label for="nombreModificarTrabajador">Nombre:</label>
          <input id="nombreModificarTrabajador" v-model="trabajadorModificar.nombre" required>
        </div>
        <div class="campo">
          <label for="rolModificarTrabajador">Rol:</label>
          <select id="rolModificarTrabajador" v-model="trabajadorModificar.rol" required>
            <option value="AdminG">AdminG</option>
            <option value="Vendedor">Vendedor</option>
          </select>
        </div>
        <button type="submit" class="boton-submit">Modificar Trabajador</button>
      </form>

      <button v-if="trabajadorEncontrado" @click="eliminarTrabajador" class="boton-eliminar">Eliminar Trabajador</button>
    </div>

    <!-- Sección para modificar o eliminar cliente -->
    <div v-if="usuario.tipo === 'cliente'" class="operaciones-cliente">
      <h3>Modificar o Eliminar Cliente</h3>
      <div class="campo">
        <label for="numeroCliente">Número de Cliente:</label>
        <select id="numeroCliente" v-model="numeroClienteOperacion" @change="buscarCliente">
          <option v-for="id in clientesIds" :key="id" :value="id">{{ id }}</option>
        </select>
      </div>

      <form v-if="clienteEncontrado" @submit.prevent="modificarCliente">
        <div class="campo">
          <label for="nombreModificar">Nombre:</label>
          <input id="nombreModificar" v-model="clienteModificar.nombre" required>
        </div>
        <div class="campo">
          <label for="apellidoModificar">Apellido:</label>
          <input id="apellidoModificar" v-model="clienteModificar.apellido">
        </div>
        <div class="campo">
          <label for="edadModificar">Edad:</label>
          <input id="edadModificar" v-model="clienteModificar.edad" type="number" required>
        </div>
        <div class="campo">
          <label for="direccionPostalModificar">Dirección Postal:</label>
          <input id="direccionPostalModificar" v-model="clienteModificar.direccionPostal">
        </div>
        <div class="campo">
          <label for="telefonoModificar">Teléfono:</label>
          <input id="telefonoModificar" v-model="clienteModificar.telefono">
        </div>
        <div class="campo">
          <label for="emailModificar">Email:</label>
          <input id="emailModificar" v-model="clienteModificar.email" type="email" required>
        </div>
        <button type="submit" class="boton-submit">Modificar Cliente</button>
      </form>

      <button v-if="clienteEncontrado" @click="eliminarCliente" class="boton-eliminar">Eliminar Cliente</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'CrearUsuario',
  data() {
    return {
      usuario: {
        tipo: 'trabajador',
        nombre: '',
        password: '',
        rol: '',
        apellido: '',
        numeroIdentidad: '',
        sexo: '',
        edad: '',
        direccionPostal: '',
        telefono: '',
        email: ''
      },
      idTrabajadorOperacion: '',
      numeroClienteOperacion: '',
      trabajadorEncontrado: false,
      clienteEncontrado: false,
      trabajadorModificar: {},
      clienteModificar: {},
      errors: {
        nombre: ''
      },
      trabajadoresIds: [],
      clientesIds: []
    }
  },
  mounted() {
    this.cargarIdsTrabajadores();
    this.cargarIdsClientes();
  },
  methods: {
    async cargarIdsTrabajadores() {
      try {
        const response = await axios.get('/getTrabajadoresIds');
        this.trabajadoresIds = response.data;
      } catch (error) {
        console.error('Error al cargar IDs de trabajadores:', error);
      }
    },
    async cargarIdsClientes() {
      try {
        const response = await axios.get('/getClientesIds');
        this.clientesIds = response.data;
      } catch (error) {
        console.error('Error al cargar IDs de clientes:', error);
      }
    },
    async validateName() {
      try {
        const response = await axios.post('/checkNombreExistente', { nombre: this.usuario.nombre });
        if (response.data.exists) {
          this.errors.nombre = 'Este nombre ya existe en la base de datos';
        } else {
          this.errors.nombre = '';
        }
      } catch (error) {
        console.error('Error al validar el nombre:', error);
      }
    },
    resetForm() {
      this.usuario = {
        tipo: this.usuario.tipo,
        nombre: '',
        password: '',
        rol: '',
        apellido: '',
        numeroIdentidad: '',
        sexo: '',
        edad: '',
        direccionPostal: '',
        telefono: '',
        email: ''
      };
      this.errors.nombre = '';
    },
    async crearUsuario() {
      try {
        if (this.usuario.tipo === 'trabajador') {
          await axios.post('/crearTrabajador', {
            nombre: this.usuario.nombre,
            password: this.usuario.password,
            rol: this.usuario.rol
          });
        } else {
          await axios.post('/crearCliente', this.usuario);
        }
        alert('Usuario creado con éxito');
        this.resetForm();
      } catch (error) {
        console.error('Error al crear usuario:', error);
        alert('Error al crear usuario');
      }
    },
    async buscarTrabajador() {
      try {
        const response = await axios.get(`/getTrabajador/${this.idTrabajadorOperacion}`);
        this.trabajadorModificar = response.data;
        this.trabajadorEncontrado = true;
      } catch (error) {
        console.error('Error al buscar trabajador:', error);
        alert('Trabajador no encontrado');
        this.trabajadorEncontrado = false;
      }
    },
    async modificarTrabajador() {
      try {
        await axios.put(`/actualizarTrabajador/${this.idTrabajadorOperacion}`, this.trabajadorModificar);
        alert('Trabajador modificado con éxito');
        this.trabajadorEncontrado = false;
        this.idTrabajadorOperacion = '';
      } catch (error) {
        console.error('Error al modificar trabajador:', error);
        alert('Error al modificar trabajador');
      }
    },
    async eliminarTrabajador() {
      if (confirm('¿Está seguro de que desea eliminar este trabajador?')) {
        try {
          await axios.delete(`/eliminarTrabajador/${this.idTrabajadorOperacion}`);
          alert('Trabajador eliminado con éxito');
          this.trabajadorEncontrado = false;
          this.idTrabajadorOperacion = '';
          this.cargarIdsTrabajadores();
        } catch (error) {
          console.error('Error al eliminar trabajador:', error);
          alert('Error al eliminar trabajador');
        }
      }
    },
    async buscarCliente() {
      try {
        const response = await axios.get(`/getCliente/${this.numeroClienteOperacion}`);
        this.clienteModificar = response.data;
        this.clienteEncontrado = true;
      } catch (error) {
        console.error('Error al buscar cliente:', error);
        alert('Cliente no encontrado');
        this.clienteEncontrado = false;
      }
    },
    async modificarCliente() {
      try {
        await axios.put(`/actualizarCliente/${this.numeroClienteOperacion}`, this.clienteModificar);
        alert('Cliente modificado con éxito');
        this.clienteEncontrado = false;
        this.numeroClienteOperacion = '';
      } catch (error) {
        console.error('Error al modificar cliente:', error);
        alert('Error al modificar cliente');
      }
    },
    async eliminarCliente() {
      if (confirm('¿Está seguro de que desea eliminar este cliente?')) {
        try {
          await axios.delete(`/eliminarCliente/${this.numeroClienteOperacion}`);
          alert('Cliente eliminado con éxito');
          this.clienteEncontrado = false;
          this.numeroClienteOperacion = '';
          this.cargarIdsClientes();
        } catch (error) {
          console.error('Error al eliminar cliente:', error);
          alert('Error al eliminar cliente');
        }
      }
    }
  }
}
</script>

<style scoped>
.formulario {
  background-color: white;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 0 5px rgba(0,0,0,0.1);
}

.campo {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input, select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.boton-submit, .boton-buscar, .boton-eliminar {
  padding: 10px 15px;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 4px;
  font-size: 14px;
}

.boton-submit {
  background-color: #4CAF50;
}

.boton-buscar {
  background-color: #008CBA;
}

.boton-eliminar {
  background-color: #f44336;
}

.error-message {
  color: red;
  font-size: 12px;
  margin-top: 5px;
}

.operaciones-cliente, .operaciones-trabajador {
  margin-top: 20px;
  border-top: 1px solid #ccc;
  padding-top: 20px;
}
</style>
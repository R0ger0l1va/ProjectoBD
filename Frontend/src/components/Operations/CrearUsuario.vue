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
        <input
          id="nombre"
          v-model="usuario.nombre_usuario"
          required
          @blur="validateField('nombre_usuario')"
        />
        <div class="error-container">
          <span v-if="errors.name" class="error-message">Campo vacío</span>
          <span v-if="minLengthErrors.name" class="error-message">Mínimo 3 caracteres</span>
          <span v-if="errors.nameExists" class="error-message">Nombre de usuario ya existe</span>
        </div>
      </div>
      <div class="campo">
        <label for="password">Contraseña:</label>
        <input
          id="password"
          v-model="usuario.contrasenna"
          type="password"
          required
          @blur="validateField('contrasenna')"
          @input="validateInput('password')"
        />
        <div class="error-container">
          <span v-if="errors.password" class="error-message">Campo vacío</span>
          <span v-if="minLengthErrors.password" class="error-message">Mínimo 3 caracteres</span>
        </div>
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
          <input id="apellido" v-model="usuario.apellido_cliente" />
        </div>
        <div class="campo">
          <label for="numeroIdentidad">Número de Identidad:</label>
          <input id="numeroIdentidad" v-model="usuario.numero_identidad_cliente" />
        </div>
        <div class="campo">
          <label for="sexo">Sexo:</label>
          <select id="sexo" v-model="usuario.id_sexo" required>
            <option v-for="sexCod in gender" :key="sexCod.id" :value="sexCod.id">
              {{ sexCod.nombre }}
            </option>
          </select>
        </div>
        <div class="campo">
          <label for="edad">Edad:</label>
          <input
            id="edad"
            v-model="usuario.edad"
            type="number"
            required
            @blur="validateField('edad')"
          />
          <div class="error-container">
            <span v-if="errors.age" class="error-message">Debe ser mayor de 18 años</span>
          </div>
        </div>
        <div class="campo">
          <label for="direccionPostal">Dirección Postal:</label>
          <input id="direccionPostal" v-model="usuario.direccion_postal" />
        </div>
        <div class="campo">
          <label for="telefono">Teléfono:</label>
          <input id="telefono" v-model="usuario.telefono" />
        </div>
        <div class="campo">
          <label for="email">Email:</label>
          <input
            id="email"
            v-model="usuario.correo_electronico"
            type="email"
            required
            @blur="validateField('correo_electronico')"
          />
          <div class="error-container">
            <span v-if="errors.email" class="error-message"
              >Campo requerido si no hay teléfono</span
            >
            <span v-if="errors.emailExists" class="error-message">Email ya existe</span>
          </div>
        </div>
      </div>

      <button type="submit" class="boton-submit" :disabled="!isFormValid">Crear Usuario</button>
    </form>

    <!-- Sección para modificar o eliminar trabajador -->
    <div v-if="usuario.tipo === 'trabajador'" class="operaciones-trabajador">
      <h3>Modificar o Eliminar Trabajador</h3>
      <div class="campo">
        <label for="idTrabajador">ID del Trabajador:</label>
        <select id="idTrabajador" v-model="idTrabajadorOperacion" @change="buscarTrabajador">
          <option v-for="id in trabajadoresIds" :key="id.id" :value="id.id">{{ id.id }}</option>
        </select>
      </div>

      <form v-if="trabajadorEncontrado" @submit.prevent="modificarTrabajador">
        <div class="campo">
          <label for="nombreModificarTrabajador">Nombre:</label>
          <input id="nombreModificarTrabajador" v-model="trabajadorModificar.nombre" required />
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

      <button v-if="trabajadorEncontrado" @click="eliminarTrabajador" class="boton-eliminar">
        Eliminar Trabajador
      </button>
    </div>

    <!-- Sección para modificar o eliminar cliente -->
    <div v-if="usuario.tipo === 'cliente'" class="operaciones-cliente">
      <h3>Modificar o Eliminar Cliente</h3>
      <div class="campo">
        <label for="numeroCliente">Número de Cliente:</label>
        <select id="numeroCliente" v-model="numeroClienteOperacion" @change="buscarCliente">
          <option v-for="id in clientesIds" :key="id.id" :value="id.id">{{ id.id }}</option>
        </select>
      </div>

      <form v-if="clienteEncontrado" @submit.prevent="modificarCliente">
        <div class="campo">
          <label for="nombreModificar">Nombre:</label>
          <input id="nombreModificar" v-model="clienteModificar.nombre_cliente" required />
        </div>
        <div class="campo">
          <label for="apellidoModificar">Apellido:</label>
          <input id="apellidoModificar" v-model="clienteModificar.apellido_cliente" />
        </div>
        <div class="campo">
          <label for="edadModificar">Edad:</label>
          <input id="edadModificar" v-model="clienteModificar.edad" type="number" required />
        </div>
        <div class="campo">
          <label for="direccionPostalModificar">Dirección Postal:</label>
          <input id="direccionPostalModificar" v-model="clienteModificar.direccion_postal" />
        </div>
        <div class="campo">
          <label for="telefonoModificar">Teléfono:</label>
          <input id="telefonoModificar" v-model="clienteModificar.telefono" />
        </div>

        <div class="campo">
          <label for="emailModificar">Email:</label>
          <input
            id="emailModificar"
            v-model="clienteModificar.correo_electronico"
            type="email"
            required
          />
        </div>
        <button type="submit" class="boton-submit">Modificar Cliente</button>
      </form>

      <button v-if="clienteEncontrado" @click="eliminarCliente" class="boton-eliminar">
        Eliminar Cliente
      </button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'CrearUsuario',
  data() {
    return {
      usuario: {
        tipo: 'trabajador',
        nombre_usuario: '',
        contrasenna: '',
        rol: '',
        apellido_cliente: '',
        numero_identidad_cliente: '',
        id_sexo: '',
        edad: '',
        direccion_postal: '',
        telefono: '',
        correo_electronico: '',
        nombre_cliente: ''
      },
      idTrabajadorOperacion: '',
      numeroClienteOperacion: '',
      trabajadorEncontrado: false,
      clienteEncontrado: false,
      trabajadorModificar: {},
      clienteModificar: {},
      clienteBackup: {},
      errors: {
        name: false,
        password: false,
        age: false,
        email: false,
        nameExists: false,
        emailExists: false
      },
      minLengthErrors: {
        name: false,
        password: false
      },
      trabajadoresIds: [],
      clientesIds: [],
      gender: [],
      formSubmitted: false
    }
  },
  computed: {
    isFormValid() {
      return (
        this.usuario.nombre_usuario &&
        this.usuario.contrasenna &&
        this.usuario.nombre_usuario.length >= 3 &&
        this.usuario.contrasenna.length >= 3 &&
        !this.errors.name &&
        !this.errors.password &&
        !this.errors.age &&
        !this.errors.email &&
        !this.errors.nameExists &&
        !this.errors.emailExists &&
        !this.formSubmitted
      )
    }
  },
  mounted() {
    this.cargarIdsTrabajadores()
    this.cargarIdsClientes()
    this.cargarGeneros()
  },
  methods: {
    async cargarIdsTrabajadores() {
      try {
        const response = await axios.get('/getAllUsers')
        this.trabajadoresIds = response.data
          .filter((trabajador) => trabajador.rol === 'AdminGen' || trabajador.rol === 'Vendedor')
          .map((trabajador) => ({
            id: trabajador.id_usuario,
            nombre: trabajador.nombre_usuario,
            rol: trabajador.rol
          }))
      } catch (error) {
        console.error('Error al cargar IDs de trabajadores:', error)
      }
    },
    async cargarIdsClientes() {
      try {
        const response = await axios.get('/getAllClientes')
        this.clientesIds = response.data.map((cliente) => ({
          id: cliente.numero_identidad_cliente,
          nombre: cliente.nombre_cliente
        }))
      } catch (error) {
        console.error('Error al cargar IDs de clientes:', error)
      }
    },
    async cargarGeneros() {
      try {
        const response = await axios.get('/getSex')
        this.gender = response.data.map((sexo) => ({
          id: sexo.id_sexo,
          nombre: sexo.nombre_sexo
        }))
      } catch (error) {
        console.error('Error al cargar géneros:', error)
      }
    },
    validateField(field) {
      if (field === 'nombre_usuario') {
        this.errors.name = this.usuario.nombre_usuario === ''
        this.validateUsername()
      } else if (field === 'contrasenna') {
        this.errors.password = this.usuario.contrasenna === ''
      } else if (field === 'edad') {
        this.errors.age = this.usuario.edad < 18
      } else if (field === 'correo_electronico') {
        this.errors.email = !this.usuario.correo_electronico
        this.validateEmail()
      }
    },
    validateInput(field) {
      const minLength = 3
      if (field === 'name' || field === 'password') {
        this.minLengthErrors[field] =
          this.usuario[field === 'name' ? 'nombre_usuario' : 'contrasenna'].length > 0 &&
          this.usuario[field === 'name' ? 'nombre_usuario' : 'contrasenna'].length < minLength
        this.errors[field] = false
      }
    },
    async validateUsername() {
      try {
        const response = await axios.post('/checkNombreExistente', {
          nombre: this.usuario.nombre_usuario
        })
        this.errors.nameExists = response.data.exists
      } catch (error) {
        console.error('Error al validar el nombre:', error)
      }
    },
    async validateEmail() {
      try {
        const response = await axios.post('/checkEmailExistente', {
          email: this.usuario.correo_electronico
        })
        this.errors.emailExists = response.data.exists
      } catch (error) {
        console.error('Error al validar el email:', error)
      }
    },
    resetForm() {
      this.usuario = {
        tipo: this.usuario.tipo,
        nombre_usuario: '',
        contrasenna: '',
        rol: '',
        apellido_cliente: '',
        numero_identidad_cliente: '',
        id_sexo: '',
        edad: '',
        direccion_postal: '',
        telefono: '',
        correo_electronico: ''
      }
      this.errors = {
        name: false,
        password: false,
        age: false,
        email: false,
        nameExists: false,
        emailExists: false
      }
      this.minLengthErrors = {
        name: false,
        password: false
      }
      this.formSubmitted = false
    },
    async crearUsuario() {
      this.formSubmitted = true
      try {
        if (this.usuario.tipo === 'trabajador') {
          await axios.post('/postTrabajador', {
            nombre_usuario: this.usuario.nombre_usuario,
            contrasenna: this.usuario.contrasenna,
            rol: this.usuario.rol
          })
        } else {
          await axios.post('/postCliente', this.usuario,postCliente)
        }
        this.showAlertMessage('Usuario creado con éxito', true)
        this.resetForm()
      } catch (error) {
        console.error('Error al crear usuario:', error)
        this.showAlertMessage('Error al crear usuario', false)
      } finally {
        this.formSubmitted = false
      }
    },
    async buscarTrabajador() {
      try {
        const response = await axios.get(`/getUser/${this.idTrabajadorOperacion}`)
        this.trabajadorModificar = response.data
        this.trabajadorBackup = this.trabajadorModificar
        console.log(this.trabajadorModificar)

        this.trabajadorEncontrado = true
      } catch (error) {
        console.error('Error al buscar trabajador:', error)
        this.showAlertMessage('Trabajador no encontrado', false)
        this.trabajadorEncontrado = false
      }
    },
    async modificarTrabajador() {
      try {
        await axios.put(`/putUsers/${this.idTrabajadorOperacion}`, this.trabajadorModificar)
        this.showAlertMessage('Trabajador modificado con éxito', true)
        this.trabajadorEncontrado = false
        this.idTrabajadorOperacion = ''
      } catch (error) {
        console.error('Error al modificar trabajador:', error)
        this.showAlertMessage('Error al modificar trabajador', false)
      }
    },
    async eliminarTrabajador() {
      if (confirm('¿Está seguro de que desea eliminar este trabajador?')) {
        try {
          await axios.delete(`/delUsers/${this.idTrabajadorOperacion}`)
          this.showAlertMessage('Trabajador eliminado con éxito', true)
          this.trabajadorEncontrado = false
          this.idTrabajadorOperacion = ''
          this.cargarIdsTrabajadores()
        } catch (error) {
          console.error('Error al eliminar trabajador:', error)
          this.showAlertMessage('Error al eliminar trabajador', false)
        }
      }
    },
    async buscarCliente() {
      const token = sessionStorage.getItem('token')
      try {
        console.log(this.numeroClienteOperacion)

        const response = await axios.get(`/getCliente/${this.numeroClienteOperacion}`,{
          headers:{
            Authorization:`Bearer ${token}`
          }
        })

        this.clienteModificar = response.data
        this.clienteBackup = response.data
        console.log(this.clienteModificar)

        this.clienteEncontrado = true
      } catch (error) {
        console.error('Error al buscar cliente:', error)
        this.showAlertMessage('Cliente no encontrado', false)
        this.clienteEncontrado = false
      }
    },
    async modificarCliente() {
      try {
        const res = await axios.put(
          `/updCliente/${this.numeroClienteOperacion}`,
          this.clienteModificar
        )
        console.log(res.data)

        this.showAlertMessage('Cliente modificado con éxito', true)
        this.clienteEncontrado = false
        this.numeroClienteOperacion = ''
      } catch (error) {
        console.error('Error al modificar cliente:', error)
        this.showAlertMessage('Error al modificar cliente', false)
      }
    },
    async eliminarCliente() {
      if (confirm('¿Está seguro de que desea eliminar este cliente?')) {
        try {
          await axios.delete(`/delCliente/${this.numeroClienteOperacion}`)
          await axios.delete(`/delUsers/${this.numeroClienteOperacion}`)
          this.showAlertMessage('Cliente eliminado con éxito', true)
          this.clienteEncontrado = false
          this.numeroClienteOperacion = ''
          this.cargarIdsClientes()
        } catch (error) {
          console.error('Error al eliminar cliente:', error)
          this.showAlertMessage('Error al eliminar cliente', false)
        }
      }
    },
    showAlertMessage(message, success) {
      // Implement this method to show alert messages
      // You can use a similar approach as in the LoginRegister component
      console.log(message, success)
    }
  }
}
</script>

<style scoped>
.formulario {
  background-color: white;
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

input,
select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.boton-submit,
.boton-buscar,
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

.boton-buscar {
  background-color: #008cba;
}

.boton-eliminar {
  background-color: #f44336;
}

.error-message {
  color: red;
  font-size: 12px;
  margin-top: 5px;
}

.operaciones-cliente,
.operaciones-trabajador {
  margin-top: 20px;
  border-top: 1px solid #ccc;
  padding-top: 20px;
}
</style>

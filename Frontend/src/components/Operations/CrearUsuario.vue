<template>
  <div class="formulario">
    <h2>Crear Trabajador/Cliente</h2>
    <form @submit.prevent="crearUsuario">
      <div class="campo">
        <label for="tipoUsuario">Tipo de Usuario:</label>
        <select id="tipoUsuario" v-model="usuario.tipo" required>
          <option value="trabajador">Trabajador</option>
          <option value="cliente">Cliente</option>
        </select>
      </div>
      <div class="campo">
        <label for="nombre">Nombre:</label>
        <input id="nombre" v-model="usuario.nombre" required>
      </div>
      <div class="campo">
        <label for="apellido">Apellido:</label>
        <input id="apellido" v-model="usuario.apellido" required>
      </div>
      <div class="campo">
        <label for="email">Email:</label>
        <input id="email" v-model="usuario.email" type="email" required>
      </div>
      <div class="campo">
        <label for="password">Contraseña:</label>
        <input id="password" v-model="usuario.password" type="password" required>
      </div>
      <div v-if="usuario.tipo === 'trabajador'" class="campo">
        <label for="cargo">Cargo:</label>
        <input id="cargo" v-model="usuario.cargo">
      </div>
      <div v-if="usuario.tipo === 'cliente'" class="campo">
        <label for="numeroPoliza">Número de Póliza:</label>
        <input id="numeroPoliza" v-model="usuario.numeroPoliza">
      </div>
      <button type="submit" class="boton-submit">Crear Usuario</button>
    </form>
  </div>
</template>

<script>
export default {
  name: 'CrearUsuario',
  data() {
    return {
      usuario: {
        tipo: 'trabajador',
        nombre: '',
        apellido: '',
        email: '',
        password: '',
        cargo: '',
        numeroPoliza: ''
      }
    }
  },
  methods: {
    crearUsuario() {
      console.log('Usuario creado:', this.usuario);
      alert('Usuario creado con éxito');
      this.usuario = {
        tipo: 'trabajador',
        nombre: '',
        apellido: '',
        email: '',
        password: '',
        cargo: '',
        numeroPoliza: ''
      };
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

.boton-submit {
  padding: 10px 15px;
  background-color: #4CAF50;
  color: white;
  border: none;
  cursor: pointer;
  border-radius: 4px;
  font-size: 14px;
}
</style>
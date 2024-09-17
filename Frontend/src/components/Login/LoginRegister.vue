<template>
  <div class="auth-container">
    <div class="form-container" :class="{ 'right-panel-active': isLoginActive }">
      <div class="form-panel sign-up">
        <h2>Crear Cuenta</h2>
        <form @submit.prevent="signUp" ref="signup">
          <div class="input-group">
            <div class="input-wrapper">
              <input
                v-model="registerForm.nombre_usuario"
                type="text"
                placeholder="Nombre"
                required
                :class="{ error: errors.name }"
                @blur="validateField('nombre_usuario')"
                @input="validateInput('name')"
              />
              <div class="error-container">
                <span v-if="errors.name" class="error-message">Campo vacío</span>
                <span v-if="minLengthErrors.name" class="error-message">Mínimo 3 caracteres</span>
              </div>
            </div>
            <div class="input-wrapper">
              <input
                v-model="registerForm.apellido_cliente"
                type="text"
                placeholder="Apellido (Opcional)"
                @blur="validateField('apellido_cliente')"
              />
            </div>
          </div>
          <div class="input-group">
            <div class="input-wrapper">
              <input
                v-model="registerForm.id_usuario"
                type="number"
                placeholder="ID"
                required
                :class="{ error: errors.id }"
                @blur="validateField('id_usuario')"
              />
              <div class="error-container">
                <span v-if="errors.id" class="error-message">Campo vacío</span>
              </div>
            </div>
            <div class="input-wrapper">
              <select
                v-model="registerForm.id_pais"
                required
                :class="{ error: errors.country }"
                @blur="validateField('id_pais')"
              >
                <option value="" disabled selected>Seleccione un país</option>
                <option v-for="countryCod in countries" :key="countryCod.id" :value="countryCod.id">
                  {{ countryCod.nombre}}
                </option>
              </select>
              <div class="error-container">
                <span v-if="errors.country" class="error-message">Seleccione un país</span>
              </div>
            </div>
          </div>
          <div class="input-group">
            <div class="input-wrapper">
              <select
                v-model="registerForm.id_sexo"
                :class="{ error: errors.sex }"
                @blur="validateField('id_sexo')"
              >
                <option value="" disabled selected>Seleccione sexo</option>
                <option v-for="sexCod in gender" :key="sexCod.id" :value="sexCod.id">
                  {{ sexCod.nombre}}
                </option>
              </select>
            </div>
            <div class="input-wrapper">
              <input
                v-model="registerForm.edad"
                type="number"
                placeholder="Edad"
                required
                min="18"
                :class="{ error: errors.age }"
                @blur="validateField('edad')"
              />
              <div class="error-container">
                <span v-if="errors.age" class="error-message">Debe ser mayor de 18 años</span>
              </div>
            </div>
          </div>
          <div class="input-wrapper">
            <input
              v-model="registerForm.direccion_postal"
              type="text"
              placeholder="Dirección Postal (Opcional)"
            />
          </div>
          <div class="input-group">
            <div class="input-wrapper">
              <input
                v-model="registerForm.telefono"
                type="tel"
                placeholder="Teléfono (Opcional)"
                @blur="validateField('telefono')"
              />
            </div>
            <div class="input-wrapper">
              <input
                v-model="registerForm.correo_electronico"
                type="email"
                placeholder="Correo Electrónico"
                :required="!registerForm.telefono"
                :class="{ error: errors.email }"
                @blur="validateField('correo_electronico')"
              />
              <div class="error-container">
                <span v-if="errors.email" class="error-message"
                  >Campo requerido si no hay teléfono</span
                >
              </div>
            </div>
          </div>
          <div class="input-wrapper">
            <input
              v-model="registerForm.contrasenna"
              type="password"
              placeholder="Contraseña"
              required
              :class="{ error: errors.password }"
              @blur="validateField('contrasenna')"
              @input="validateInput('password')"
            />
            <div class="error-container">
              <span v-if="errors.password" class="error-message">Campo vacío</span>
              <span v-if="minLengthErrors.password" class="error-message">Mínimo 3 caracteres</span>
            </div>
          </div>
          <div class="input-wrapper">
            <input
              v-model="registerForm.carnet_identidad"
              :type="showCarnet ? 'text' : 'password'"
              placeholder="Carnet de Identidad (Opcional)"
            />
            <button type="button" @click="toggleCarnetVisibility" class="toggle-visibility">
              {{ showCarnet ? 'Ocultar' : 'Mostrar' }}
            </button>
          </div>
          <button type="submit" :disabled="!isRegisterFormValid">Registrarse</button>
        </form>
      </div>
      <div class="form-panel sign-in">
        <h2>Iniciar Sesión</h2>
        <form @submit.prevent="signIn">
          <div class="input-group">
            <div class="input-wrapper">
              <input
                v-model="loginForm.id_usuario"
                type="number"
                placeholder="ID"
                required
                :class="{ error: errors.loginId }"
                @blur="validateField('loginId')"
              />
              <div class="error-container">
                <span v-if="errors.loginId" class="error-message">Campo vacío</span>
              </div>
            </div>
            <div class="input-wrapper">
              <input
                v-model="loginForm.contrasenna"
                type="password"
                placeholder="Contraseña"
                required
                :class="{ error: errors.loginPassword }"
                @blur="validateField('loginPassword')"
                @input="validateInput('loginPassword')"
              />
              <div class="error-container">
                <span v-if="errors.loginPassword" class="error-message">Campo vacío</span>
                <span v-if="minLengthErrors.loginPassword" class="error-message"
                  >Mínimo 3 caracteres</span
                >
              </div>
            </div>
          </div>
          <a href="#" class="forgot-password">¿Olvidaste tu contraseña?</a>
          <button type="submit" :disabled="!isLoginFormValid">Iniciar Sesión</button>
        </form>
      </div>
      <div class="overlay-container">
        <div class="overlay">
          <div class="overlay-panel overlay-left">
            <h2>¡Bienvenido de vuelta!</h2>
            <p>Para mantenerte conectado, por favor inicia sesión con tu información personal</p>
            <button class="ghost" @click="toggleForm">Iniciar Sesión</button>
          </div>
          <div class="overlay-panel overlay-right">
            <h2>¡Hola, amigo!</h2>
            <p>Ingresa tus datos personales y comienza tu viaje con nosotros</p>
            <button class="ghost" @click="toggleForm">Registrarse</button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="showAlert" :class="['alert', { success: isSuccess, error: !isSuccess }]">
      {{ alertMessage }}
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {
  name: 'LoginRegister',
  data() {
    return {
      isLoginActive: true,
      showCarnet: false,
      gender: [],
      countries: [
        
      ],
      loginForm: {
        id_usuario: '',
        contrasenna: '',
        rol: ''
      },
      registerForm: {
        id_usuario: '',
        nombre_usuario: '',
        apellido_cliente: '',
        numero_id_cliente: '',
        nombre_cliente: '',
        contrasenna: '',
        rol: '',
        id_pais: '',
        id_sexo: '',
        edad: '',
        direccion_postal: '',
        telefono: '',
        correo_electronico: '',
        carnet_identidad: ''
      },
      errors: {
        name: false,
        id: false,
        password: false,
        loginId: false,
        loginPassword: false,
        country: false,
        age: false,
        email: false
      },
      minLengthErrors: {
        name: false,
        password: false,
        loginPassword: false
      },
      alert: {
        show: false,
        success: false,
        message: ''
      },
      lastFocusedField: ''
    }

  },

  
  computed: {
    isLoginFormValid() {
      return (
        this.loginForm.id_usuario &&
        this.loginForm.contrasenna &&
        this.loginForm.contrasenna.length >= 3 &&
        !this.errors.loginId &&
        !this.errors.loginPassword
      )
    },
    isRegisterFormValid() {
      return (
        this.registerForm.nombre_usuario &&
        this.registerForm.id_usuario &&
        this.registerForm.contrasenna &&
        this.registerForm.id_pais &&
        this.registerForm.edad >= 18 &&
        (this.registerForm.telefono || this.registerForm.correo_electronico) &&
        this.registerForm.nombre_usuario.length >= 3 &&
        this.registerForm.contrasenna.length >= 3 &&
        !this.errors.name &&
        !this.errors.id &&
        !this.errors.password &&
        !this.errors.country &&
        !this.errors.age &&
        !this.errors.email
      )
    }
  },
  methods: {
    async fetchData() {
      try {
        const sex = await axios.get('/getSex')
        const pais = await axios.get('/getPais')
        this.countries = pais.data.map((pais) => ({
          id: pais.id_pais,
          nombre: pais.nombre_pais
        }))
        this.gender = sex.data.map((sexo) => ({
          id: sexo.id_sexo,
          nombre: sexo.nombre_sexo
        }))
        
        console.log(this.gender);
        console.log(this.countries);
        
        
      } catch (error) {
        console.log(error.message.response);
        
      }
    },
    

    async signUp() {
      try {
        this.registerForm.nombre_cliente = this.registerForm.nombre_usuario,
        this.registerForm.numero_id_cliente = this.registerForm.id_usuario
        console.log(this.registerForm)
        const rest = await axios.post('/postCliente', this.registerForm)
        const res = await axios.post('/signUp', this.registerForm)
        this.reset()
        console.log(res)
        console.log(rest)
        this.showAlertMessage(res.data.message, true)
      } catch (error) {
        alert('Id de usuario ya existe')
      }
    },


    async signIn() {
      try {
        console.log(this.loginForm)
        const res = await axios.post('/signIn', this.loginForm)
        this.reset()
        console.log(res)
        this.showAlertMessage(res.data.message, true)
          sessionStorage.setItem('session', JSON.stringify(res.data.Usuario))

        await this.redirectUser(res.data.Usuario.rol) // Obtener el rol del usuario
      } catch (error) {
        console.error('Error en el cliente:', error) // Agrega esto para depurar
        if (error.response) {
          console.log('Error response:', error.response) // Agrega esto para depurar
          switch (error.response.status) {
            case 401:
              alert('Contraseña incorrecta')
              this.showAlertMessage('Contraseña incorrecta', false)
              break
            case 404:
              alert('Usuario no encontrado')
              this.showAlertMessage('Usuario no encontrado', false)
              break
            case 400:
              this.showAlertMessage('Rol desconocido', false)
              break
            default:
              this.showAlertMessage('Error desconocido', false)
              break
          }
        } else {
          this.showAlertMessage('Error de red o servidor no disponible', false)
        }
      }
    },

    redirectUser(role) {
      if (role === 'Cliente') {
        this.$router.push({ name: 'client-policy-dashboard' }) // Redirigir al componente de administrador
      } else if (role === 'Vendedor') {
        this.$router.push({ name: 'gestor-polizas-worker' }) // Redirigir al componente de usuario
      } else if (role === 'AdminGen') {
        this.$router.push({ name: 'gestor-polizas' }) // Redirigir a la página de inicio por defecto
      }
    },

    reset() {
      this.registerForm = {
        nombre_usuario: '',
        id_usuario: '',
        contrasenna: ''
      }
      this.loginForm = {
        id_usuario: '',
        contrasenna: ''
      }
    },

    validateField(field) {
      this.lastFocusedField = field
      if (field === 'nombre_usuario' || field === 'id_usuario' || field === 'contrasenna') {
        this.errors[field] = this.registerForm[field] === ''
      } else if (field === 'loginId' || field === 'loginPassword') {
        this.errors[field] = this.loginForm[field.replace('login', 'id_')] === ''
      } else if (field === 'id_pais') {
        this.errors.country = this.registerForm.id_pais === ''
      } else if (field === 'edad') {
        this.errors.age = this.registerForm.edad < 18
      } else if (field === 'correo_electronico') {
        this.errors.email = !this.registerForm.telefono && !this.registerForm.correo_electronico
      }
      this.showPreviousFieldError()
    },

    toggleCarnetVisibility() {
      this.showCarnet = !this.showCarnet
    },
    validateInput(field) {
      const minLength = 3
      if (field === 'name' || field === 'password') {
        this.minLengthErrors[field] =
          this.registerForm[field === 'name' ? 'nombre_usuario' : 'contrasenna'].length > 0 &&
          this.registerForm[field === 'name' ? 'nombre_usuario' : 'contrasenna'].length < minLength
        this.errors[field] = false
      } else if (field === 'loginPassword') {
        this.minLengthErrors[field] =
          this.loginForm.contrasenna.length > 0 && this.loginForm.contrasenna.length < minLength
        this.errors[field] = false
      }
    },
    toggleForm() {
      this.isLoginActive = !this.isLoginActive
    },
    showAlertMessage(message, success) {
      this.alertMessage = message
      this.isSuccess = success
      this.showAlert = true
      setTimeout(() => {
        this.showAlert = false
      }, 5000)
    },
    showPreviousFieldError() {
      const fields = ['nombre_usuario', 'id_usuario', 'contrasenna', 'loginId', 'loginPassword']
      const currentIndex = fields.indexOf(this.lastFocusedField)
      if (currentIndex > 0) {
        const previousField = fields[currentIndex - 1]
        if (previousField.startsWith('login')) {
          this.errors[previousField] = this.loginForm[previousField.replace('login', 'id_')] === ''
          if (previousField === 'loginPassword') {
            this.minLengthErrors[previousField] =
              this.loginForm.contrasenna.length > 0 && this.loginForm.contrasenna.length < 3
          }
        } else {
          this.errors[previousField] = this.registerForm[previousField] === ''
          if (previousField === 'nombre_usuario' || previousField === 'contrasenna') {
            this.minLengthErrors[previousField === 'nombre_usuario' ? 'name' : 'password'] =
              this.registerForm[previousField].length > 0 &&
              this.registerForm[previousField].length < 3
          }
        }
      }
    }
  },
    mounted() {
    this.fetchData()
  }
}
</script>

<style scoped>
.auth-container {
  background: #f6f5f7;
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  font-family: 'Montserrat', sans-serif;
  height: 100vh;
  margin: -20px 0 50px;
}

.form-container {
  background-color: #fff;
  border-radius: 10px;
  box-shadow:
    0 14px 28px rgba(0, 0, 0, 0.25),
    0 10px 10px rgba(0, 0, 0, 0.22);
  position: relative;
  overflow: hidden;
  width: 968px;
  max-width: 100%;
  min-height: 510px;
}

.form-panel {
  position: absolute;
  top: 3px;
  height: 90%;
  transition: all 0.6s ease-in-out;
}

.sign-up {
  left: 0;
  width: 50%;
  opacity: 0;
  z-index: 1;
}

.sign-in {
  left: 0;
  width: 50%;
  z-index: 2;
}

.form-container.right-panel-active .sign-in {
  transform: translateX(100%);
  z-index: -1;
}

.form-container.right-panel-active .sign-up {
  transform: translateX(100%);
  opacity: 1;
  z-index: 5;
  animation: show 0.6s;
}

@keyframes show {
  0%,
  49.99% {
    opacity: 0;
    z-index: 1;
  }

  50%,
  100% {
    opacity: 1;
    z-index: 5;
  }
}

.overlay-container {
  position: absolute;
  top: 0;
  left: 50%;
  width: 50%;
  height: 100%;
  overflow: hidden;
  transition: transform 0.6s ease-in-out;
  z-index: 100;
}

.form-container.right-panel-active .overlay-container {
  transform: translateX(-100%);
}

.overlay {
  background: #ff416c;
  background: -webkit-linear-gradient(to right, #ff4b2b, #ff416c);
  background: linear-gradient(to right, #046c54, #046c54, green);
  background-repeat: no-repeat;
  background-size: cover;
  background-position: 0 0;
  color: #ffffffff;
  position: relative;
  left: -100%;
  height: 100%;
  width: 200%;
  transform: translateX(0);
  transition: transform 0.6s ease-in-out;
}

.overlay p {
  padding-left: 20px;
  padding-right: 20px;
}

.form-container.right-panel-active .overlay {
  transform: translateX(50%);
}

.overlay-panel {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  padding: 0 40px;
  text-align: center;
  top: 0;
  height: 100%;
  width: 50%;
  transform: translateX(0);
  transition: transform 0.6s ease-in-out;
}

.overlay-left {
  transform: translateX(-20%);
  left: -40px;
}

.form-container.right-panel-active .overlay-left {
  transform: translateX(0);
}

.overlay-right {
  right: -40px;
  transform: translateX(0);
}

.form-container.right-panel-active .overlay-right {
  transform: translateX(20%);
}

.form-panel form {
  background-color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  padding: 0 50px;
  height: 90%;
  text-align: center;
}

.form-panel input {
  background-color: #eee;
  border-radius: 20px;
  border: none;
  padding: 12px 15px;
  margin: 8px 0;
  width: 100%;
}

button {
  border-radius: 20px;
  margin-top: 12px;
  border: 1px solid #ff4b2b;
  background-color: #ff4b2b;
  color: #ffffff;
  font-size: 12px;
  font-weight: bold;
  padding: 12px 45px;
  letter-spacing: 1px;
  text-transform: uppercase;
  transition: transform 80ms ease-in;
}

button:active {
  transform: scale(0.95);
}

button.ghost {
  background-color: transparent;
  border-color: #ffffff;
}

.form-panel h2 {
  text-align: center;
  margin-bottom: 20px;
}

.forgot-password {
  color: #333;
  font-size: 14px;
  text-decoration: none;
  margin: 15px 0;
}

@media screen and (max-width: 768px) {
  .form-container {
    min-height: 650px;
  }

  .form-panel {
    width: 100%;
  }

  .sign-up,
  .sign-in {
    width: 100%;
  }

  .overlay-container {
    display: none;
  }

  .form-container.right-panel-active .sign-in {
    transform: translateX(-100%);
  }

  .form-container.right-panel-active .sign-up {
    transform: translateX(0);
  }
}

.input-group {
  display: flex;
  justify-content: space-between;
  width: 100%;
}

.input-group input {
  width: 70%;
}

.radio-group {
  display: flex;
  justify-content: space-between;
  width: 100%;
  margin: 10px 0;
}

.radio-group label {
  display: flex;
  align-items: center;
}

input[type='radio'] {
  margin-right: 5px;
}

.error {
  border: 2px solid red !important;
}

.error-message {
  color: red;
  font-size: 12px;
  display: block;
  text-align: center;
  margin-top: 2px;
}

.alert {
  position: fixed;
  top: 10px;
  right: 25rem;
  padding: 15px;
  border-radius: 5px;
  color: white;
  font-weight: bold;
  z-index: 1000;
  transition: opacity 0.3s ease;
}

.alert.success {
  background-color: #4caf50;
}

.alert.error {
  background-color: #f44336;
}

button:disabled {
  background-color: #cccccc;
  color: #666666;
  cursor: not-allowed;
}

.error-message {
  color: red;
  font-size: 10px;
  display: block;
  text-align: left;
  margin-top: 2px;
}

.toggle-visibility {
  position: absolute;
  right: 10px;
  top: 97%;
  right: -2%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  font-size: 12px;
  color: #333;
}

select {
  background-color: #eee;
  border-radius: 20px;
  border: none;
  padding: 12px 15px;
  margin: 8px 0;
  width: 100%;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  background-repeat: no-repeat;
  background-position: right 10px top 50%;
  background-size: 12px auto;
}
</style>

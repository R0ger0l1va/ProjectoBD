<template>
  <div class="auth-container">
    <div class="form-container" :class="{ 'right-panel-active': isLoginActive }">
      <div class="form-panel sign-up">
        <h2>Crear Cuenta</h2>
        <form @submit.prevent="signUp" ref="singup">
          <div class="input-group">
            <div class="input-wrapper">
              <input v-model="registerForm.nombre_usuario" type="text" placeholder="Nombre" required
                :class="{ 'error': errors.name }" @blur="validateField('nombre_usuario')" @input="validateInput('name')" />
              <div class="error-container">
                <span v-if="errors.name" class="error-message">Campo vacío</span>
                <span v-if="minLengthErrors.name" class="error-message">Mínimo 3 caracteres</span>
              </div>
            </div>
            <div class="input-wrapper">
              <input v-model="registerForm.id_usuario" type="number" placeholder="ID" required :class="{ 'error': errors.id }"
                @blur="validateField('id_usuario')" />
              <div class="error-container">
                <span v-if="errors.id" class="error-message">Campo vacío</span>
              </div>
            </div>
          </div>
          <div class="input-wrapper">
            <input v-model="registerForm.contrasenna" type="password" placeholder="Contraseña" required
              :class="{ 'error': errors.password }" @blur="validateField('contrasenna')"
              @input="validateInput('password')" />
            <div class="error-container">
              <span v-if="errors.password" class="error-message">Campo vacío</span>
              <span v-if="minLengthErrors.password" class="error-message">Mínimo 3 caracteres</span>
            </div>
          </div>
          <div class="radio-group">
            <label>
              <input type="radio" v-model="registerForm.rol" value="Cliente" required>
              Cliente
            </label>
            <label>
              <input type="radio" v-model="registerForm.rol" value="Admin" required>
              Admin
            </label>
            <label>
              <input type="radio" v-model="registerForm.rol" value="AdminGen" required>
              AdminGen
            </label>
          </div>
          <button type="submit">Registrarse</button>
        </form>
      </div>
      <div class="form-panel sign-in">
        <h2>Iniciar Sesión</h2>
        <form @submit.prevent="signIn">
          <div class="input-group">
            <div class="input-wrapper">
              <input v-model="loginForm.id_usuario" type="number" placeholder="ID" required :class="{ 'error': errors.loginId }"
                @blur="validateField('loginId')" />
              <div class="error-container">
                <span v-if="errors.loginId" class="error-message">Campo vacío</span>
              </div>
            </div>
            <div class="input-wrapper">
              <input v-model="loginForm.contrasenna" type="password" placeholder="Contraseña" required
                :class="{ 'error': errors.loginPassword }" @blur="validateField('contrasenna')"
                @input="validateInput('LoginPassword')" />
              <div class="error-container">
                <span v-if="errors.loginPassword" class="error-message">Campo vacío</span>
                <span v-if="minLengthErrors.loginPassword" class="error-message">Mínimo 3 caracteres</span>
              </div>
            </div>
          </div>
          <div class="radio-group">
            <label>
              <input type="radio" v-model="loginForm.rol" value="Cliente" required>
              Cliente
            </label>
            <label>
              <input type="radio" v-model="loginForm.rol" value="Admin" required>
              Admin
            </label>
            <label>
              <input type="radio" v-model="loginForm.rol" value="AdminGen" required>
              AdminGen
            </label>
          </div>
          <a href="#" class="forgot-password">¿Olvidaste tu contraseña?</a>
          <button type="submit">Iniciar Sesión</button>
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
    <div v-if="showAlert" :class="['alert', { 'success': isSuccess, 'error': !isSuccess }]">
      {{ alertMessage }}
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'LoginRegister',
  data() {
    return {
      isLoginActive: true,
      loginForm: {
        id_usuario: '',
        contrasenna: '',
        rol: ''
      },
      registerForm: {
        id_usuario: '',
        nombre_usuario: '',
        contrasenna: '',
        rol: ''
      },
      errors: {
        name: false,
        id: false,
        password: false,
        loginId: false,
        loginPassword: false
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
      }     
    }
  },
  methods: {
    async signUp() { 
      
      
      try {
          console.log(this.registerForm)
          const res = await axios.post('/signUp',this.registerForm)
          this.reset()
          console.log(res)
          this.showAlertMessage(res.data.message, true)

      } catch (error) {
          
          this.showAlertMessage(error.response.data.message,false)
        }
    
    },

    async signIn() {
      try{
      console.log(this.registerForm)
      const res = await axios.post('/signIn', this.loginForm)
      this.reset()
      console.log(res)
      this.showAlertMessage(res.data.message, true)

    } catch(error) {

      this.showAlertMessage(error.response.data.message, false)
    }

    },

    reset() {
      this.registerForm = {
        nombre: '',
        email: '',
        contrasena: '',
        userType: ''
      };
    },

   
    validateField(field) {
      if (field === 'name' || field === 'id' || field === 'password') {
        this.errors[field] = this.registerForm[field] === ''
      } else if (field === 'loginId' || field === 'loginPassword') {
        this.errors[field] = this.loginForm[field.replace('login', '').toLowerCase()] === ''
      }
    },
    validateInput(field) {
      const minLength = 3
      if (field === 'name' || field === 'password') {
        this.minLengthErrors[field] = this.registerForm[field].length > 0 && this.registerForm[field].length < minLength
        this.errors[field] = false
      } else if (field === 'loginPassword') {
        this.minLengthErrors[field] = this.loginForm.password.length > 0 && this.loginForm.password.length < minLength
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
      }, 3000)
    },
    
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
  box-shadow: 0 14px 28px rgba(0, 0, 0, 0.25), 0 10px 10px rgba(0, 0, 0, 0.22);
  position: relative;
  overflow: hidden;
  width: 768px;
  max-width: 100%;
  min-height: 480px;
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
  background: #FF416C;
  background: -webkit-linear-gradient(to right, #FF4B2B, #FF416C);
  background: linear-gradient(to right, #046c54, #046c54, green);
  background-repeat: no-repeat;
  background-size: cover;
  background-position: 0 0;
  color: #FFFFFFFF;
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
  background-color: #FFFFFF;
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
  border: 1px solid #FF4B2B;
  background-color: #FF4B2B;
  color: #FFFFFF;
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
  border-color: #FFFFFF;
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
  width: 48%;
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

input[type="radio"] {
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
  background-color: #4CAF50;
}

.alert.error {
  background-color: #f44336;
}
</style>
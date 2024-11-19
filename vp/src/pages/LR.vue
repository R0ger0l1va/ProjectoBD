<template>
  <v-container fluid
               fill-height>
    <v-row align = "center"
           justify = "center">
      <v-col cols = "12"
             sm = "8"
             md = "6"
             lg = "8">
        <v-card class = "elevation-12">
          <v-window v-model = "step">
            <v-window-item :value = "1">
              <v-row>
                <v-col cols = "12"
                       md = "8">
                  <v-card-text>
                    <h1 class = "text-center display-1 mb-5">Crear Cuenta</h1>
                    <v-form @submit.prevent = "signUp"
                            ref = "signupForm">
                      <v-row>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.nombre_usuario"
                            label = "Nombre"
                            :rules = "[v => !!v || 'Campo requerido', v => v.length >= 3 || 'Mínimo 3 caracteres']"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.apellido_cliente"
                            label = "Apellido (Opcional)"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols = "12"
                               md = "6">
                          <v-select
                            v-model = "registerForm.id_pais"
                            :items = "countries"
                            item-text = "nombre"
                            item-value = "id"
                            label = "País"
                            :rules = "[v => !!v || 'Seleccione un país']"
                            required
                          ></v-select>
                        </v-col>
                        <v-col cols = "12"
                               md = "6">
                          <v-select
                            v-model = "registerForm.id_sexo"
                            :items = "gender"
                            item-text = "nombre"
                            item-value = "id"
                            label = "Sexo"
                          ></v-select>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.edad"
                            label = "Edad"
                            type = "number"
                            :rules = "[v => v >= 18 || 'Debe ser mayor de 18 años']"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.direccion_postal"
                            label = "Dirección Postal (Opcional)"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.telefono"
                            label = "Teléfono (Opcional)"
                          ></v-text-field>
                        </v-col>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.correo_electronico"
                            label = "Correo Electrónico"
                            :rules = "[v => !!v || !registerForm.telefono || 'Campo requerido si no hay teléfono']"
                            type = "email"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.contrasenna"
                            label = "Contraseña"
                            :type = "showPassword ? 'text' : 'password'"
                            :append-icon = "showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                            @click:append = "showPassword = !showPassword"
                            :rules = "[v => !!v || 'Campo requerido', v => v.length >= 3 || 'Mínimo 3 caracteres']"
                            required
                          ></v-text-field>
                        </v-col>
                        <v-col cols = "12"
                               md = "6">
                          <v-text-field
                            v-model = "registerForm.carnet_identidad"
                            label = "Carnet de Identidad (Opcional)"
                            :type = "showCarnet ? 'text' : 'password'"
                            :append-icon = "showCarnet ? 'mdi-eye' : 'mdi-eye-off'"
                            @click:append = "showCarnet = !showCarnet"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-btn
                        color = "primary"
                        class = "mt-4"
                        block
                        type = "submit"
                        :disabled = "!isRegisterFormValid"
                      >
                        Registrarse
                      </v-btn>
                    </v-form>
                  </v-card-text>
                </v-col>
                <v-col cols = "12"
                       md = "4"
                       class = "bg-primary">
                  <v-card-text class = "white--text text-center d-flex flex-column justify-center align-center h-100">
                    <h2 class = "display-1 mb-4">¡Bienvenido!</h2>
                    <p>¿Ya tienes una cuenta?</p>
                    <v-btn outlined
                           dark
                           @click = "step++">Iniciar Sesión
                    </v-btn>
                  </v-card-text>
                </v-col>
              </v-row>
            </v-window-item>

            <v-window-item :value = "2">
              <v-row>
                <v-col cols = "12"
                       md = "4"
                       class = "bg-primary">
                  <v-card-text class = "white--text text-center d-flex flex-column justify-center align-center h-100">
                    <h2 class = "display-1 mb-4">¡Hola, amigo!</h2>
                    <p>¿No tienes una cuenta?</p>
                    <v-btn outlined
                           dark
                           @click = "step--">Registrarse
                    </v-btn>
                  </v-card-text>
                </v-col>
                <v-col cols = "12"
                       md = "8">
                  <v-card-text>
                    <h1 class = "text-center display-1 mb-5">Iniciar Sesión</h1>
                    <v-form @submit.prevent = "signIn"
                            ref = "signinForm">
                      <v-text-field
                        v-model = "loginForm.nombre_usuario"
                        label = "Nombre de Usuario"
                        :rules = "[v => !!v || 'Campo requerido']"
                        required
                      ></v-text-field>
                      <v-text-field
                        v-model = "loginForm.contrasenna"
                        label = "Contraseña"
                        :type = "showLoginPassword ? 'text' : 'password'"
                        :append-icon = "showLoginPassword ? 'mdi-eye' : 'mdi-eye-off'"
                        @click:append = "showLoginPassword = !showLoginPassword"
                        :rules = "[v => !!v || 'Campo requerido', v => v.length >= 3 || 'Mínimo 3 caracteres']"
                        required
                      ></v-text-field>
                      <v-btn text
                             color = "primary"
                             class = "mb-4">¿Olvidaste tu contraseña?
                      </v-btn>
                      <v-btn
                        color = "primary"
                        class = "mt-4"
                        block
                        type = "submit"

                      >
                        Iniciar Sesión
                      </v-btn>
                    </v-form>
                  </v-card-text>
                </v-col>
              </v-row>
            </v-window-item>
          </v-window>
        </v-card>
      </v-col>
    </v-row>
    <v-snackbar v-model = "showAlert"
                :color = "isSuccess ? 'success' : 'error'"
                :timeout = "3000">
      {{ alertMessage }}
      <template v-slot:action = "{ attrs }">
        <v-btn text
               v-bind = "attrs"
               @click = "showAlert = false">
          Cerrar
        </v-btn>
      </template>
    </v-snackbar>
  </v-container>
</template>

<script>
import NavBar from "@/App.vue";
import axios from "axios";

export default {
  components: {NavBar},
  data: () => ({

    step: 2,
    role: String,
    isLoggedIn: false,
    showPassword: false,
    showLoginPassword: false,
    showCarnet: false,
    showAlert: false,
    isSuccess: false,
    alertMessage: '',


    registerForm: {
      nombre_usuario: '',
      apellido_cliente: '',
      id_pais: null,
      id_sexo: null,
      edad: null,
      direccion_postal: '',
      telefono: '',
      correo_electronico: '',
      contrasenna: '',
      carnet_identidad: '',
    },

    loginForm: {
      nombre_usuario: '',
      contrasenna: '',
    },
    countries: [
      {id: 1, nombre: 'España'},
      {id: 2, nombre: 'México'},
      // Add more countries as needed
    ],
    gender: [
      {id: 1, nombre: 'Masculino'},
      {id: 2, nombre: 'Femenino'},
      {id: 3, nombre: 'Otro'},
    ],
  }),
  computed: {
    isRegisterFormValid() {
      return this.$refs.signupForm && this.$refs.signupForm.validate()
    },
    isLoginFormValid() {
      return this.$refs.signinForm && this.$refs.signinForm.validate()
    },
  },
  methods: {
    //Obtener Datos de la BD
    async fetchData() {
      try {
        const sex = await axios.get('/getSex')
        const pais = await axios.get('/getPais')
        const clientes = await axios.get('/getAllClientes')
        const usuarios = await axios.get('/GetAllUsers') // New API call to get Usuario data


        this.countries = pais.data.map((pais) => ({
          id: pais.id_pais,
          nombre: pais.nombre_pais
        }))
        this.gender = sex.data.map((sexo) => ({
          id: sexo.id_sexo,
          nombre: sexo.nombre_sexo
        }))
        this.clienteData = clientes.data.map((cliente) => ({
          id: cliente.numero_identidad_cliente,
          nombre: cliente.nombre_cliente,
          email: cliente.correo_electronico
        }))
        console.log(this.clienteData)

        this.usuarioData = usuarios.data.map((usuario) => ({
          id: usuario.id_usuario,
          nombre: usuario.nombre_usuario
        }))
        console.log(this.usuarioData)
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    },
    //Validar Nombre de Usuario
    validateUsername() {
      const existingUser = this.usuarioData.find(
        (usuario) => usuario.nombre === this.registerForm.nombre_usuario
      )
      console.log(existingUser)

      this.errors.nameExists = !!existingUser
    },
    //Registrarse como cliente
    async signUp() {
      this.formSubmitted.register = true
      try {
        this.registerForm.nombre_cliente = this.registerForm.nombre_usuario

        if (!this.registerForm.id_sexo) {
          alert('El campo sexo es obligatorio')
          return
        }

        this.validateEmail()
        this.validateUsername()

        if (this.errors.nameExists) {
          alert('Nombre ya existe')
          return
        }

        if (this.errors.emailExists) {
          alert('Email ya existe')
          return
        }

        const res = await axios.post('/signUp', this.registerForm)
        const generated = res.data.id_usuario
        this.registerForm.numero_id_cliente = generated
        const rest = await axios.post('/postCliente', this.registerForm)

        console.log(rest)
        this.reset()
        this.showAlertMessage(res.data.message, true)
      } catch (error) {
        this.showAlertMessage('Error al registrar usuario', false)
      } finally {
        this.formSubmitted.register = false
      }

      if (this.isRegisterFormValid) {
        console.log('Registrando:', this.registerForm)
        this.showAlert = true
        this.isSuccess = true
        this.alertMessage = 'Registro exitoso'
      }
    },
    //Validar Email
    validateEmail() {
      const existingEmail = this.clienteData.find(
        (cliente) => cliente.email === this.registerForm.correo_electronico
      )
      this.errors.emailExists = !!existingEmail
    },
    //Loguearse duramente
    async signIn() {
      // Login Normal
      if (this.isLoginFormValid) {
        console.log('Iniciando sesión:', this.loginForm)
        this.showAlert = true
        this.isLoggedIn = true
        this.isSuccess = true
        this.alertMessage = 'Inicio de sesión exitoso'
        this.$emit('login')
      }

      // Login con BD
      this.formSubmitted.login = true
      try {
        const existingUser = this.usuarioData.find(
          (usuario) => usuario.nombre === this.loginForm.nombre_usuario
        )
        if (!existingUser) {
          this.showAlertMessage('Usuario no encontrado', false)
          return
        }

        this.loginForm.id_usuario = existingUser.id // Set the ID for login
        const res = await axios.post('/signIn', this.loginForm)
        this.reset()
        this.showAlertMessage(res.data.message, true)
        sessionStorage.setItem('session', JSON.stringify(res.data.Usuario))
        await this.redirectUser(res.data.Usuario.rol)
      } catch (error) {
        console.error('Error en el cliente:', error)
        if (error.response) {
          switch (error.response.status) {
            case 401:
              this.showAlertMessage('Contraseña incorrecta', false)
              break
            case 404:
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
      } finally {
        this.loginForm = false
      }
    },
    //Para donde vamos despues de loguearme
    redirectUser(role) {
      if (role === 'Cliente') {
        this.$router.push({ name: 'clientview' })
      } else if (role === 'Vendedor') {
        this.$router.push({ name: 'workerview' })
      } else if (role === 'AdminGen') {
        this.$router.push({ name: 'adminview' })
      }
    },
    resetForm() {
      this.$refs.signupForm.reset();
    }

  },
  mounted() {
    this.fetchData()
  }
}
</script>

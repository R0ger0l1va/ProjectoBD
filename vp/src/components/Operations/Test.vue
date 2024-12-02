<template>
  <v-container class="auth-container"
               fill-height
               fluid>
    <v-row align="center"
           justify="center">
      <v-col cols="12"
             lg="8"
             md="6"
             sm="8">
        <v-card class="elevation-12">
          <v-window v-model="step">
            <v-window-item :value="1">
              <v-row>
                <v-col cols="12"
                       md="8">
                  <v-card-text>
                    <h1 class="text-center text-h4 mb-5">Crear Cuenta</h1>
                    <v-form ref="signupForm"
                            v-model="isFormValid"
                            @submit.prevent="signUp">
                      <v-row>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model="registerForm.nombre_usuario"
                            :rules="[v => !!v || 'Campo requerido', v => v.length >= 3 || 'Mínimo 3 caracteres', v => !/\d/.test(v) || 'No puede contener números']"
                            label="Nombre"
                            required
                            @blur="validateUsername"
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model="registerForm.apellido_cliente"
                            :rules="[v => !v || !/\d/.test(v) || 'No puede contener números']"
                            label="Apellido (Opcional)"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols="12"
                               md="6">
                          <v-select
                            v-model="registerForm.id_pais"
                            :items="countries"
                            :rules="[v => !!v || 'Seleccione un país']"
                            item-title="nombre"
                            item-value="id"
                            label="País"
                            required
                          ></v-select>
                        </v-col>
                        <v-col cols="12"
                               md="6">
                          <v-select
                            v-model="registerForm.id_sexo"
                            :items="gender"
                            item-title="nombre"
                            item-value="id"
                            label="Sexo"
                          ></v-select>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model.number="registerForm.edad"
                            :rules="[v => !!v || 'Campo requerido', v => v >= 18 || 'Debe ser mayor de 18 años', v => v <= 100 || 'Debe ser menor de 100 años']"
                            label="Edad"
                            required
                            type="number"
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model="registerForm.direccion_postal"
                            label="Dirección Postal (Opcional)"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model="registerForm.telefono"
                            label="Teléfono (Opcional)"
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model="registerForm.correo_electronico"
                            :rules="[v => !!v || !registerForm.telefono || 'Campo requerido si no hay teléfono', v => !v || /.+@.+\..+/.test(v) || 'E-mail debe ser válido']"
                            label="Correo Electrónico"
                            type="email"
                            @blur="validateEmail"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-row>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model="registerForm.contrasenna"
                            :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                            :rules="[v => !!v || 'Campo requerido', v => v.length >= 3 || 'Mínimo 3 caracteres']"
                            :type="showPassword ? 'text' : 'password'"
                            label="Contraseña"
                            required
                            @click:append="showPassword = !showPassword"
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12"
                               md="6">
                          <v-text-field
                            v-model="registerForm.carnet_identidad"
                            :append-icon="showCarnet ? 'mdi-eye' : 'mdi-eye-off'"
                            :rules="[v => !v || !/[a-zA-Z]/.test(v) || 'No puede contener letras']"
                            :type="showCarnet ? 'text' : 'password'"
                            label="Carnet de Identidad (Opcional)"
                            @click:append="showCarnet = !showCarnet"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                      <v-btn
                        :disabled="!isFormValid"
                        block
                        class="mt-4"
                        color="primary"
                        type="submit"

                      >
                        Registrarse
                      </v-btn>
                    </v-form>
                  </v-card-text>
                </v-col>
                <v-col class="bg-primary"
                       cols="12"
                       md="4">
                  <v-card-text class="white--text text-center d-flex flex-column justify-center align-center h-100">
                    <h2 class="text-h4 mb-4">¡Bienvenido!</h2>
                    <p>¿Ya tienes una cuenta?</p>
                    <v-btn dark
                           outlined
                           @click="step++">Iniciar Sesión
                    </v-btn>
                  </v-card-text>
                </v-col>
              </v-row>
            </v-window-item>

            <v-window-item :value="2">
              <v-row>
                <v-col class="bg-primary"
                       cols="12"
                       md="4">
                  <v-card-text class="white--text text-center d-flex flex-column justify-center align-center h-100">
                    <h2 class="text-h4 mb-4">¡Hola, amigo!</h2>
                    <p>¿No tienes una cuenta?</p>
                    <v-btn dark
                           outlined
                           @click="step--">Registrarse
                    </v-btn>
                  </v-card-text>
                </v-col>
                <v-col cols="12"
                       md="8">
                  <v-card-text>
                    <h1 class="text-center text-h4 mb-5">Iniciar Sesión</h1>
                    <v-form ref="signinForm"
                            v-model="isFormLoginValid"
                            @submit.prevent="signIn">
                      <v-text-field
                        v-model="loginForm.nombre_usuario"
                        :rules="[v => !!v || 'Campo requerido']"
                        label="Nombre de Usuario"
                        required
                      ></v-text-field>
                      <v-text-field
                        v-model="loginForm.contrasenna"
                        :append-icon="showLoginPassword ? 'mdi-eye' : 'mdi-eye-off'"
                        :rules="[v => !!v || 'Campo requerido', v => v.length >= 3 || 'Mínimo 3 caracteres']"
                        :type="showLoginPassword ? 'text' : 'password'"
                        label="Contraseña"
                        required
                        @click:append="showLoginPassword = !showLoginPassword"
                      ></v-text-field>
                      <v-btn class="mb-4"
                             color="primary"
                             text>¿Olvidaste tu contraseña?
                      </v-btn>
                      <v-btn
                        :disabled="!isFormLoginValid"
                        block
                        class="mt-4"
                        color="primary"
                        type="submit"
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
    <v-snackbar v-model="showAlert"
                :color="isSuccess ? 'success' : 'error'"
                :timeout="3000">
      {{
        alertMessage
      }}
      <template v-slot:action="{ attrs }">
        <v-btn text
               v-bind="attrs"
               @click="showAlert = false">
          Cerrar
        </v-btn>
      </template>
    </v-snackbar>
  </v-container>
</template>

<script>
import axios from 'axios'

export default {
  name: 'LoginRegister',
  data: () => ({
    step: 1,
    isFormValid: false,
    isFormLoginValid: false,
    showPassword: false,
    showLoginPassword: false,
    showCarnet: false,
    showAlert: false,
    isSuccess: false,
    alertMessage: '',

    registerForm: {
      nombre_usuario: '',
      apellido_cliente: '',
      numero_identidad_cliente: 0,
      nombre_cliente: '',
      rol: '',
      id_pais: null,
      id_sexo: null,
      edad: null,
      direccion_postal: '',
      telefono: '',
      correo_electronico: '',
      contrasenna: '',
      carnet_identidad: null,
    },
    loginForm: {
      id_usuario: '',
      nombre_usuario: '',
      contrasenna: '',
      rol: ''
    },
    countries: [],
    gender: [],
    clienteData: [],
    usuarioData: [],
  }),
  computed: {
    isRegisterFormValid() {
      return this.isFormValid;
    },
    isLoginFormValid() {
      return this.isFormLoginValid;
    },
  },
  methods: {
    async fetchData() {
      try {
        const [sex, pais, clientes, usuarios] = await Promise.all([
          axios.get('/getSex'),
          axios.get('/getPais'),
          axios.get('/getAllClientes'),
          axios.get('/GetAllUsers')
        ]);
        console.log(clientes.data)

        this.countries = pais.data.map((pais) => ({
          id: pais.id_pais,
          nombre: pais.nombre_pais
        }))


        this.gender = sex.data.map(sexo => ({
          id: sexo.id_sexo,
          nombre: sexo.nombre_sexo
        }));

        this.clienteData = clientes.data.map(cliente => ({
          id: cliente.numero_identidad_cliente,
          nombre: cliente.nombre_cliente,
          email: cliente.correo_electronico
        }));

        this.usuarioData = usuarios.data.map(usuario => ({
          id: usuario.id_usuario,
          nombre: usuario.nombre_usuario
        }));

      } catch (error) {
        console.error('Error fetching data:', error);
        this.showAlertMessage('Error al cargar datos', false);
      }
    },
    validateUsername() {
      const existingUser = this.usuarioData.find(
        usuario => usuario.nombre === this.registerForm.nombre_usuario
      );
      if (existingUser) {
        this.showAlertMessage('Nombre de usuario ya existe', false);

      }

      return !existingUser
    },
    validateEmail() {
      const existingEmail = this.clienteData.find(
        cliente => cliente.email === this.registerForm.correo_electronico
      );
      if (existingEmail) {
        this.showAlertMessage('Email ya existe', false);

      }
      return !existingEmail
    },
    async signUp() {
      if (this.isRegisterFormValid) {
        try {
          if (!this.validateUsername() || !this.validateEmail()) {
            throw new Error('Nombre de usuario o email ya existen');

          }
          this.registerForm.nombre_cliente = this.registerForm.nombre_usuario;
          const res = await axios.post('/signUp', this.registerForm);
          const generated = res.data.id_usuario;
          this.registerForm.numero_id_cliente = generated;
          const clienteRes = await axios.post('/postCliente', this.registerForm);
          console.log(clienteRes);
          this.showAlertMessage('Registro exitoso', true);
          this.resetForm();
        } catch (error) {
          console.error('Error en el registro:', error);
          this.showAlertMessage('Error al registrar usuario', false);
        }
      }


    },
    async signIn() {

      try {

        const existingUser = this.usuarioData.find(
          (usuario) => usuario.nombre === this.loginForm.nombre_usuario
        )
        if (!existingUser) {
          this.showAlertMessage('Usuario no encontrado', false)
          return
        }
        this.loginForm.id_usuario = existingUser.id // Set the ID for login
        console.log('LOCCCCCOOOOOOOOOOO')
        const res = await axios.post('/signIn', this.loginForm);

        console.log('Iniciando sesión:', this.loginForm)
        this.showAlert = true
        this.isLoggedIn = true
        this.isSuccess = true
        this.alertMessage = 'Inicio de sesión exitoso'
        const aux = res.data.Usuario.id_usuario
        const clientResponse = await axios.get(`/getCliente/${aux}`);
        const client = clientResponse.data;
        console.log(client)
        this.$emit('login', {userName: this.loginForm.nombre_usuario, userType: res.data.Usuario.rol, client: client}); // Emitir detalles del usuario


        this.showAlertMessage('Inicio de sesión exitoso', true);
        sessionStorage.setItem('session', JSON.stringify(res.data.Usuario));
        await this.redirectUser(res.data.Usuario.rol);
      } catch (error) {
        console.error('Error en el inicio de sesión:', error);
        this.showAlertMessage('Error al iniciar sesión', false);
      }

    },
    redirectUser(role) {
      const routes = {
        'Cliente': '/clientview',
        'Vendedor': '/workerview',
        'AdminGen': '/adminview'
      };
      const route = routes[role];
      if (route) {
        this.$router.push({path: route});
      } else {
        this.showAlertMessage('Rol desconocido', false);
      }
    },
    showAlertMessage(message, isSuccess) {
      this.alertMessage = message;
      this.isSuccess = isSuccess;
      this.showAlert = true;
    },
    resetForm() {
      this.$refs.signupForm.reset();
    }
  },
  mounted() {
    this.fetchData();
  }
}
</script>

<style scoped>
.auth-container {
  background: #f6f5f7;
}

.bg-primary {
  background: linear-gradient(to right, #046c54, #046c54, green);
}
</style>

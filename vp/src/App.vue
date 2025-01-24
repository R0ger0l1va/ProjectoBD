<template>
  <v-app>
    <nav-bar :state="isLoggedIn"
             :userName="userName"
             :userType="userType"
             :clientData="clientData"
    />
    <v-main>
      <router-view @login="handleLogin"/>
    </v-main>
  </v-app>
</template>

<script>
import NavBar from "@/components/Nav/NavBar.vue";

export default {
  components: { NavBar },
  data() {
    return {
      isLoggedIn: false,
      userName: '', // Definir userName
      userType: '', // Definir userType
      clientData: null // DatosDelCliente
    };
  },
  methods: {
    handleLogin(userDetails) {
      this.isLoggedIn = true;
      this.userName = userDetails.userName;
      this.userType = userDetails.userType;
      this.clientData = userDetails.client;

      // Guardar estado en sessionStorage
      sessionStorage.setItem('isLoggedIn', true);
      sessionStorage.setItem('userName', userDetails.userName);
      sessionStorage.setItem('userType', userDetails.userType);
      sessionStorage.setItem('clientData', JSON.stringify(userDetails.client));
    },
    handleLogout() {
      this.isLoggedIn = false;
      this.userName = '';
      this.userType = '';
      this.clientData = null;

      // Limpiar estado de sessionStorage
      sessionStorage.removeItem('isLoggedIn');
      sessionStorage.removeItem('userName');
      sessionStorage.removeItem('userType');
      sessionStorage.removeItem('clientData');
    },
  },
  watch: {
    $route(to) {
      if (to.path !== '/') {
        // Si no es la ruta principal, verifica si hay un token y carga los datos
        const token = sessionStorage.getItem('token'); // O donde estés almacenando el token
        if (token) {
          // Aquí puedes agregar la lógica para obtener los detalles del usuario si es necesario
          const userDetails = {
            userName: sessionStorage.getItem('userName'),
            userType: sessionStorage.getItem('userType'),
            client: JSON.parse(sessionStorage.getItem('clientData'))
          };
          this.handleLogin(userDetails); // Llama a handleLogin con los datos del usuario
        }
      } else {
        this.handleLogout(); // Si es la ruta principal, cierra sesión
      }
    }
  },
  created() {
    // Restaurar estado desde sessionStorage
    if (sessionStorage.getItem('isLoggedIn')) {
      this.isLoggedIn = true;
      this.userName = sessionStorage.getItem('userName');
      this.userType = sessionStorage.getItem('userType');
      this.clientData = JSON.parse(sessionStorage.getItem('clientData'));
    }
  }
}
</script>

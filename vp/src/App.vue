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
  components: {NavBar}, data() {
    return {
      isLoggedIn: false,
      userName: '', // Definir userName
      userType: '', // Definir userType
      clientData: null// DatosDelCLiente
    }
  }, methods: {
    handleLogin(userDetails) {
      this.isLoggedIn = true;
      this.userName = userDetails.userName;
      this.userType = userDetails.userType;
      this.clientData = userDetails.client

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
      if (to.path === '/') {
        this.handleLogout();
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
    this.$router.afterEach((to) => {
      if (to.path === '/') {
        this.handleLogout();
      }
    });
  }
}


</script>

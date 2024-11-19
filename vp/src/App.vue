<template>
  <v-app>
    <nav-bar :state = "isLoggedIn"
             :userName = "userName"
             :userType = "userType"
             :clientData ="clientData"
    />
    <v-main>
      <router-view @login = "handleLogin"/>

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

    },
    handleLogout() {
      this.isLoggedIn = false;
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
    this.$router.afterEach((to) => {
      if (to.path === '/') {
        this.handleLogout();
      }
    });
  }
}


</script>

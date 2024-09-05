<script >
import LoginApp from "./Components/Login/LoginApp.vue"
import OperationsContainer from "./Components/MainPage/OperationsContainer.vue";
import PolicyDashboard from "./Components/MainPage/PolicyDashboard.vue";

export default {
  components: {
    LoginApp,
    OperationsContainer,
    PolicyDashboard
  }
}


</script>

<template>
  <div><policy-dashboard></policy-dashboard>
  </div>
  <div>
    <OperationsContainer></OperationsContainer>
  </div>



</template>

<style >


</style>

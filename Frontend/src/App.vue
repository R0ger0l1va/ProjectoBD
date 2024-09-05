<script >
import OperationsContainer from "./Components/MainPage/OperationsContainer.vue";
import PolicyDashboard from "./Components/MainPage/PolicyDashboard.vue";
import LoginRegister from "./Components/Login/LoginRegister.vue";
import ContenedorPrincipal from "./Components/MainPage/ContenedorPrincipal.vue";
import CrearPoliza from "./Components/Operations/CrearPoliza.vue";
import ModificarPoliza from "./Components/Operations/ModificarPoliza.vue";
import ListaPolizas from "./Components/Operations/ListaPolizas.vue";
export default {
  components: {
    CrearPoliza,
    ModificarPoliza,
    ListaPolizas,
    OperationsContainer,
    PolicyDashboard,
    ContenedorPrincipal,
    LoginRegister,
  }
}


</script>

<template>
  <div><policy-dashboard></policy-dashboard>
  </div>
  <div>
    <OperationsContainer></OperationsContainer>
  </div>
  <div> <login-register></login-register></div>
  <crear-poliza></crear-poliza>
  <modificar-poliza></modificar-poliza>
  <lista-polizas></lista-polizas>



</template>

<style >


</style>./Components/Login/LoginRegister.vue

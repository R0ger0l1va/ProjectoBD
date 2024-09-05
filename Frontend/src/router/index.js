import { createRouter, createWebHistory } from 'vue-router'
import LoginRegister from '@/components/Login/LoginRegister.vue'
import OperationsContainer from '@/components/MainPage/OperationsContainer.vue'
import PolicyDashboard from '@/components/MainPage/PolicyDashboard.vue'
import CrearPoliza from '@/components/Operations/CrearPoliza.vue'
import ModificarPoliza from '@/components/Operations/ModificarPoliza.vue'
import ListaPolizas from '@/components/Operations/ListaPolizas.vue'

const routes = [
  
  { path: '/login', component: LoginRegister },
  { path: '/register', component: LoginRegister },
  {path: '/operation', component: OperationsContainer},
  {path: '/policy', component: PolicyDashboard},
  {path: '/crearPoliza', component: CrearPoliza},
  {path: '/modPoliza', component: ModificarPoliza},
  {path: '/listPoliza', component: ListaPolizas},

]
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router

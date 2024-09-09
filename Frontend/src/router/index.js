import { createRouter, createWebHistory } from 'vue-router'
import LoginRegister from '../components/Login/LoginRegister.vue'
import GestorPolizasMejorado from '../components/MainPage/GestorPolizasMejorado.vue'
import ClientPolicyDashboard from '../components/MainPage/PolicyDashboard.vue'



const routes = [

  {
    path: '/',
    name: 'login',
    component: LoginRegister
  },
  {
    path: '/gp',
    name: 'gestor-polizas',
    component: GestorPolizasMejorado,
    meta: {
      requiresAdmin: true
    }
  },
  {
    path: '/gpw',
    name: 'gestor-polizas-worker',
    component: GestorPolizasMejorado,
    meta: {
      requiresWorker: true
    }
  },
  {
    path: '/pol',
    name: 'client-policy-dashboard',
    component: ClientPolicyDashboard,
    meta: {
      requiresUser: true
    }
  }

]
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router




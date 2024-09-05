import { createRouter, createWebHistory } from 'vue-router'
import LoginRegister from '@/components/Login/LoginRegister.vue'
import OperationsContainer from '@/components/MainPage/OperationsContainer.vue'
import PolicyDashboard from '@/components/MainPage/PolicyDashboard.vue'

const routes = [
  
  { path: '/login', component: LoginRegister },
  { path: '/register', component: LoginRegister },
  {path: '/operation', component: OperationsContainer},
  {path: '/policy', component: PolicyDashboard},
]
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router

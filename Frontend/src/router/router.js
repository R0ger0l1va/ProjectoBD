import { createRouter, createWebHistory } from 'vue-router'
import LoginRegister from './components/LoginRegister.vue' // Ajusta la ruta según tu estructura de proyecto

const routes = [
  { path: '/login', component: LoginRegister },
  { path: '/register', component: LoginRegister }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
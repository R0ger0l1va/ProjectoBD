import { createRouter, createWebHistory } from 'vue-router'
import LoginRegister from '@/components/Login/LoginRegister.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/about',
    name: 'about',
    // route level code-splitting
    // this generates a separate chunk (About.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
   
  },
  { path: '/login', component: LoginRegister },
  { path: '/register', component: LoginRegister }
]
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router

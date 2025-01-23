/**
 * router/index.ts
 *
 * Automatic routes for `./src/pages/*.vue`
 */

// Composables
import { createRouter, createWebHistory } from 'vue-router';
import userList from "@/components/Operations/UserList.vue";
import ClientView from "@/pages/ClientView.vue";
import test from "@/components/Operations/Test.vue";
import poliList from "@/components/Operations/PoliList.vue";
import DocumentList from "@/components/Operations/DocumentList.vue";
import PoliCard from "@/components/Operations/PoliCard.vue";

const manualRoutes = [
  { path: '/polilist', component: poliList },
  { path: '/userlist', component: userList },
  { path: '/documentList', component: DocumentList },
  { path: '/', component: test },
  { path: '/clientview', component: ClientView },
  { path: '/policard', component: PoliCard }
];

// Crear el router
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: manualRoutes,
});

// Guardias de navegación
router.beforeEach((to, from, next) => {
  const token = sessionStorage.getItem('token'); // O donde estés almacenando el token

  // Aquí puedes definir qué rutas requieren autenticación
  const protectedRoutes = [ '/polilist', '/userlist', '/documentList',  '/clientview', '/policard'];

  if (protectedRoutes.includes(to.path)) {
    if (!token) {
      // Si no hay token, redirige a la página de inicio o login
      next({ path: '/' }); // Redirige a la ruta deseada (por ejemplo, la página de inicio)
    } else {
      next(); // Permite la navegación
    }
  } else {
    next(); // Permite la navegación si no requiere autenticación
  }
});

export default router;

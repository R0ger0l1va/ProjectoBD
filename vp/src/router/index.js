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
import PolPedidas from '@/components/Operations/PolPedidas.vue';
import axios from 'axios';

const manualRoutes = [
  { path: '/polilist', component: poliList },
  { path: '/userlist', component: userList },
  { path: '/documentList', component: DocumentList },
  { path: '/', component: test },
  { path: '/clientview', component: ClientView },
  { path: '/policard', component: PoliCard },
  { path: '/pedidos', component: PolPedidas }
];

// Crear el router
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: manualRoutes,
});

// Guardias de navegación
router.beforeEach(async (to, from, next) => {
  const token = sessionStorage.getItem('token'); // O donde estés almacenando el token

  // Si no hay token, redirige a la página de inicio
  if (!token) {
      if (to.path !== '/') {
          return next({ path: '/' }); // Redirige a la página de inicio si intenta acceder a otra ruta
      }
      return next(); // Permite la navegación a la página de inicio
  }

  try {
      // Realiza la solicitud a /profile para obtener el rol del usuario
      const response = await axios.get("/profile", {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });

      const userRole = response.data.msg.rol; // Asegúrate de que 'rol' sea la clave correcta en tu payload
      console.log(userRole);

      // Define las rutas permitidas según el rol
      const roleBasedRoutes = {
          Trabajador: ['/polilist', '/userList', '/pedidos', '/documentList','/'],
          AdminGen: ['/polilist', '/userList', '/pedidos', '/documentList','/'],
          Cliente: ['/policard', '/clientview','/']
      };

      console.log('Requested path:', to.path); // Verifica la ruta solicitada
      // Verifica si la ruta solicitada está permitida para el rol del usuario
      if (roleBasedRoutes[userRole] && roleBasedRoutes[userRole].includes(to.path)) {
          return next(); // Permite la navegación
      } else {
        console.log('Access denied, redirecting to base path'); // Log para acceso denegado

          return next({ path: '/' }); // Redirige a la página de inicio si no tiene acceso
      }
  } catch (error) {
      console.error('Error al obtener el rol del usuario:', error);
      return next({ path: '/' }); // Redirige a la página de inicio si hay un error al obtener el rol
  }
});

export default router;

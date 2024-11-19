/**
 * plugins/index.js
 *
 * Automatically included in `./src/main.js`
 */

// Plugins
import vuetify from './vuetify'
import router from '@/router'
import axios from 'axios'
import VueAxios from 'vue-axios'

export function registerPlugins (app) {
  // Configuración global de axios
  axios.defaults.baseURL = 'http://localhost:3000/'


  app
    .use(vuetify)
    .use(router)
    .use(VueAxios, axios)
}

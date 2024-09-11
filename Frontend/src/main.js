import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import axios from 'axios'

const app = createApp(App)

app.use(router)

app.mount('#app')

// Set the base URL for the API requests
axios.defaults.baseURL = 'http://localhost:3000/api';

// Make a GET request to the backend API endpoint
axios.get('/data')
    .then(response => {
        // Use the data from the backend in your frontend app
        console.log(response.data);
    })
    .catch(error => {
        console.error(error);
    });
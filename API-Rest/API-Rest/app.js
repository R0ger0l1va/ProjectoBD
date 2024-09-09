const express = require('express');
const routes = require('./routes/router');

const app = express();

//Settings
app.set('port', process.env.port || 3000);


//Middlewares

//Routes
app.use(routes);

//public

//Server On
app.listen(app.get('port'), () => console.log('Server listen on the port ', app.get('port')));
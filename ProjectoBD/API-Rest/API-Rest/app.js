const express = require('express');
const routes = require('./routes/router');

const app = express();

// Settings
app.set('port', process.env.PORT || 3000); // Use uppercase PORT for environment variable

// Middlewares
app.use(express.json()); // Add JSON middleware to parse JSON requests
app.use(express.urlencoded({ extended: true })); // Add URL-encoded middleware

// Routes
app.use(routes);

// Public
app.use(express.static('public'));

// API Endpoint for frontend to fetch data
app.get('/api/data', (req, res) => {
    // Return some data from the database or a sample data
    res.json({ message: 'Hello from backend!' });
});

// Server On
app.listen(app.get('port'), () => {
    console.log(`Server listening on port ${app.get('port')}`);
});
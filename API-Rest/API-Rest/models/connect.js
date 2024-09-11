/*
This code creates a PostgreSQL database connection pool using the 'pg' module. It exports a query function that takes a SQL query and optional parameters, and executes the query using the pool.
*/const {Pool} = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    port: 5432,
    password: '123',
    database: 'Poliza'
});

module.exports = {
    query: (queryText, params) => pool.query(queryText, params),
}
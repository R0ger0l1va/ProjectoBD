const {Pool} = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    port: 5432,
    password: '0403',
    database: 'Productos'
});

module.exports = {
    query: (queryText, params) => pool.query(queryText, params),
}
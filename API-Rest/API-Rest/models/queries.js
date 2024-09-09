const pg = require('./connect');

const getAllProducts = async () => {
    return await pg.query("SELECT * FROM productos");
}

const getAllProductsByName = async (name) => {
    return await pg.query("SELECT * FROM productos WHERE nombre = $1", name);
}

const getAllProductsLikeName = async (name) => {
    return await pg.query("SELECT * FROM productos WHERE nombre LIKE $1", name);
}

const updateProductByName = async (params) =>{
    pg.query("UPDATE productos set nombre = $1 WHERE nombre = $2", params);
    return await pg.query('SELECT * FROM productos');
}

const addProduct = async (params)=>{
    pg.query("INSERT INTO productos (nombre, id, existencia, precio) values ($1, $2, $3, $4)", params);
    return await pg.query('SELECT * FROM productos');
}

const updateProduct = async (params) =>{
    pg.query("UPDATE productos WHERE id = $1 SET nombre = $2, existencias = $3, precio = $4 ", params);
    return pg.query('SELECT * FROM productos');
}

const allDesc = async (desc)=>{
    return pg.query("SELECT nombre, id, existencia, (precio - $1) as descuento FROM productos", desc);
}
module.exports = {
    allDesc,
    getAllProducts,
    getAllProductsByName,
    getAllProductsLikeName,
    updateProductByName,
    addProduct,
}
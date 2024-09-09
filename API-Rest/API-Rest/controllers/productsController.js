const queries = require('../models/queries');

const getAllproducts = (req, res) => {
    queries.getAllProducts()
        .then(products => {
            res.status(200).json(products.rows);
        })
        .catch(error => console.log(error));
}

const getAllProductsByName = (req, res) => {
    let name = req.params.name;
    name = name.toUpperCase()[0] + name.substring(1,name.length);
    queries.getAllProductsByName([name])
        .then(products => {
            res.status(200).json(products.rows);
        })
        .catch(error => console.log(error));
};

const getAllProductsLikeName = (req, res) => {
    let name = req.params.name;
    name = '%' + req.params.name + '%';
    console.log(name);
    queries.getAllProductsLikeName([name])
        .then(products => res.status(200).json(products.rows))
        .catch(error => console.log(error));
}

const addProducts = (req, res) => {
   const {name, id} = req.body.id;
   console.log( );
   console.log(name);
   console.log(id);
   //res.send(id);
}

module.exports = {
    getAllproducts,
    getAllProductsByName,
    getAllProductsLikeName,
    addProducts,
}
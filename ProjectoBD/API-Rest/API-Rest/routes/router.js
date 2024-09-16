const {Router} = require('express');
const router = Router();
const productsController = require('../controllers/productsController');

router.get('/products', productsController.getAllproducts);
router.get('/products/:name', productsController.getAllProductsByName)
router.get('/products/name/:name', productsController.getAllProductsLikeName);
router.post('/products', productsController.addProducts);
router.get('/products/:desc', productsController)
module.exports = router;
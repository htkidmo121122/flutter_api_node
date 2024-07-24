// routes/favoriteRoutes.js
const express = require('express');
const router = express.Router();
const FavoriteController = require('../controllers/FavouriteController');
const { authUserMiddleWare } = require('../middleware/authMiddleware');

router.post('/:id', authUserMiddleWare, FavoriteController.addFavorite);
router.get('/:id', authUserMiddleWare ,FavoriteController.getFavoritesByUser);
router.delete('/:id',authUserMiddleWare, FavoriteController.removeFavorite);
router.post('/check-favourite/:id', authUserMiddleWare, FavoriteController.checkIfProductIsFavorite);


module.exports = router;

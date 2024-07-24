// controllers/FavoriteController.js
const FavoriteService = require('../services/FavouriteService');

const addFavorite = async (req, res) => {
  try {
    const productId  = req.body.productId
    const userId = req.params.id ;
    if (!userId || !productId) {
      return res.status(400).json({
        status: 'ERR',
        message: 'Missing Required Fields'
      });
    }
    
    const favoriteData = {
      user: userId,
      product: productId
    };
    
    const favorite = await FavoriteService.addFavorite(favoriteData);
    return res.status(201).json(favorite);
  } catch (e) {
    return res.status(500).json({
      message: e.message
    });
  }
};

const getFavoritesByUser = async (req, res) => {
  try {
    const userId  = req.params.id;
    const favorites = await FavoriteService.getFavoritesByUser(userId);
    return res.status(200).json(favorites);
  } catch (e) {
    return res.status(500).json({
      message: e.message
    });
  }
};

const removeFavorite = async (req, res) => {
  try {
    const productId = req.body.productId;
    const userId = req.params.id;
    const favorite = await FavoriteService.removeFavorite(userId, productId);
    if (!favorite) {
      return res.status(404).json({
        status: 'ERR',
        message: 'Favorite Not Found'
      });
    }
    return res.status(200).json({
      status: 'OK',
      message: 'Favorite Removed'
    });
  } catch (e) {
    return res.status(500).json({
      message: e.message
    });
  }
};

// Thêm phương thức kiểm tra sản phẩm yêu thích
const checkIfProductIsFavorite = async (req, res) => {
  try {
    const productId = req.body.productId; 
    const userId = req.params.id;
    if (!userId || !productId) {
      return res.status(400).json({
        status: 'ERR',
        message: 'Missing Required Fields'
      });
    }
    
    const isFavorite = await FavoriteService.isProductFavorite(userId, productId);
    return res.status(200).json({
      status: 'OK',
      isFavorite
    });
  } catch (e) {
    return res.status(500).json({
      message: e.message
    });
  }
};

module.exports = {
  addFavorite,
  getFavoritesByUser,
  removeFavorite,
  checkIfProductIsFavorite
};

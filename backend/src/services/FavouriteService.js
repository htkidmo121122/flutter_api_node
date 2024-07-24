// services/FavoriteService.js
const Favourite = require('../models/FavouriteModel');

const addFavorite = async (favoriteData) => {
  try {
    // Kiểm tra xem sản phẩm đã tồn tại trong danh sách yêu thích chưa
    const existingFavorite = await Favourite.findOne({ user: favoriteData.user, product: favoriteData.product });
    if (existingFavorite) {
      throw new Error('Product Is Already In Your Favorites');
    }
    
    const favorite = new Favourite(favoriteData);
    await favorite.save();
    
    // Populate the 'product' field in the saved favorite object
    const populatedFavorite = await Favourite.findById(favorite._id)
      .populate('product', 'name')
      .exec();
    
    return populatedFavorite;
  } catch (e) {
    throw new Error(e.message);
  }
};

const getFavoritesByUser = async (userId) => {
  try {
    const favorites = await Favourite.find({ user: userId })
      .populate('product')
      .exec();
    return favorites;
  } catch (e) {
    throw new Error(e.message);
  }
};

const removeFavorite = async (userId, productId) => {
  try {
    const favorite = await Favourite.findOneAndDelete({ user: userId, product: productId });
    return favorite;
  } catch (e) {
    throw new Error(e.message);
  }
};

// Thêm phương thức kiểm tra sản phẩm yêu thích
const isProductFavorite = async (userId, productId) => {
  try {
    const favorite = await Favourite.findOne({ user: userId, product: productId });
    return !!favorite;
  } catch (e) {
    throw new Error(e.message);
  }
};

module.exports = {
  addFavorite,
  getFavoritesByUser,
  removeFavorite,
  isProductFavorite
};

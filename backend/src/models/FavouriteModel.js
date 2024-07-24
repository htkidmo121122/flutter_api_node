// models/FavoriteModel.js
const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const FavoriteSchema = new Schema({
    user: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'User', 
        required: true 
    },
    product: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'Product', 
        required: true 
    },
    createdAt: { 
        type: Date, 
        default: Date.now 
    }
});
const Favourite = mongoose.model('Favorite', FavoriteSchema);
module.exports = Favourite;

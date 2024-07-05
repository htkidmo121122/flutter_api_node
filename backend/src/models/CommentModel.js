const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema(
    {
        product: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Product',
            required: true,
        },
        user: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User',
            require: true,

        },
        content: {type: String, require: true},
        rating: {type: Number},
        date: {
            type: Date,
            default: Date.now
        }
        
    },
    {
        timestamps: true
    }
);
const Comment = mongoose.model('Comment', commentSchema);
module.exports = Comment;
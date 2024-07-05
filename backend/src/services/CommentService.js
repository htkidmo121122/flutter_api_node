// services/CommentService.js
const Comment = require('../models/CommentModel');

const createComment = async (commentData) => {
    try {
        const comment = new Comment(commentData);
        await comment.save();

        // Populate the 'user' field in the saved comment object
        const populatedComment = await Comment.findById(comment._id)
            .populate('user', 'name avatar')
            .exec();

        return populatedComment;
    } catch (e) {
        throw new Error(e.message);
    }
};


const getCommentsByProduct = async (productId) => {
    try {
        const comments = await Comment.find({ product: productId })
            .populate('user', 'name avatar')
            .exec();
        return comments;
    } catch (e) {
        throw new Error(e.message);
    }
};

module.exports = {
    createComment,
    getCommentsByProduct
};

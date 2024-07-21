// controllers/CommentController.js
const CommentService = require('../services/CommentService');

const createComment = async (req, res) => {
    try {
        const { productId, userId, content, rating } = req.body;
        if (!productId || !userId || !content) {
            return res.status(400).json({
                status: 'ERR',
                message: 'Missing required fields'
            });
        }
        const commentData = {
            product: productId,
            user: userId,
            content,
            rating
        };
        const comment = await CommentService.createComment(commentData);
        
        // Emit the new comment to all connected clients
        req.app.get('socketio').emit('newComment', comment);

        return res.status(201).json(comment);
    } catch (e) {
        return res.status(500).json({
            message: e.message
        });
    }
};

const getCommentsByProduct = async (req, res) => {
    try {
        const { productId } = req.params;
        const comments = await CommentService.getCommentsByProduct(productId);
        return res.status(200).json(comments);
    } catch (e) {
        return res.status(500).json({
            message: e.message
        });
    }
};

module.exports = {
    createComment,
    getCommentsByProduct
};

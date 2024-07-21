// routes/commentRoutes.js
const express = require('express');
const router = express.Router();
const CommentController = require('../controllers/CommentController');

router.post('/', CommentController.createComment);
router.get('/:productId', CommentController.getCommentsByProduct);

module.exports = router;

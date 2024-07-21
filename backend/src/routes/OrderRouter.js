const express = require("express");
const router = express.Router()
const OrderController = require('../controllers/OrderController');
const { authUserMiddleWare, authMiddleWare } = require("../middleware/authMiddleware");
const Order = require("../models/OrderProduct");

router.post('/create/:id', authUserMiddleWare, OrderController.createOrder)
router.get('/get-all-order/:id',authUserMiddleWare, OrderController.getAllOrderDetails)
router.get('/get-details-order/:id', authUserMiddleWare, OrderController.getDetailsOrder)
router.delete('/cancel-order/:id',authUserMiddleWare, OrderController.cancelOrderDetails)
router.get('/get-all-order',authMiddleWare, OrderController.getAllOrder)
router.put('/confirm-delivery/:id',authMiddleWare, OrderController.confirmDelivery);
router.delete('/delete-order/:id', authMiddleWare, OrderController.deleteOrder)
router.put('/confirm-payment/:id',authUserMiddleWare, OrderController.confirmPayment);


module.exports = router
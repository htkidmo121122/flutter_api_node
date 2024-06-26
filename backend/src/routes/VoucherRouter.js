const express = require("express");
const router = express.Router()
const VoucherController = require('../controllers/VoucherController');

  
router.get('/get-all', VoucherController.getAllVoucher)
router.delete('/delete/:id', VoucherController.deleteVoucher)
router.post('/create', VoucherController.createVoucher)
router.post('/apply-voucher', VoucherController.applyVoucher)

module.exports = router
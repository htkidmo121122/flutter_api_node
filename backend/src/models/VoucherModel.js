const mongoose = require('mongoose');

const voucherSchema = new mongoose.Schema(
    {
        code: { type: String, unique: true,},
        discount: { type: Number },
        expiryDate: { type: Date},
    },
    {
        timestamps: true
    }
);

const Voucher = mongoose.model('Voucher', voucherSchema);

module.exports = Voucher;
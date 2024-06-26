
const VoucherService = require('../services/VoucherService')


const getAllVoucher = async (req, res) => {
    try {
        const response = await VoucherService.getAllVoucher()
        return res.status(200).json(response)
    } catch (e) {
        return res.status(404).json({
            message: e
        })
    }
}
const deleteVoucher = async (req, res) => {
    try {
        const voucherId = req.params.id
        if (!voucherId) {
            return res.status(200).json({
                status: 'ERR',
                message: 'The Id Voucher is required'
            })
        }
        const response = await VoucherService.deleteVoucher(voucherId)
        return res.status(200).json(response)
    } catch (e) {
        return res.status(404).json({
            message: e
        })
    }
}

const createVoucher = async (req, res) => {
    try {
        const { code, discount, expiryDate } = req.body
        if (!code || !expiryDate || !discount) {
            return res.status(200).json({
                status: 'ERR',
                message: 'The input is required'
            })
        }
        const response = await VoucherService.createVoucher(req.body)
        return res.status(200).json(response)
    } catch (e) {
        return res.status(404).json({
            message: e
        })
    }
}

const applyVoucher = async (req, res) => {
    try {
        const { code } = req.body
        if (!code) {
            return res.status(200).json({
                status: 'ERR',
                message: 'The input is required'
            })
        }
        const response = await VoucherService.applyVoucher(req.body)
        return res.status(200).json(response)
    } catch (e) {
        return res.status(404).json({
            message: e
        })
    }
}


module.exports = {
    getAllVoucher,
    deleteVoucher,
    createVoucher,
    applyVoucher
    
}

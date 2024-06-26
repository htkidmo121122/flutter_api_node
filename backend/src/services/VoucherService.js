const Voucher = require("../models/VoucherModel")

const deleteVoucher = (id) => {
    return new Promise(async (resolve, reject) => {
        try {
            const checkVoucher = await Voucher.findOne({
                _id: id
            })
            if (checkVoucher === null) {
                resolve({
                    status: 'ERR',
                    message: 'The voucher is not defined'
                })
            }

            await Voucher.findByIdAndDelete(id)
            resolve({
                status: 'OK',
                message: 'Delete voucher success',
            })
        } catch (e) {
            reject(e)
        }
    })
}

const getAllVoucher = () => {
    return new Promise(async (resolve, reject) => {
        try {
            const allVoucher = await Voucher.find().sort({createdAt: -1, updatedAt: -1})
            resolve({
                status: 'OK',
                message: 'Success',
                data: allVoucher
            })
        } catch (e) {
            reject(e)
        }
    })
}
const createVoucher = (newVoucher) => {
    return new Promise(async (resolve, reject) => {
        const { code, discount, expiryDate } = newVoucher
        try {
            const checkVoucher = await Voucher.findOne({
                code: code
            })
            if (checkVoucher !== null) {
                resolve({
                    status: 'ERR',
                    message: 'The code is already'
                })
            }
            const newVoucher = await Voucher.create({
                code,
                discount: Number(discount),
                expiryDate: new Date(expiryDate),
            })
            if (newVoucher) {
                resolve({
                    status: 'OK',
                    message: 'SUCCESS',
                    data: newVoucher
                })
            }
        } catch (e) {
            reject(e)
        }
    })
}

const applyVoucher = (applyVoucher) => {
    return new Promise(async (resolve, reject) => {
        const { code  } = applyVoucher
        try {
            const checkVoucher = await Voucher.findOne({
                code: code
            })
            const today = new Date();
            if (!checkVoucher) {
                resolve({
                    status: 'ERR',
                    message: 'Voucher not Found'
                })
            }
            
            else if (today > checkVoucher.expiryDate) {
                resolve({ 
                    status: 'ERR',
                    message: 'Voucher has expired' 
                });
            }
            else{
                resolve({
                    status: 'OK',
                    message: 'SUCCESS',
                    data: checkVoucher
                })
            }
        } catch (e) {
            reject(e)
        }
    })
}

module.exports = {
    getAllVoucher,
    deleteVoucher,
    createVoucher,
    applyVoucher

}

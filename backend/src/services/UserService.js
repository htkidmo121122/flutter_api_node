const User = require("../models/UserModel")
const bcrypt = require("bcrypt")
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { genneralAccessToken, genneralRefreshToken } = require("./JwtService")

const createUser = (newUser) => {
    return new Promise(async (resolve, reject) => {
        const { name, email, password, confirmPassword, phone } = newUser
        try {
            const checkUser = await User.findOne({
                email: email
            })
            if (checkUser !== null) {
                resolve({
                    status: 'ERR',
                    message: 'The email is already'
                })
            }
            const hash = bcrypt.hashSync(password, 10)
            const createdUser = await User.create({
                name,
                email,
                password: hash,
                phone
            })
            if (createdUser) {
                resolve({
                    status: 'OK',
                    message: 'SUCCESS',
                    data: createdUser
                })
            }
        } catch (e) {
            reject(e)
        }
    })
}

const loginUser = (userLogin) => {
    return new Promise(async (resolve, reject) => {
        const { email, password } = userLogin
        try {
            const checkUser = await User.findOne({
                email: email
            })
            if (checkUser === null) {
                resolve({
                    status: 'ERR',
                    message: 'The user is not defined'
                })
            }
            const comparePassword = bcrypt.compareSync(password, checkUser.password)

            if (!comparePassword) {
                resolve({
                    status: 'ERR',
                    message: 'The password or user is incorrect'
                })
            }
            const access_token = await genneralAccessToken({
                id: checkUser.id,
                isAdmin: checkUser.isAdmin
            })

            const refresh_token = await genneralRefreshToken({
                id: checkUser.id,
                isAdmin: checkUser.isAdmin
            })

            resolve({
                status: 'OK',
                message: 'SUCCESS',
                access_token,
                refresh_token
            })
        } catch (e) {
            reject(e)
        }
    })
}

const updateUser = (id, data) => {
    return new Promise(async (resolve, reject) => {
        try {
            const checkUser = await User.findOne({
                _id: id
            })
            if (checkUser === null) {
                resolve({
                    status: 'ERR',
                    message: 'The user is not defined'
                })
            }

            const updatedUser = await User.findByIdAndUpdate(id, data, { new: true })
            resolve({
                status: 'OK',
                message: 'SUCCESS',
                data: updatedUser
            })
        } catch (e) {
            reject(e)
        }
    })
}

const deleteUser = (id) => {
    return new Promise(async (resolve, reject) => {
        try {
            const checkUser = await User.findOne({
                _id: id
            })
            if (checkUser === null) {
                resolve({
                    status: 'ERR',
                    message: 'The user is not defined'
                })
            }

            await User.findByIdAndDelete(id)
            resolve({
                status: 'OK',
                message: 'Delete user success',
            })
        } catch (e) {
            reject(e)
        }
    })
}

const deleteManyUser = (ids) => {
    return new Promise(async (resolve, reject) => {
        try {

            await User.deleteMany({ _id: ids })
            resolve({
                status: 'OK',
                message: 'Delete user success',
            })
        } catch (e) {
            reject(e)
        }
    })
}

const getAllUser = () => {
    return new Promise(async (resolve, reject) => {
        try {
            const allUser = await User.find().sort({createdAt: -1, updatedAt: -1})
            resolve({
                status: 'OK',
                message: 'Success',
                data: allUser
            })
        } catch (e) {
            reject(e)
        }
    })
}

const getDetailsUser = (id) => {
    return new Promise(async (resolve, reject) => {
        try {
            const user = await User.findOne({
                _id: id
            })
            if (user === null) {
                resolve({
                    status: 'ERR',
                    message: 'The user is not defined'
                })
            }
            resolve({
                status: 'OK',
                message: 'SUCESS',
                data: user
            })
        } catch (e) {
            reject(e)
        }
    })
}

const changePassword = (id, oldPassword, newPassword) => {
    return new Promise(async (resolve, reject) => {
        try {

            //tìm user cần đổi mật khẩu
            const user = await User.findOne({ _id: id });
            if (user === null) {
                return resolve({
                    status: 'ERR',
                    message: 'The user is not defined'
                });
            }

            // Compare password cũ với password lưu trên hệ thống
            const isMatch = bcrypt.compareSync(oldPassword, user.password);
            if (!isMatch) {
                return resolve({
                    status: 'ERR',
                    message: 'The old password is incorrect'
                });
            }
            
            const hash = bcrypt.hashSync(newPassword, 10);
            user.password = hash;
            await user.save();

            resolve({
                status: 'OK',
                message: 'Password changed successfully'
            });
        } catch (e) {
            reject(e);
        }
    });
}



const generateResetToken = async (user) => {
    return new Promise((resolve, reject) => {
        crypto.randomBytes(20, (err, buffer) => {
            if (err) {
                return reject(err);
            }
            const token = buffer.toString('hex');
            const resetTokenExpiry = Date.now() + 3600000; // 1 hour

            user.resetPasswordToken = token;
            user.resetPasswordExpires = resetTokenExpiry;

            user.save((err) => {
                if (err) {
                    return reject(err);
                }
                resolve(token);
            });
        });
    });
};

const sendResetEmail = (user, token, req) => {
    return new Promise((resolve, reject) => {
        const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: {
                user: process.env.MAIL_ACCOUNT,
                pass: process.env.MAIL_PASSWORD,
            }
        });

        const mailOptions = {
            to: user.email,
            from: process.env.MAIL_ACCOUNT,
            subject: 'Password Reset',
            text: `You are receiving this because you (or someone else) have requested the reset of the password for your account.\n\n
                   Please click on the following link, or paste this into your browser to complete the process:\n\n
                   http://localhost:3002/reset/${token}\n\n
                   If you did not request this, please ignore this email and your password will remain unchanged.\n`
        };

        transporter.sendMail(mailOptions, (err, response) => {
            if (err) {
                return reject(err);
            }
            resolve(response);
        });
    });
};

const requestPasswordReset = (email, req) => {
    return new Promise(async (resolve, reject) => {
        try {
            const user = await User.findOne({ email: email });
            if (!user) {
                return resolve({
                    status: 'ERR',
                    message: 'No account with that email address exists.'
                });
            }

            const token = await generateResetToken(user);
            await sendResetEmail(user, token, req);

            resolve({
                status: 'OK',
                message: 'Password reset email has been sent.'
            });
        } catch (e) {
            reject(e);
        }
    });
};

const resetPassword = (token, newPassword) => {
    return new Promise(async (resolve, reject) => {
        try {
            const user = await User.findOne({
                resetPasswordToken: token,
                resetPasswordExpires: { $gt: Date.now() }
            });

            if (!user) {
                return resolve({
                    status: 'ERR',
                    message: 'Password reset token is invalid or has expired.'
                });
            }

            const hash = bcrypt.hashSync(newPassword, 10);
            user.password = hash;
            user.resetPasswordToken = undefined;
            user.resetPasswordExpires = undefined;

            await user.save();

            resolve({
                status: 'OK',
                message: 'Password has been reset successfully.'
            });
        } catch (e) {
            reject(e);
        }
    });
};

module.exports = {
    createUser,
    loginUser,
    updateUser,
    deleteUser,
    getAllUser,
    getDetailsUser,
    deleteManyUser,
    changePassword,
    requestPasswordReset,
    resetPassword,
}
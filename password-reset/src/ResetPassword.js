import React, { useState } from 'react';
import {  useParams } from 'react-router-dom';
import './ResetPassword.css';

const ResetPassword = () => {
  const { token } = useParams(); // Lấy token từ URL
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState(''); // Thêm trạng thái thông báo thành công


  const handleSubmit = async (e) => {
    e.preventDefault();
    if (password !== confirmPassword) {
      setError("Passwords do not match");
      return;
    }

    try {
      const response = await fetch('http://localhost:3001/api/user/reset-password', { // URL của API
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token: token, newPassword: password }),
      });
      

      const data = await response.json();
      console.log(data);
      if (response.ok) {
        setSuccess("Password reset successfully!"); // Thiết lập thông báo thành công
        // setTimeout(() => {
        //   navigate('/login'); // Chuyển hướng đến trang login sau 3 giây
        // }, 3000); // Thay đổi thời gian delay nếu cần
      } else {
        setError(data.message || 'Failed to reset password'); // Hiển thị lỗi nếu có
        setSuccess(''); // Xóa thông báo thành công nếu có lỗi
      }
    } catch (error) {
      setError("An error occurred. Please try again.");
      setSuccess(''); // Xóa thông báo thành công nếu có lỗi
    }
  };

  return (
    <div className="reset-password-container">
      <h2>Reset Password</h2>
      {error && <p className="error-message">{error}</p>}
      {success && <p className="success-message">{success}</p>} {/* Hiển thị thông báo thành công */}
      <form onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="password">New Password:</label>
          <input
            type="password"
            id="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <div className="form-group">
          <label htmlFor="confirmPassword">Confirm Password:</label>
          <input
            type="password"
            id="confirmPassword"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit">Reset Password</button>
      </form>
    </div>
  );
};

export default ResetPassword;

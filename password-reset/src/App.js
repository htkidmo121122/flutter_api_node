import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import ResetPassword from './ResetPassword';// Giả định bạn có một component Login

const App = () => {
  return (

      <Routes>
        <Route path="/reset/:token" element={<ResetPassword />} />

      </Routes>

  );
};

export default App;

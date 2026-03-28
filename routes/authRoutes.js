const express = require('express');
const bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');
const dotenv = require('dotenv');
const db = require('../config/db');

dotenv.config();

const router = express.Router();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
});

// LOGIN
router.post('/login', (req, res) => {
  const { email, password } = req.body;

  const sql = 'SELECT * FROM users WHERE email = ?';

  db.query(sql, [email], async (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Database error' });
    }

    if (result.length === 0) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }

    const user = result[0];

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid email or password' });
    }
    req.session.userId = user.user_id;
    req.session.role = user.role;

    if (user.is_first_login === 1) {
      return res.json({
        message: 'First login - change password required',
        redirect: '/firstchangepassword.html'
      });
    }

    res.json({
      message: 'Login successful',
      redirect: '/dashboard.html'
    });
  });
});

// SEND OTP
router.post('/forgot-password', (req, res) => {
  const { email } = req.body;

  db.query(
    'SELECT * FROM users WHERE email = ?',
    [email],
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: 'Database error' });
      }

      if (result.length === 0) {
        return res.status(400).json({ message: 'Email not found' });
      }

      const otp = Math.floor(100000 + Math.random() * 900000).toString();
      const expiry = new Date(Date.now() + 10 * 60 * 1000);

      db.query(
        'UPDATE users SET otp_code = ?, otp_expiry = ? WHERE email = ?',
        [otp, expiry, email],
        (err) => {
          if (err) {
            return res.status(500).json({ message: 'Could not save OTP' });
          }

          const mailOptions = {
            from: process.env.EMAIL_USER,
            to: email,
            subject: 'Password Reset OTP',
            text: `Your OTP is ${otp}. It is valid for 10 minutes.`
          };

          transporter.sendMail(mailOptions, (error) => {
            if (error) {
              return res.status(500).json({ message: 'Error sending OTP email' });
            }

            res.json({
              message: 'OTP sent successfully'
            });
          });
        }
      );
    }
  );
});

// VERIFY OTP
router.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;

  db.query(
    'SELECT * FROM users WHERE email = ? AND otp_code = ?',
    [email, otp],
    (err, result) => {
      if (err) {
        return res.status(500).json({ message: 'Database error' });
      }

      if (result.length === 0) {
        return res.status(400).json({ message: 'Invalid OTP' });
      }

      const user = result[0];

      if (new Date() > new Date(user.otp_expiry)) {
        return res.status(400).json({ message: 'OTP expired' });
      }

      res.json({
        message: 'OTP verified successfully'
      });
    }
     );
});

// RESET PASSWORD
router.post('/reset-password', async (req, res) => {
  const { email, newPassword } = req.body;

  const hashedPassword = await bcrypt.hash(newPassword, 10);

  db.query(
    'UPDATE users SET password = ?, otp_code = NULL, otp_expiry = NULL WHERE email = ?',
    [hashedPassword, email],
    (err) => {
      if (err) {
        return res.status(500).json({ message: 'Could not reset password' });
      }

      res.json({
        message: 'Password updated successfully'
      });
    }
  );
});

// LOGOUT
router.get('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      return res.status(500).json({ message: 'Logout failed' });
    }

    res.json({ message: 'Logout successful' });
  });
});

module.exports = router;
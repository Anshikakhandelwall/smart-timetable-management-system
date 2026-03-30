const express = require('express');
const session = require('express-session');
const dotenv = require('dotenv');
const path = require('path');
const port =3000;
const cors = require('cors');

const authRoutes = require('./routes/authRoutes');

dotenv.config();

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false
  })
);

app.use(express.static(path.join(__dirname, 'public')));

app.use('/api/auth', authRoutes);

app.listen(3000, () => {
  console.log('Server running on port 3000');
});
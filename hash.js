const bcrypt = require('bcrypt');

async function generateHashes() {
  console.log(await bcrypt.hash('Rahul@123', 10));
  console.log(await bcrypt.hash('Priya@456', 10));
  console.log(await bcrypt.hash('Admin@789', 10));
}

generateHashes();
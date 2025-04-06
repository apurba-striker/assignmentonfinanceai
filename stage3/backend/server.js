const express = require('express');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 5000;

app.use(cors());

app.get('/api/data', (req, res) => {
  res.json({ message: 'Hello from OnFinance AI backend!' });
});

app.get('/healthz', (req, res) => res.send('OK'));
app.get('/readiness', (req, res) => res.send('Ready'));

app.listen(port, () => console.log(`Backend running on port ${port}`));

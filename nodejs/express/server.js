const express = require('express');
const { body, param, validationResult } = require('express-validator');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());

let users = [
  { id: 1, name: "John Doe", email: "john@example.com" },
  { id: 2, name: "Jane Smith", email: "jane@example.com" }
];

let nextId = 3;

const handleValidationErrors = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ error: errors.array()[0].msg });
  }
  next();
};

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: Math.floor(Date.now() / 1000),
    service: 'nodejs-api-server'
  });
});

app.get('/users', (req, res) => {
  res.json({
    users: users,
    total: users.length
  });
});

app.get('/users/:id', 
  param('id').isInt({ min: 1 }).withMessage('ID must be a positive integer'),
  handleValidationErrors,
  (req, res) => {
    const id = parseInt(req.params.id);
    const user = users.find(u => u.id === id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json(user);
  }
);

app.post('/users',
  body('name').notEmpty().withMessage('Name is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  handleValidationErrors,
  (req, res) => {
    const { name, email } = req.body;
    
    const newUser = {
      id: nextId++,
      name,
      email
    };
    
    users.push(newUser);
    res.status(201).json(newUser);
  }
);

app.put('/users/:id',
  param('id').isInt({ min: 1 }).withMessage('ID must be a positive integer'),
  body('name').optional().notEmpty().withMessage('Name cannot be empty'),
  body('email').optional().isEmail().withMessage('Valid email is required'),
  handleValidationErrors,
  (req, res) => {
    const id = parseInt(req.params.id);
    const userIndex = users.findIndex(u => u.id === id);
    
    if (userIndex === -1) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    const { name, email } = req.body;
    
    if (name !== undefined) {
      users[userIndex].name = name;
    }
    if (email !== undefined) {
      users[userIndex].email = email;
    }
    
    res.json(users[userIndex]);
  }
);

app.delete('/users/:id',
  param('id').isInt({ min: 1 }).withMessage('ID must be a positive integer'),
  handleValidationErrors,
  (req, res) => {
    const id = parseInt(req.params.id);
    const userIndex = users.findIndex(u => u.id === id);
    
    if (userIndex === -1) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    users.splice(userIndex, 1);
    res.json({ message: 'User deleted successfully' });
  }
);

app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Internal server error' });
});

const server = app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = { app, server };
const request = require('supertest');
const { app, server } = require('./server');

describe('API Server', () => {
  afterAll(async () => {
    server.close();
  });

  describe('GET /health', () => {
    it('should return health status', async () => {
      const response = await request(app).get('/health');
      
      expect(response.status).toBe(200);
      expect(response.body.status).toBe('healthy');
      expect(response.body.service).toBe('nodejs-api-server');
      expect(response.body.timestamp).toBeDefined();
    });
  });

  describe('GET /users', () => {
    it('should return all users', async () => {
      const response = await request(app).get('/users');
      
      expect(response.status).toBe(200);
      expect(response.body.users).toHaveLength(2);
      expect(response.body.total).toBe(2);
    });
  });

  describe('GET /users/:id', () => {
    it('should return a specific user', async () => {
      const response = await request(app).get('/users/1');
      
      expect(response.status).toBe(200);
      expect(response.body.id).toBe(1);
      expect(response.body.name).toBe('John Doe');
      expect(response.body.email).toBe('john@example.com');
    });

    it('should return 404 for non-existent user', async () => {
      const response = await request(app).get('/users/999');
      
      expect(response.status).toBe(404);
      expect(response.body.error).toBe('User not found');
    });

    it('should return 400 for invalid user id', async () => {
      const response = await request(app).get('/users/invalid');
      
      expect(response.status).toBe(400);
    });
  });

  describe('POST /users', () => {
    it('should create a new user', async () => {
      const newUser = {
        name: 'Test User',
        email: 'test@example.com'
      };

      const response = await request(app)
        .post('/users')
        .send(newUser);
      
      expect(response.status).toBe(201);
      expect(response.body.name).toBe('Test User');
      expect(response.body.email).toBe('test@example.com');
      expect(response.body.id).toBeDefined();
    });

    it('should return 400 for missing name', async () => {
      const newUser = {
        email: 'test@example.com'
      };

      const response = await request(app)
        .post('/users')
        .send(newUser);
      
      expect(response.status).toBe(400);
    });

    it('should return 400 for invalid email', async () => {
      const newUser = {
        name: 'Test User',
        email: 'invalid-email'
      };

      const response = await request(app)
        .post('/users')
        .send(newUser);
      
      expect(response.status).toBe(400);
    });
  });

  describe('PUT /users/:id', () => {
    it('should update a user', async () => {
      const updateData = {
        name: 'Updated Name'
      };

      const response = await request(app)
        .put('/users/1')
        .send(updateData);
      
      expect(response.status).toBe(200);
      expect(response.body.name).toBe('Updated Name');
      expect(response.body.email).toBe('john@example.com');
    });

    it('should return 404 for non-existent user', async () => {
      const updateData = {
        name: 'Updated Name'
      };

      const response = await request(app)
        .put('/users/999')
        .send(updateData);
      
      expect(response.status).toBe(404);
    });
  });

  describe('DELETE /users/:id', () => {
    it('should delete a user', async () => {
      const response = await request(app).delete('/users/2');
      
      expect(response.status).toBe(200);
      expect(response.body.message).toBe('User deleted successfully');
    });

    it('should return 404 for non-existent user', async () => {
      const response = await request(app).delete('/users/999');
      
      expect(response.status).toBe(404);
    });
  });
});
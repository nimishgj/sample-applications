<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Tests\TestCase;

class UserControllerTest extends TestCase
{
    /**
     * Test health check endpoint.
     */
    public function test_health_check(): void
    {
        $response = $this->get('/health');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'status',
                    'timestamp',
                    'service'
                ]);
    }

    /**
     * Test get all users.
     */
    public function test_get_all_users(): void
    {
        $response = $this->get('/users');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'users' => [
                        '*' => [
                            'id',
                            'name',
                            'email'
                        ]
                    ],
                    'total'
                ]);
    }

    /**
     * Test get user by ID.
     */
    public function test_get_user_by_id(): void
    {
        $response = $this->get('/users/1');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'id',
                    'name',
                    'email'
                ]);
    }

    /**
     * Test get non-existent user.
     */
    public function test_get_nonexistent_user(): void
    {
        $response = $this->get('/users/999');

        $response->assertStatus(404)
                ->assertJson([
                    'error' => 'User not found'
                ]);
    }

    /**
     * Test create user.
     */
    public function test_create_user(): void
    {
        $userData = [
            'name' => 'Test User',
            'email' => 'test@example.com'
        ];

        $response = $this->post('/users', $userData);

        $response->assertStatus(201)
                ->assertJsonStructure([
                    'id',
                    'name',
                    'email'
                ])
                ->assertJson([
                    'name' => 'Test User',
                    'email' => 'test@example.com'
                ]);
    }

    /**
     * Test create user with invalid data.
     */
    public function test_create_user_with_invalid_data(): void
    {
        $userData = [
            'name' => '',
            'email' => 'invalid-email'
        ];

        $response = $this->post('/users', $userData);

        $response->assertStatus(400)
                ->assertJsonStructure([
                    'error'
                ]);
    }

    /**
     * Test update user.
     */
    public function test_update_user(): void
    {
        $updateData = [
            'name' => 'Updated Name'
        ];

        $response = $this->put('/users/1', $updateData);

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'id',
                    'name',
                    'email'
                ])
                ->assertJson([
                    'name' => 'Updated Name'
                ]);
    }

    /**
     * Test update non-existent user.
     */
    public function test_update_nonexistent_user(): void
    {
        $updateData = [
            'name' => 'Updated Name'
        ];

        $response = $this->put('/users/999', $updateData);

        $response->assertStatus(404)
                ->assertJson([
                    'error' => 'User not found'
                ]);
    }

    /**
     * Test delete user.
     */
    public function test_delete_user(): void
    {
        $response = $this->delete('/users/2');

        $response->assertStatus(200)
                ->assertJson([
                    'message' => 'User deleted successfully'
                ]);
    }

    /**
     * Test delete non-existent user.
     */
    public function test_delete_nonexistent_user(): void
    {
        $response = $this->delete('/users/999');

        $response->assertStatus(404)
                ->assertJson([
                    'error' => 'User not found'
                ]);
    }
}
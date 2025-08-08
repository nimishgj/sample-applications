<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    private static array $users = [
        ['id' => 1, 'name' => 'John Doe', 'email' => 'john@example.com'],
        ['id' => 2, 'name' => 'Jane Smith', 'email' => 'jane@example.com'],
    ];

    private static int $nextId = 3;

    /**
     * Health check endpoint
     */
    public function health(): JsonResponse
    {
        return response()->json([
            'status' => 'healthy',
            'timestamp' => time(),
            'service' => 'laravel-api-server'
        ]);
    }

    /**
     * Get all users
     */
    public function index(): JsonResponse
    {
        return response()->json([
            'users' => self::$users,
            'total' => count(self::$users)
        ]);
    }

    /**
     * Get user by ID
     */
    public function show(int $id): JsonResponse
    {
        $user = $this->findUserById($id);
        
        if (!$user) {
            return response()->json(['error' => 'User not found'], 404);
        }

        return response()->json($user);
    }

    /**
     * Create a new user
     */
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => $validator->errors()->first()
            ], 400);
        }

        $user = [
            'id' => self::$nextId++,
            'name' => $request->input('name'),
            'email' => $request->input('email'),
        ];

        self::$users[] = $user;

        return response()->json($user, 201);
    }

    /**
     * Update an existing user
     */
    public function update(Request $request, int $id): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|email|max:255',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'error' => $validator->errors()->first()
            ], 400);
        }

        $userIndex = $this->findUserIndexById($id);
        
        if ($userIndex === -1) {
            return response()->json(['error' => 'User not found'], 404);
        }

        if ($request->has('name')) {
            self::$users[$userIndex]['name'] = $request->input('name');
        }

        if ($request->has('email')) {
            self::$users[$userIndex]['email'] = $request->input('email');
        }

        return response()->json(self::$users[$userIndex]);
    }

    /**
     * Delete a user
     */
    public function destroy(int $id): JsonResponse
    {
        $userIndex = $this->findUserIndexById($id);
        
        if ($userIndex === -1) {
            return response()->json(['error' => 'User not found'], 404);
        }

        array_splice(self::$users, $userIndex, 1);

        return response()->json(['message' => 'User deleted successfully']);
    }

    /**
     * Find user by ID
     */
    private function findUserById(int $id): ?array
    {
        foreach (self::$users as $user) {
            if ($user['id'] === $id) {
                return $user;
            }
        }
        return null;
    }

    /**
     * Find user index by ID
     */
    private function findUserIndexById(int $id): int
    {
        foreach (self::$users as $index => $user) {
            if ($user['id'] === $id) {
                return $index;
            }
        }
        return -1;
    }
}
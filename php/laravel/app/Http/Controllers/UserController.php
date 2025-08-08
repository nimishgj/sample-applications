<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    private array $users = [
        ['id' => 1, 'name' => 'John Doe', 'email' => 'john@example.com'],
        ['id' => 2, 'name' => 'Jane Smith', 'email' => 'jane@example.com'],
    ];

    private int $nextId = 3;

    public function __construct()
    {
        if (session()->has('users')) {
            $this->users = session('users');
            $this->nextId = session('nextId', 3);
        }
    }

    private function saveToSession()
    {
        session(['users' => $this->users, 'nextId' => $this->nextId]);
    }

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
            'users' => $this->users,
            'total' => count($this->users)
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
            'id' => $this->nextId++,
            'name' => $request->input('name'),
            'email' => $request->input('email'),
        ];

        $this->users[] = $user;
        $this->saveToSession();

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
            $this->users[$userIndex]['name'] = $request->input('name');
        }

        if ($request->has('email')) {
            $this->users[$userIndex]['email'] = $request->input('email');
        }

        $this->saveToSession();

        return response()->json($this->users[$userIndex]);
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

        array_splice($this->users, $userIndex, 1);
        $this->saveToSession();

        return response()->json(['message' => 'User deleted successfully']);
    }

    /**
     * Find user by ID
     */
    private function findUserById(int $id): ?array
    {
        foreach ($this->users as $user) {
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
        foreach ($this->users as $index => $user) {
            if ($user['id'] === $id) {
                return $index;
            }
        }
        return -1;
    }
}
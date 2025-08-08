package com.example.apiserver.service;

import com.example.apiserver.model.User;
import com.example.apiserver.dto.CreateUserRequest;
import com.example.apiserver.dto.UpdateUserRequest;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;

@Service
public class UserService {
    private final List<User> users = new ArrayList<>();
    private final AtomicInteger nextId = new AtomicInteger(3);

    public UserService() {
        users.add(new User(1, "John Doe", "john@example.com"));
        users.add(new User(2, "Jane Smith", "jane@example.com"));
    }

    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }

    public Optional<User> getUserById(int id) {
        return users.stream().filter(user -> user.getId() == id).findFirst();
    }

    public User createUser(CreateUserRequest request) {
        User user = new User(nextId.getAndIncrement(), request.getName(), request.getEmail());
        users.add(user);
        return user;
    }

    public Optional<User> updateUser(int id, UpdateUserRequest request) {
        Optional<User> userOptional = getUserById(id);
        if (userOptional.isPresent()) {
            User user = userOptional.get();
            if (request.getName() != null && !request.getName().isEmpty()) {
                user.setName(request.getName());
            }
            if (request.getEmail() != null && !request.getEmail().isEmpty()) {
                user.setEmail(request.getEmail());
            }
            return Optional.of(user);
        }
        return Optional.empty();
    }

    public boolean deleteUser(int id) {
        return users.removeIf(user -> user.getId() == id);
    }
}
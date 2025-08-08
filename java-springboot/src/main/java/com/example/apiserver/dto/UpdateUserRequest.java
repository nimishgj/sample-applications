package com.example.apiserver.dto;

import jakarta.validation.constraints.Email;

public class UpdateUserRequest {
    private String name;

    @Email(message = "Valid email is required")
    private String email;

    public UpdateUserRequest() {}

    public UpdateUserRequest(String name, String email) {
        this.name = name;
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
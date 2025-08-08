package com.example.apiserver.controller;

import com.example.apiserver.dto.CreateUserRequest;
import com.example.apiserver.dto.UpdateUserRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureTestMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureTestMvc
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void testHealthCheck() throws Exception {
        mockMvc.perform(get("/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("healthy"))
                .andExpect(jsonPath("$.service").value("java-api-server"))
                .andExpect(jsonPath("$.timestamp").exists());
    }

    @Test
    public void testGetAllUsers() throws Exception {
        mockMvc.perform(get("/users"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.users").isArray())
                .andExpect(jsonPath("$.total").value(2));
    }

    @Test
    public void testGetUserById() throws Exception {
        mockMvc.perform(get("/users/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.name").value("John Doe"))
                .andExpect(jsonPath("$.email").value("john@example.com"));
    }

    @Test
    public void testGetUserByIdNotFound() throws Exception {
        mockMvc.perform(get("/users/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("User not found"));
    }

    @Test
    public void testCreateUser() throws Exception {
        CreateUserRequest request = new CreateUserRequest("Test User", "test@example.com");
        
        mockMvc.perform(post("/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.name").value("Test User"))
                .andExpect(jsonPath("$.email").value("test@example.com"))
                .andExpect(jsonPath("$.id").exists());
    }

    @Test
    public void testCreateUserInvalidEmail() throws Exception {
        CreateUserRequest request = new CreateUserRequest("Test User", "invalid-email");
        
        mockMvc.perform(post("/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    public void testUpdateUser() throws Exception {
        UpdateUserRequest request = new UpdateUserRequest("Updated Name", null);
        
        mockMvc.perform(put("/users/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("Updated Name"))
                .andExpect(jsonPath("$.email").value("john@example.com"));
    }

    @Test
    public void testUpdateUserNotFound() throws Exception {
        UpdateUserRequest request = new UpdateUserRequest("Updated Name", null);
        
        mockMvc.perform(put("/users/999")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isNotFound());
    }

    @Test
    public void testDeleteUser() throws Exception {
        mockMvc.perform(delete("/users/2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("User deleted successfully"));
    }

    @Test
    public void testDeleteUserNotFound() throws Exception {
        mockMvc.perform(delete("/users/999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error").value("User not found"));
    }
}
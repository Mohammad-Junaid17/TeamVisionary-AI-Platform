package com.aiplatform.model;

public class User {
    private int id;
    private String name;
    private String email;
    private String role; // "ADMIN" or "RESEARCHER"

    public User(int id, String name, String email, String role) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.role = role;
    }

    // Getters (needed so JSP pages can read the data)
    public int getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getRole() { return role; }
}
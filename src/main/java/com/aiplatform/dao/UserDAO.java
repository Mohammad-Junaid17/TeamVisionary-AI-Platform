package com.aiplatform.dao;

import com.aiplatform.model.User;
import com.aiplatform.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // 1. LOGIN (Existing)
    public User login(String email, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new User(rs.getInt("id"), rs.getString("name"), rs.getString("email"), rs.getString("role"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return user;
    }

    // 2. GET ALL USERS (New - Fixes Admin Dashboard error)
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM users")) {
            while (rs.next()) {
                list.add(new User(rs.getInt("id"), rs.getString("name"), rs.getString("email"), rs.getString("role")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 3. ADD USER (New - Fixes "addUser" error in AdminController)
    public boolean addUser(String name, String email, String password, String role) {
        String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 4. DELETE USER (New - Fixes "deleteUser" error in AdminController)
    public boolean deleteUser(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=?")) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 5. UPDATE PROFILE (New - Fixes Researcher Update)
    public boolean updateProfile(int userId, String newName, String newPassword) {
        String sql = "UPDATE users SET name = ?, password = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setString(2, newPassword);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 6. GET USER ID BY EMAIL (New - Fixes Collaboration)
    public int getUserIdByEmail(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("id");
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }
}
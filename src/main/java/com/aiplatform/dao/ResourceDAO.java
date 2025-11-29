package com.aiplatform.dao;

import com.aiplatform.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResourceDAO {

    // Admin: Add a new resource (GPU/Storage)
    public boolean addResource(String type, String capacity) {
        String sql = "INSERT INTO resources (type, capacity) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, type);
            ps.setString(2, capacity);

            // executeUpdate returns the number of rows affected (should be 1)
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Admin: Get list of all resources to show in the dashboard
    public List<String[]> getAllResources() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT * FROM resources";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while(rs.next()) {
                // Storing data in a simple String array for the table
                String[] res = {
                        String.valueOf(rs.getInt("id")),
                        rs.getString("type"),
                        rs.getString("capacity"),
                        rs.getString("status")
                };
                list.add(res);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
package com.aiplatform.dao;

import com.aiplatform.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DatasetDAO {

    // 1. Add new dataset
    public boolean addDataset(String name, String desc, String fileName, int userId) {
        String sql = "INSERT INTO datasets (name, description, file_name, researcher_id) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, desc);
            ps.setString(3, fileName);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 2. Get datasets for a specific researcher
    public List<String[]> getMyDatasets(int userId) {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT * FROM datasets WHERE researcher_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[]{ rs.getString("id"), rs.getString("name"), rs.getString("description"), rs.getString("file_name") });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 3. NEW: Get ALL datasets (For Admin Dashboard)
    public List<String[]> getAllDatasets() {
        List<String[]> list = new ArrayList<>();
        // We JOIN with the users table to show the Admin WHO uploaded the file
        String sql = "SELECT d.id, d.name, d.description, d.file_name, u.name as researcher_name " +
                "FROM datasets d JOIN users u ON d.researcher_id = u.id";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new String[]{
                        rs.getString("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("file_name"),
                        rs.getString("researcher_name") // Index 4 is the Researcher's Name
                });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 4. Delete a dataset
    public boolean deleteDataset(int id) {
        String sql = "DELETE FROM datasets WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 5. Update dataset details
    public boolean updateDataset(int id, String name, String description) {
        String sql = "UPDATE datasets SET name = ?, description = ? WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }
}
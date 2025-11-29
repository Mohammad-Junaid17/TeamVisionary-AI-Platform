package com.aiplatform.dao;

import com.aiplatform.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProjectDAO {

    // 1. Create Project
    public boolean addProject(String title, String description) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO projects (title, description) VALUES (?, ?)")) {
            ps.setString(1, title);
            ps.setString(2, description);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 2. List Projects
    public List<String[]> getAllProjects() {
        List<String[]> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM projects")) {
            while (rs.next()) {
                list.add(new String[]{ rs.getString("id"), rs.getString("title"), rs.getString("description") });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 3. Add Project Member (THIS WAS MISSING!)
    public boolean addProjectMember(int projectId, int userId) {
        String sql = "INSERT INTO project_members (project_id, user_id) VALUES (?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, projectId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
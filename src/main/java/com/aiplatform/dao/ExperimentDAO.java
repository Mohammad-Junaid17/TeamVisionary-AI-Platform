package com.aiplatform.dao;

import com.aiplatform.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExperimentDAO {

    // 1. Start Training
    public boolean startTraining(int userId, String model, String params) {
        // We let the Database handle the timestamp automatically
        String sql = "INSERT INTO experiments (researcher_id, model_name, parameters, status, accuracy) VALUES (?, ?, ?, 'Training...', '--')";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, model);
            ps.setString(3, params);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // 2. NEW: Simulate "Finishing" the training
    // This runs a clever SQL command: "Find any job older than 15 seconds that is still training, and finish it with a random score."
    public void checkAndCompleteExperiments() {
        String sql = "UPDATE experiments " +
                "SET status = 'Completed', " +
                "    accuracy = CONCAT(ROUND(80 + (RAND() * 19), 2), '%') " +
                "WHERE status = 'Training...' " +
                "AND start_time < DATE_SUB(NOW(), INTERVAL 15 SECOND)";

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            st.executeUpdate(sql);
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 3. Get Experiments (Calls the check method first!)
    public List<String[]> getMyExperiments(int userId) {

        // Trigger the simulation check before fetching data
        checkAndCompleteExperiments();

        List<String[]> list = new ArrayList<>();
        String sql = "SELECT * FROM experiments WHERE researcher_id = ? ORDER BY start_time DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[]{
                        rs.getString("id"),
                        rs.getString("model_name"),
                        rs.getString("parameters"),
                        rs.getString("status"),
                        rs.getString("accuracy")
                });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
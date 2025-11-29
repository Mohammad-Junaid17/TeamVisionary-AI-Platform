package com.aiplatform.dao;

import com.aiplatform.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsageDAO {
    // Usage Monitoring - Get Stats
    public List<String[]> getUsageStats() {
        List<String[]> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM usage_logs ORDER BY timestamp DESC LIMIT 10")) {
            while (rs.next()) {
                list.add(new String[]{ rs.getString("resource_type"), rs.getString("usage_value"), rs.getString("timestamp") });
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
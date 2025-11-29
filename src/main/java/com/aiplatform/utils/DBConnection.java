package com.aiplatform.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // ⚠️ CHANGE THESE TO MATCH YOUR MYSQL SETUP
    private static final String URL = "jdbc:mysql://localhost:3306/ai_platform";
    private static final String USER = "root";
    private static final String PASSWORD = "1234"; // <--- Put your MySQL password here

    public static Connection getConnection() {
        Connection con = null;
        try {
            // This loads the driver we just added in pom.xml
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Database Connection Failed!");
        }
        return con;
    }
}
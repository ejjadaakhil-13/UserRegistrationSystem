package com.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    public static Connection initializeDatabase() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/userdb";
        String username = "root";
        String password = "password"; // replace with your MySQL password

        return DriverManager.getConnection(url, username, password);
    }
}

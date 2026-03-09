package com.voting;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/votingdb";
    private static final String USERNAME = "root"; 
    private static final String PASSWORD = "";     

    public static Connection getConnection() throws SQLException, ClassNotFoundException {

        Class.forName("com.mysql.cj.jdbc.Driver");
  
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}

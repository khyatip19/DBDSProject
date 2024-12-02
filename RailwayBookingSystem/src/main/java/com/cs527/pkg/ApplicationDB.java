package com.cs527.pkg;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ApplicationDB {
	
	public ApplicationDB(){
		
	}

	public Connection getConnection(){
		
		//Create a connection string
		String connectionUrl = "jdbc:mysql://localhost:3306/RailwayBookingSystem?serverTimezone=UTC";
		Connection connection = null;
		
		try {
			//Load JDBC driver - new jdbc driver
			Class.forName("com.mysql.cj.jdbc.Driver").newInstance();
		 } catch (InstantiationException | IllegalAccessException | ClassNotFoundException e) {
	            // Print stack trace for any driver loading issues
	            e.printStackTrace();
	    }
		try {
			//Create a connection to your DB
			connection = DriverManager.getConnection(connectionUrl,"root", "mysqlroot");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return connection;
		
	}
	
	public void closeConnection(Connection connection){
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	
	
	
	public static void main(String[] args) {
		ApplicationDB dao = new ApplicationDB();
		Connection connection = dao.getConnection();
		
		System.out.println(connection);		
		dao.closeConnection(connection);
	}
	
	

}

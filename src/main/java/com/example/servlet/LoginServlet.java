package com.example.servlet;

import org.mindrot.jbcrypt.BCrypt;

import com.example.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection conn = DatabaseConnection.initializeDatabase();
            PreparedStatement ps = conn.prepareStatement("SELECT name, password FROM users WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (BCrypt.checkpw(password, hashedPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", rs.getString("name"));
                    session.setAttribute("email", email);
                    response.sendRedirect("dashboard");
                } else {
                    response.sendRedirect("signin.jsp?error=Invalid email or password");
                }
            } else {
                response.sendRedirect("signin.jsp?error=Invalid email or password");
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

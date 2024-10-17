package com.example.servlet;
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

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String currentEmail = (String) session.getAttribute("email");
        
        // Get form data
        String newName = request.getParameter("name");
        String newEmail = request.getParameter("email");

        // Validate input
        if (newName == null || newEmail == null || 
            newName.trim().isEmpty() || newEmail.trim().isEmpty()) {
            response.sendRedirect("editProfile.jsp?error=" + 
                encodeURIComponent("All fields are required"));
            return;
        }

        // Clean input
        newName = newName.trim();
        newEmail = newEmail.trim();

        Connection conn = null;
        PreparedStatement checkEmailPs = null;
        PreparedStatement updatePs = null;
        ResultSet rs = null;

        try {
            conn = DatabaseConnection.initializeDatabase();
            conn.setAutoCommit(false); // Start transaction

            // Only check for email existence if email is being changed
            if (!newEmail.equals(currentEmail)) {
                // Check if new email already exists
                checkEmailPs = conn.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE email = ? AND email != ?"
                );
                checkEmailPs.setString(1, newEmail);
                checkEmailPs.setString(2, currentEmail);
                rs = checkEmailPs.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    response.sendRedirect("editProfile.jsp?error=" + 
                        encodeURIComponent("Email already exists"));
                    return;
                }
            }

            // Update user profile
            updatePs = conn.prepareStatement(
                "UPDATE users SET name = ?, email = ? WHERE email = ?"
            );
            updatePs.setString(1, newName);
            updatePs.setString(2, newEmail);
            updatePs.setString(3, currentEmail);
            
            int rowsAffected = updatePs.executeUpdate();
            
            if (rowsAffected > 0) {
                // Update session attributes
                session.setAttribute("username", newName);
                session.setAttribute("email", newEmail);
                
                // Commit transaction
                conn.commit();
                
                response.sendRedirect("editProfile.jsp?success=" + 
                    encodeURIComponent("Profile updated successfully"));
            } else {
                conn.rollback();
                response.sendRedirect("editProfile.jsp?error=" + 
                    encodeURIComponent("Update failed"));
            }

        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("editProfile.jsp?error=" + 
                encodeURIComponent("Database error occurred"));
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkEmailPs != null) checkEmailPs.close();
                if (updatePs != null) updatePs.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String encodeURIComponent(String s) {
        return java.net.URLEncoder.encode(s, java.nio.charset.StandardCharsets.UTF_8);
    }
}
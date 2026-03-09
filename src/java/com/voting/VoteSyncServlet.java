package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class VoteSyncServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Step 1: Reset all candidate votes to 0
            String resetSql = "UPDATE candidates SET votes = 0";
            PreparedStatement resetStmt = conn.prepareStatement(resetSql);
            resetStmt.executeUpdate();
            resetStmt.close();

            // Step 2: Count actual votes from votes table for each candidate
            String countSql = "SELECT candidate_id, COUNT(*) as vote_count FROM votes GROUP BY candidate_id";
            PreparedStatement countStmt = conn.prepareStatement(countSql);
            ResultSet rs = countStmt.executeQuery();

            // Step 3: Update candidate votes based on actual counts
            String updateSql = "UPDATE candidates SET votes = ? WHERE id = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);

            while (rs.next()) {
                int candidateId = rs.getInt("candidate_id");
                int voteCount = rs.getInt("vote_count");
                
                updateStmt.setInt(1, voteCount);
                updateStmt.setInt(2, candidateId);
                updateStmt.executeUpdate();
            }

            rs.close();
            countStmt.close();
            updateStmt.close();
            
            conn.commit();
            
            response.sendRedirect("admin-dashboard.jsp?sync=success");
            
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("admin-dashboard.jsp?sync=failed");
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
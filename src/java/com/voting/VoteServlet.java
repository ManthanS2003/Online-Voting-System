package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class VoteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("voterId") == null) {
            response.sendRedirect("voter-login.jsp");
            return;
        }

        int voterId = (Integer) session.getAttribute("voterId");
        String candidateParam = request.getParameter("candidate");
        
        if (candidateParam == null || candidateParam.trim().isEmpty()) {
            response.sendRedirect("user-dashboard.jsp?error=no-candidate");
            return;
        }

        int candidateId = Integer.parseInt(candidateParam);

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // Check if voter has already voted
            PreparedStatement checkStmt = conn.prepareStatement("SELECT status FROM voters WHERE id = ?");
            checkStmt.setInt(1, voterId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("status");
                if ("Voted".equalsIgnoreCase(status)) {
                    rs.close();
                    checkStmt.close();
                    conn.close();
                    response.sendRedirect("DashboardServlet?error=already-voted");
                    return;
                }
            }
            rs.close();
            checkStmt.close();

            // Begin transaction
            conn.setAutoCommit(false);

            // Update voter status
            String updateVoterSql = "UPDATE voters SET status = 'Voted' WHERE id = ?";
            PreparedStatement updateVoterStmt = conn.prepareStatement(updateVoterSql);
            updateVoterStmt.setInt(1, voterId);
            int voterUpdated = updateVoterStmt.executeUpdate();
            updateVoterStmt.close();

            if (voterUpdated == 0) {
                conn.rollback();
                response.sendRedirect("user-dashboard.jsp?error=voter-update-failed");
                return;
            }

            // Record vote
            String recordVoteSql = "INSERT INTO votes (voter_id, candidate_id) VALUES (?, ?)";
            PreparedStatement recordVoteStmt = conn.prepareStatement(recordVoteSql);
            recordVoteStmt.setInt(1, voterId);
            recordVoteStmt.setInt(2, candidateId);
            int voteRecorded = recordVoteStmt.executeUpdate();
            recordVoteStmt.close();

            if (voteRecorded == 0) {
                conn.rollback();
                response.sendRedirect("user-dashboard.jsp?error=vote-record-failed");
                return;
            }

            // Update candidate vote count
            String updateCandidateSql = "UPDATE candidates SET votes = votes + 1 WHERE id = ?";
            PreparedStatement updateCandidateStmt = conn.prepareStatement(updateCandidateSql);
            updateCandidateStmt.setInt(1, candidateId);
            int candidateUpdated = updateCandidateStmt.executeUpdate();
            updateCandidateStmt.close();

            if (candidateUpdated == 0) {
                conn.rollback();
                response.sendRedirect("user-dashboard.jsp?error=candidate-update-failed");
                return;
            }

            // Commit transaction
            conn.commit();
            
            // Redirect to dashboard with success message
            response.sendRedirect("DashboardServlet?vote=success");
            
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("user-dashboard.jsp?error=vote-failed");
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
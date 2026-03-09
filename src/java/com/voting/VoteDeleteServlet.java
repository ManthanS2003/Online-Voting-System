package com.voting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class VoteDeleteServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            response.sendRedirect("admin-login.jsp");
            return;
        }

        String voterIdParam = request.getParameter("voterId");
        if (voterIdParam == null || voterIdParam.trim().isEmpty()) {
            response.sendRedirect("view-voters.jsp?error=novoter");
            return;
        }

        int voterId = Integer.parseInt(voterIdParam);
        Connection conn = null;
        
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String getVoteSql = "SELECT candidate_id FROM votes WHERE voter_id = ?";
            PreparedStatement getVoteStmt = conn.prepareStatement(getVoteSql);
            getVoteStmt.setInt(1, voterId);
            ResultSet rs = getVoteStmt.executeQuery();
            
            int candidateId = -1;
            if (rs.next()) {
                candidateId = rs.getInt("candidate_id");
            }
            rs.close();
            getVoteStmt.close();

            if (candidateId == -1) {
                response.sendRedirect("view-voters.jsp?error=novote");
                return;
            }

            String deleteVoteSql = "DELETE FROM votes WHERE voter_id = ?";
            PreparedStatement deleteVoteStmt = conn.prepareStatement(deleteVoteSql);
            deleteVoteStmt.setInt(1, voterId);
            int votesDeleted = deleteVoteStmt.executeUpdate();
            deleteVoteStmt.close();

            String updateCandidateSql = "UPDATE candidates SET votes = votes - 1 WHERE id = ? AND votes > 0";
            PreparedStatement updateCandidateStmt = conn.prepareStatement(updateCandidateSql);
            updateCandidateStmt.setInt(1, candidateId);
            updateCandidateStmt.executeUpdate();
            updateCandidateStmt.close();

            String updateVoterSql = "UPDATE voters SET status = 'Not Voted' WHERE id = ?";
            PreparedStatement updateVoterStmt = conn.prepareStatement(updateVoterSql);
            updateVoterStmt.setInt(1, voterId);
            updateVoterStmt.executeUpdate();
            updateVoterStmt.close();

            conn.commit();
            response.sendRedirect("view-voters.jsp?delete=success");
            
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (Exception rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("view-voters.jsp?delete=failed");
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
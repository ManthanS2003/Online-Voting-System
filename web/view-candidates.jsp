<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>

<%
// Session validation for admin pages
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session == null || session.getAttribute("adminId") == null) {
    response.sendRedirect("admin-login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate's Vote Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .navbar {
            background-color: #22303c;
        }
        .navbar-brand, .nav-link {
            color: white !important;
        }
        .main-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            padding: 25px;
            margin-top: 20px;
        }
        .table-custom {
            border-collapse: collapse;
            width: 100%;
            border: 1px solid #dee2e6;
        }
        .table-custom th {
            background-color: #2785ff;
            color: white;
            text-align: center;
            padding: 12px;
            border: 1px solid #dee2e6;
        }
        .table-custom td {
            padding: 12px;
            text-align: center;
            border: 1px solid #dee2e6;
        }
        .voter-label {
            text-align: left;
            padding-left: 20px;
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .total-row {
            font-weight: bold;
            background-color: #f2f2f2;
        }
        .email-cell {
            text-align: left;
            padding-left: 20px;
        }
        .candidate-header {
            background-color: #2785ff;
            color: white;
            padding: 10px;
            text-align: center;
            border-radius: 5px;
            margin-bottom: 5px;
        }
        .candidate-name {
            font-weight: bold;
            font-size: 14px;
        }
        .candidate-id {
            font-size: 12px;
            opacity: 0.9;
        }
        
        /* Responsive fixes */
        @media (max-width: 768px) {
            .main-container {
                padding: 15px;
                margin: 10px 0;
            }
            
            .table-custom {
                font-size: 0.875rem;
            }
            
            .table-custom th, .table-custom td {
                padding: 8px 4px;
            }
            
            .candidate-header {
                padding: 5px;
            }
            
            .candidate-name {
                font-size: 0.8rem;
            }
            
            .candidate-id {
                font-size: 0.7rem;
            }
            
            .voter-label {
                padding-left: 10px;
                font-size: 0.8rem;
            }
            
            .email-cell {
                padding-left: 10px;
                font-size: 0.8rem;
                word-break: break-word;
            }
        }
        
        @media (max-width: 576px) {
            .table-custom {
                font-size: 0.75rem;
            }
            
            .table-custom th, .table-custom td {
                padding: 6px 2px;
            }
            
            .container {
                padding: 0 10px;
            }
            
            h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="admin-dashboard.jsp">Home</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <!-- Left side menu -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="admin-dashboard.jsp">Welcome <%= session.getAttribute("adminName") %></a></li>
                    <li class="nav-item"><a class="nav-link" href="admin-profile.jsp">View Admins</a></li>
                    <li class="nav-item"><a class="nav-link" href="view-voters.jsp">View Voters</a></li>
                    <li class="nav-item"><a class="nav-link" href="view-candidates.jsp">View Candidates</a></li>
                </ul>

                <!-- Right side logout -->
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link text-danger fw-bold" href="AdminLogoutServlet">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <h2 class="text-center mb-4">Candidate's Vote Details</h2>
        
        <div class="main-container">
            <%
            try {
                Connection conn = com.voting.DBConnection.getConnection();
                
                // Get all candidates
                Statement stmt = conn.createStatement();
                ResultSet candidates = stmt.executeQuery("SELECT * FROM candidates ORDER BY id");
                
                // Get all votes with voter emails
                Statement voteStmt = conn.createStatement();
                ResultSet votes = voteStmt.executeQuery(
                    "SELECT v.email, c.id as candidate_id " +
                    "FROM votes vt " +
                    "JOIN voters v ON vt.voter_id = v.id " +
                    "JOIN candidates c ON vt.candidate_id = c.id " +
                    "ORDER BY c.id, v.email"
                );
                
                // Create a structure to store votes by candidate
                java.util.Map<Integer, java.util.List<String>> candidateVotes = new java.util.HashMap<>();
                java.util.Map<Integer, String> candidateNames = new java.util.HashMap<>();
                
                // Initialize candidate data
                while (candidates.next()) {
                    int id = candidates.getInt("id");
                    candidateVotes.put(id, new java.util.ArrayList<String>());
                    candidateNames.put(id, candidates.getString("name"));
                }
                
                // Populate votes
                while (votes.next()) {
                    int candidateId = votes.getInt("candidate_id");
                    String email = votes.getString("email");
                    candidateVotes.get(candidateId).add(email);
                }
                
                // Find maximum number of votes for any candidate (to determine rows)
                int maxVotes = 0;
                for (java.util.List<String> voterEmails : candidateVotes.values()) {
                    if (voterEmails.size() > maxVotes) {
                        maxVotes = voterEmails.size();
                    }
                }
            %>
            
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th></th>
                            <%
                            // Create column headers for each candidate with name and ID
                            for (Integer candidateId : candidateNames.keySet()) {
                                String candidateName = candidateNames.get(candidateId);
                            %>
                            <th>
                                <div class="candidate-header">
                                    <div class="candidate-name"><%= candidateName %></div>
                                    <div class="candidate-id">Candidate <%= candidateId %></div>
                                </div>
                            </th>
                            <%
                            }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        // Create rows for each vote
                        for (int i = 0; i < maxVotes; i++) {
                        %>
                        <tr>
                            <td class="voter-label">Voter <%= i+1 %></td>
                            <%
                            for (Integer candidateId : candidateNames.keySet()) {
                                java.util.List<String> voterEmails = candidateVotes.get(candidateId);
                            %>
                            <td class="email-cell">
                                <%
                                if (i < voterEmails.size()) {
                                    out.print(voterEmails.get(i));
                                } else {
                                    out.print("&nbsp;");
                                }
                                %>
                            </td>
                            <%
                            }
                            %>
                        </tr>
                        <%
                        }
                        %>
                        
                        <!-- Total Votes Row -->
                        <tr class="total-row">
                            <td class="voter-label">Total Votes</td>
                            <%
                            for (Integer candidateId : candidateNames.keySet()) {
                                int voteCount = candidateVotes.get(candidateId).size();
                            %>
                            <td><%= voteCount %></td>
                            <%
                            }
                            %>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <%
                // Close connections
                candidates.close();
                votes.close();
                stmt.close();
                voteStmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            %>
            <div class="alert alert-danger mt-3">Error loading candidate vote details: <%= e.getMessage() %></div>
            <%
            }
            %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
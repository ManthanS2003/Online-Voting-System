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
    <title>View Voters</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .navbar {
            background-color: #22303c;
        }
        .navbar-brand, .nav-link {
            color: white !important;
        }
        .voters-card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .voters-table {
            width: 100%;
            border-collapse: collapse;
        }
        .voters-table th, .voters-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .voters-table th {
            background-color: #2785ff;
            color: white;
            text-align: center;
        }
        .status-voted {
            color: #198754;
            font-weight: bold;
        }
        .status-not-voted {
            color: #6c757d;
            font-weight: bold;
        }
        .btn-delete-vote {
            padding: 4px 8px;
            font-size: 12px;
        }
        .age-badge {
            background-color: #6c757d;
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.8rem;
        }
        .area-badge {
            background-color: #17a2b8;
            color: white;
            padding: 3px 8px;
            border-radius: 10px;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="admin-dashboard.jsp">
            <i class="fas fa-vote-yea me-2"></i>Admin Panel
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbar">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="admin-dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle active" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-users me-1"></i>Manage Users
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="admin-profile.jsp">Admins</a></li>
                        <li><a class="dropdown-item active" href="view-voters.jsp">Voters</a></li>
                        <li><a class="dropdown-item" href="manage-candidates.jsp">Candidates</a></li>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="system-settings.jsp">
                        <i class="fas fa-cog me-1"></i>Settings
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user-shield me-1"></i><%= session.getAttribute("adminName") %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="admin-profile.jsp"><i class="fas fa-id-card me-2"></i>Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="AdminLogoutServlet"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

    <div class="container mt-4">
        <h2 class="text-center mb-4">All Voter's Details</h2>
        
        <%-- Status Messages --%>
        <%
            String deleteStatus = request.getParameter("delete");
            if ("success".equals(deleteStatus)) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Success!</strong> Vote has been deleted successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if ("failed".equals(deleteStatus)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> Failed to delete vote.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if ("novote".equals(deleteStatus)) {
        %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <strong>Warning!</strong> This voter has not voted yet.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>
        
        <div class="voters-card">
            <div class="table-responsive">
                <table class="voters-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone No.</th>
                            <th>Age</th>
                            <th>Voting Area</th>
                            <th>Voting Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        
                        try {
                            conn = com.voting.DBConnection.getConnection();
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery("SELECT v.*, COUNT(vt.id) as has_voted FROM voters v LEFT JOIN votes vt ON v.id = vt.voter_id GROUP BY v.id, v.name, v.email, v.mobile, v.status, v.age, v.voting_area ORDER BY v.id");
                            
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String name = rs.getString("name");
                                String email = rs.getString("email");
                                String mobile = rs.getString("mobile");
                                String status = rs.getString("status");
                                int age = rs.getInt("age");
                                String votingArea = rs.getString("voting_area");
                                int hasVoted = rs.getInt("has_voted");
                                boolean voted = hasVoted > 0 || "Voted".equalsIgnoreCase(status);
                        %>
                        <tr>
                            <td style="text-align: center;"><%= id %></td>
                            <td><strong><%= name %></strong></td>
                            <td><%= email %></td>
                            <td><%= mobile %></td>
                            <td style="text-align: center;">
                                <% if (age > 0) { %>
                                    <span class="age-badge"><%= age %> years</span>
                                <% } else { %>
                                    <span class="text-muted">N/A</span>
                                <% } %>
                            </td>
                            <td style="text-align: center;">
                                <span class="area-badge"><%= votingArea != null ? votingArea : "Not assigned" %></span>
                            </td>
                            <td style="text-align: center;">
                                <% if (voted) { %>
                                    <span class="status-voted">
                                        <i class="fas fa-check-circle"></i> Voted
                                    </span>
                                <% } else { %>
                                    <span class="status-not-voted">
                                        <i class="fas fa-times-circle"></i> Not Voted
                                    </span>
                                <% } %>
                            </td>
                            <td style="text-align: center;">
                                <% if (voted) { %>
                                <form action="VoteDeleteServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="voterId" value="<%= id %>">
                                    <button type="submit" class="btn btn-danger btn-sm btn-delete-vote" 
                                            onclick="return confirm('Are you sure you want to delete this vote? This will reset the voter\\'s status and update candidate vote counts.')">
                                        <i class="fas fa-trash"></i> Delete Vote
                                    </button>
                                </form>
                                <% } else { %>
                                    <span class="text-muted">--</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr>
                            <td colspan="8" class="text-center text-danger">
                                Error loading voter details: <%= e.getMessage() %>
                            </td>
                        </tr>
                        <%
                        } finally {
                            try { if (rs != null) rs.close(); } catch (Exception e) {}
                            try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                            try { if (conn != null) conn.close(); } catch (Exception e) {}
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="card mt-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Voter Statistics</h5>
            </div>
            <div class="card-body">
                <%
                Connection statsConn = null;
                try {
                    statsConn = com.voting.DBConnection.getConnection();
                    Statement statsStmt = statsConn.createStatement();
                    
                    // Total voters
                    ResultSet totalRs = statsStmt.executeQuery("SELECT COUNT(*) as total FROM voters");
                    totalRs.next();
                    int totalVoters = totalRs.getInt("total");
                    totalRs.close();
                    
                    // Voted count
                    ResultSet votedRs = statsStmt.executeQuery("SELECT COUNT(DISTINCT voter_id) as voted FROM votes");
                    votedRs.next();
                    int votedCount = votedRs.getInt("voted");
                    votedRs.close();
                    
                    // Not voted count
                    int notVotedCount = totalVoters - votedCount;
                    
                    // Average age
                    ResultSet ageRs = statsStmt.executeQuery("SELECT AVG(age) as avg_age FROM voters WHERE age > 0");
                    ageRs.next();
                    double avgAge = ageRs.getDouble("avg_age");
                    ageRs.close();
                    
                    // Voting areas count
                    ResultSet areaRs = statsStmt.executeQuery("SELECT voting_area, COUNT(*) as count FROM voters WHERE voting_area IS NOT NULL GROUP BY voting_area");
                    
                    statsStmt.close();
                %>
                <div class="row">
                    <div class="col-md-3">
                        <p><strong>Total Voters:</strong> <span class="badge bg-primary"><%= totalVoters %></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Voted:</strong> <span class="badge bg-success"><%= votedCount %></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Not Voted:</strong> <span class="badge bg-secondary"><%= notVotedCount %></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Avg Age:</strong> <span class="badge bg-info"><%= String.format("%.1f", avgAge) %> years</span></p>
                    </div>
                </div>
                
                <h6 class="mt-3">Voters by Area:</h6>
                <div class="row">
                <%
                    while (areaRs.next()) {
                        String area = areaRs.getString("voting_area");
                        int areaCount = areaRs.getInt("count");
                %>
                    <div class="col-md-3 mb-2">
                        <span class="badge bg-warning text-dark"><%= area %>: <%= areaCount %></span>
                    </div>
                <%
                    }
                    areaRs.close();
                %>
                </div>
                <%
                } catch (Exception e) {
                %>
                <p class="text-danger">Error loading statistics: <%= e.getMessage() %></p>
                <%
                } finally {
                    try { if (statsConn != null) statsConn.close(); } catch (Exception e) {}
                }
                %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
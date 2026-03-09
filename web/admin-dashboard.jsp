<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.voting.DBConnection" %>

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
    <title>Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .navbar {
            background-color: #22303c;
        }
        .navbar-brand, .nav-link {
            color: white !important;
        }
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
        }
        .results-table th, .results-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .results-table th {
            background-color: #2785ff;
            color: white;
        }
        .refresh-btn {
            margin-bottom: 15px;
        }
        
        /* Responsive fixes */
        @media (max-width: 768px) {
            .d-flex.justify-content-between.align-items-center.mb-4 {
                flex-direction: column;
                align-items: flex-start !important;
            }
            
            .refresh-btn {
                margin-top: 15px;
                width: 100%;
                text-align: center;
            }
            
            .dashboard-card {
                padding: 15px;
                margin: 10px 0;
            }
            
            .results-table {
                font-size: 0.875rem;
            }
            
            .results-table th, .results-table td {
                padding: 8px 4px;
            }
            
            .card.mt-4 .card-body {
                padding: 15px;
            }
        }
        
        @media (max-width: 576px) {
            .results-table {
                font-size: 0.8rem;
            }
            
            .container {
                padding: 0 10px;
            }
            
            h2 {
                font-size: 1.5rem;
            }
            
            h3 {
                font-size: 1.25rem;
            }
            
            .btn {
                padding: 8px 12px;
                font-size: 0.875rem;
            }
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
                    <a class="nav-link active" href="admin-dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-users me-1"></i>Manage Users
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="admin-profile.jsp">Admins</a></li>
                        <li><a class="dropdown-item" href="view-voters.jsp">Voters</a></li>
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
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start align-items-md-center mb-4">
            <h2>Admin Dashboard</h2>
            <div class="d-flex flex-column flex-sm-row gap-2 mt-2 mt-md-0">
                <a href="VoteSyncServlet" class="btn btn-warning refresh-btn" 
                   onclick="return confirm('This will recalculate all vote counts based on actual votes. Continue?')">
                    <i class="fas fa-sync-alt"></i> Sync Vote Counts
                </a>
                <a href="admin-dashboard.jsp" class="btn btn-primary refresh-btn">
                    <i class="fas fa-redo"></i> Refresh Results
                </a>
                <a href="manage-candidates.jsp" class="btn btn-success refresh-btn">
                    <i class="fas fa-users"></i> Manage Candidates
                </a>
            </div>
        </div>

        <%-- Sync Status Messages --%>
        <%
            String syncStatus = request.getParameter("sync");
            if ("success".equals(syncStatus)) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Success!</strong> Vote counts have been synchronized with the votes table.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if ("failed".equals(syncStatus)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> Failed to synchronize vote counts.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>
        
        <h3 class="mb-3">Voting Results</h3>
        
        <div class="dashboard-card">
            <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBConnection.getConnection();
                
                response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
                response.setHeader("Pragma", "no-cache");
                response.setHeader("Expires", "0");
                
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT id, name, votes FROM candidates WHERE status = 'Approved' ORDER BY votes DESC");
                
                if (!rs.isBeforeFirst()) {
            %>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        No approved candidates found in the database. 
                        <a href="manage-candidates.jsp" class="alert-link">Manage candidates</a> to approve them.
                    </div>
            <%
                } else {
            %>
                    <div class="table-responsive">
                        <table class="results-table">
                            <thead>
                                <tr>
                                    <th>Rank</th>
                                    <th>Candidate ID</th>
                                    <th>Candidate Name</th>
                                    <th>Total Votes</th>
                                </tr>
                            </thead>
                            <tbody>
            <%
                    int rank = 1;
                    while (rs.next()) {
                        int candidateId = rs.getInt("id");
                        String candidateName = rs.getString("name");
                        int votes = rs.getInt("votes");
            %>
                            <tr>
                                <td><strong>#<%= rank++ %></strong></td>
                                <td><%= candidateId %></td>
                                <td><%= candidateName %></td>
                                <td><strong><%= votes %></strong></td>
                            </tr>
            <%
                    }
            %>
                            </tbody>
                        </table>
                    </div>
            <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    Error loading voting results: <%= e.getMessage() %>
                </div>
            <%
            } finally {
                try { if (rs != null) rs.close(); } catch (Exception e) {}
                try { if (stmt != null) stmt.close(); } catch (Exception e) {}
                try { if (conn != null) conn.close(); } catch (Exception e) {}
            }
            %>
        </div>
        
        <div class="card mt-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Quick Actions</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <a href="manage-candidates.jsp" class="btn btn-outline-primary w-100">
                            <i class="fas fa-users me-2"></i>Manage Candidates
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="view-voters.jsp" class="btn btn-outline-success w-100">
                            <i class="fas fa-user-friends me-2"></i>View Voters
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="system-settings.jsp" class="btn btn-outline-warning w-100">
                            <i class="fas fa-cog me-2"></i>System Settings
                        </a>
                    </div>
                    <div class="col-md-3 mb-3">
                        <a href="admin-profile.jsp" class="btn btn-outline-info w-100">
                            <i class="fas fa-user-shield me-2"></i>Admin Profile
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
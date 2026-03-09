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
    <title>Manage Candidates - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .navbar {
            background-color: #22303c;
        }
        .navbar-brand, .nav-link {
            color: white !important;
        }
        .candidates-card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .candidates-table {
            width: 100%;
            border-collapse: collapse;
        }
        .candidates-table th, .candidates-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .candidates-table th {
            background-color: #2785ff;
            color: white;
            text-align: center;
        }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-approved { background-color: #d1edff; color: #0c5460; }
        .status-rejected { background-color: #f8d7da; color: #721c24; }
        .badge-status { font-size: 0.75rem; padding: 4px 8px; }
        .action-buttons {
            display: flex;
            gap: 5px;
            justify-content: center;
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
                        <li><a class="dropdown-item" href="view-voters.jsp">Voters</a></li>
                        <li><a class="dropdown-item active" href="manage-candidates.jsp">Candidates</a></li>
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
        <h2 class="text-center mb-4">Manage Candidate Applications</h2>
        
        <%-- Status Messages --%>
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            if (success != null) {
                String message = "";
                if ("approve".equals(success)) {
                    message = "Candidate application approved successfully.";
                } else if ("reject".equals(success)) {
                    message = "Candidate application rejected.";
                } else if ("delete".equals(success)) {
                    message = "Candidate deleted successfully.";
                }
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Success!</strong> <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if (error != null) {
                String message = "";
                if ("invalid".equals(error)) {
                    message = "Invalid request.";
                } else if ("invalid_action".equals(error)) {
                    message = "Invalid action specified.";
                } else if ("failed".equals(error)) {
                    message = "Operation failed. Please try again.";
                } else if ("exception".equals(error)) {
                    message = "Something went wrong. Please try again.";
                }
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Error!</strong> <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>
        
        <div class="candidates-card">
            <div class="table-responsive">
                <table class="candidates-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Party</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Votes</th>
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
                            rs = stmt.executeQuery("SELECT * FROM candidates ORDER BY status, created_at DESC");
                            
                            if (!rs.isBeforeFirst()) {
                        %>
                                <tr>
                                    <td colspan="9" class="text-center text-muted py-4">
                                        <i class="fas fa-users fa-2x mb-3 d-block"></i>
                                        No candidates found.
                                    </td>
                                </tr>
                        <%
                            } else {
                                while (rs.next()) {
                                    int id = rs.getInt("id");
                                    String name = rs.getString("name");
                                    String email = rs.getString("email");
                                    String phone = rs.getString("phone");
                                    String party = rs.getString("party");
                                    String description = rs.getString("description");
                                    String status = rs.getString("status");
                                    int votes = rs.getInt("votes");
                                    
                                    String statusClass = "";
                                    switch (status) {
                                        case "Pending": statusClass = "status-pending"; break;
                                        case "Approved": statusClass = "status-approved"; break;
                                        case "Rejected": statusClass = "status-rejected"; break;
                                    }
                        %>
                        <tr>
                            <td style="text-align: center;"><%= id %></td>
                            <td><strong><%= name %></strong></td>
                            <td><%= email %></td>
                            <td><%= phone %></td>
                            <td><%= party != null ? party : "Independent" %></td>
                            <td>
                                <% if (description != null && !description.trim().isEmpty()) { %>
                                    <span title="<%= description %>">
                                        <%= description.length() > 50 ? description.substring(0, 50) + "..." : description %>
                                    </span>
                                <% } else { %>
                                    <span class="text-muted">No description</span>
                                <% } %>
                            </td>
                            <td style="text-align: center;">
                                <span class="badge badge-status <%= statusClass %>"><%= status %></span>
                            </td>
                            <td style="text-align: center;"><%= votes %></td>
                            <td style="text-align: center;">
                                <div class="action-buttons">
                                    <% if ("Pending".equals(status)) { %>
                                        <form action="CandidateManagementServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="candidateId" value="<%= id %>">
                                            <input type="hidden" name="action" value="approve">
                                            <button type="submit" class="btn btn-success btn-sm" 
                                                    onclick="return confirm('Approve this candidate? They will become visible to voters.')"
                                                    title="Approve Candidate">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </form>
                                        <form action="CandidateManagementServlet" method="post" style="display:inline;">
                                            <input type="hidden" name="candidateId" value="<%= id %>">
                                            <input type="hidden" name="action" value="reject">
                                            <button type="submit" class="btn btn-warning btn-sm" 
                                                    onclick="return confirm('Reject this candidate application?')"
                                                    title="Reject Candidate">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </form>
                                    <% } else if ("Approved".equals(status)) { %>
                                        <span class="text-success small">Approved</span>
                                    <% } else if ("Rejected".equals(status)) { %>
                                        <span class="text-danger small">Rejected</span>
                                    <% } %>
                                    <form action="CandidateManagementServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="candidateId" value="<%= id %>">
                                        <input type="hidden" name="action" value="delete">
                                        <button type="submit" class="btn btn-danger btn-sm" 
                                                onclick="return confirm('Delete this candidate permanently? This action cannot be undone.')"
                                                title="Delete Candidate">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr>
                            <td colspan="9" class="text-center text-danger">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Error loading candidate details: <%= e.getMessage() %>
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
                <h5 class="mb-0"><i class="fas fa-chart-pie me-2"></i>Candidate Statistics</h5>
            </div>
            <div class="card-body">
                <%
                Connection statsConn = null;
                try {
                    statsConn = com.voting.DBConnection.getConnection();
                    Statement statsStmt = statsConn.createStatement();
                    
                    // Total candidates
                    ResultSet totalRs = statsStmt.executeQuery("SELECT COUNT(*) as total FROM candidates");
                    totalRs.next();
                    int totalCandidates = totalRs.getInt("total");
                    totalRs.close();
                    
                    // Status counts
                    ResultSet pendingRs = statsStmt.executeQuery("SELECT COUNT(*) as count FROM candidates WHERE status = 'Pending'");
                    pendingRs.next();
                    int pendingCount = pendingRs.getInt("count");
                    pendingRs.close();
                    
                    ResultSet approvedRs = statsStmt.executeQuery("SELECT COUNT(*) as count FROM candidates WHERE status = 'Approved'");
                    approvedRs.next();
                    int approvedCount = approvedRs.getInt("count");
                    approvedRs.close();
                    
                    ResultSet rejectedRs = statsStmt.executeQuery("SELECT COUNT(*) as count FROM candidates WHERE status = 'Rejected'");
                    rejectedRs.next();
                    int rejectedCount = rejectedRs.getInt("count");
                    rejectedRs.close();
                    
                    statsStmt.close();
                %>
                <div class="row">
                    <div class="col-md-3">
                        <p><strong>Total Candidates:</strong> <span class="badge bg-primary"><%= totalCandidates %></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Pending:</strong> <span class="badge bg-warning text-dark"><%= pendingCount %></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Approved:</strong> <span class="badge bg-success"><%= approvedCount %></span></p>
                    </div>
                    <div class="col-md-3">
                        <p><strong>Rejected:</strong> <span class="badge bg-danger"><%= rejectedCount %></span></p>
                    </div>
                </div>
                <%
                } catch (Exception e) {
                %>
                <p class="text-danger"><i class="fas fa-exclamation-circle me-2"></i>Error loading statistics: <%= e.getMessage() %></p>
                <%
                } finally {
                    try { if (statsConn != null) statsConn.close(); } catch (Exception e) {}
                }
                %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
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
    <title>Admin Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .navbar {
            background-color: #22303c;
        }
        .navbar-brand, .nav-link {
            color: white !important;
        }
        .profile-card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .admin-table {
            width: 100%;
            border-collapse: collapse;
        }
        .admin-table th, .admin-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .admin-table th {
            background-color: #2785ff;
            color: white;
            text-align: center;
        }
        .admin-table td {
            text-align: center;
        }
        .btn-add-admin {
            margin-bottom: 15px;
        }
        
        /* Responsive fixes */
        @media (max-width: 768px) {
            .d-flex.justify-content-between.align-items-center.mb-4 {
                flex-direction: column;
                align-items: flex-start !important;
            }
            
            .btn-add-admin {
                margin-top: 15px;
                width: 100%;
            }
            
            .admin-table {
                font-size: 0.875rem;
            }
            
            .admin-table th, .admin-table td {
                padding: 8px 4px;
            }
            
            .profile-card {
                padding: 15px;
                margin: 10px 0;
            }
        }
        
        @media (max-width: 576px) {
            .admin-table {
                font-size: 0.8rem;
            }
            
            .btn-sm {
                padding: 4px 8px;
                font-size: 0.775rem;
            }
            
            .container {
                padding: 0 10px;
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
                    <a class="nav-link" href="admin-dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle active" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-users me-1"></i>Manage Users
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item active" href="admin-profile.jsp">Admins</a></li>
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
            <h2 class="text-center text-md-start mb-3 mb-md-0">Admin Details</h2>
            <button type="button" class="btn btn-success btn-add-admin" data-bs-toggle="modal" data-bs-target="#addAdminModal">
                <i class="fas fa-plus-circle"></i> Add New Admin
            </button>
        </div>
        
        <%-- Status Messages --%>
        <%
            String addStatus = request.getParameter("add");
            if ("success".equals(addStatus)) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Success!</strong> New admin has been added successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if ("failed".equals(addStatus)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> Failed to add new admin. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if ("duplicate".equals(addStatus)) {
        %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <strong>Warning!</strong> Admin username already exists. Please choose a different username.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
            
            String deleteStatus = request.getParameter("delete");
            if ("success".equals(deleteStatus)) {
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <strong>Success!</strong> Admin has been deleted successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if ("failed".equals(deleteStatus)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error!</strong> Failed to delete admin.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            } else if ("protected".equals(deleteStatus)) {
        %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <strong>Warning!</strong> Main admin cannot be deleted.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <%
            }
        %>
        
        <div class="profile-card">
            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Admin Name</th>
                            <th>Password</th>
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
                            rs = stmt.executeQuery("SELECT * FROM admins");
                            
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String name = rs.getString("name");
                                String password = rs.getString("password");
                        %>
                        <tr>
                            <td><%= id %></td>
                            <td><%= name %></td>
                            <td>••••••••</td>
                            <td>
                                <% 
                                    // Don't allow deletion of the main admin (usually ID 1)
                                    if (id != 1) { 
                                %>
                                <form action="DeleteAdminServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="adminId" value="<%= id %>">
                                    <button type="submit" class="btn btn-danger btn-sm" 
                                            onclick="return confirm('Are you sure you want to delete this admin?')">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                                <% } else { %>
                                    <span class="text-muted">Main Admin</span>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        %>
                        <tr>
                            <td colspan="4" class="text-center">Error loading admin details</td>
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
    </div>

    <!-- Add Admin Modal -->
    <div class="modal fade" id="addAdminModal" tabindex="-1" aria-labelledby="addAdminModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addAdminModalLabel">Add New Admin</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="AddAdminServlet" method="post">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label for="adminName" class="form-label">Admin Username</label>
                            <input type="text" class="form-control" id="adminName" name="adminName" required 
                                   placeholder="Enter admin username">
                        </div>
                        <div class="mb-3">
                            <label for="adminPassword" class="form-label">Password</label>
                            <input type="password" class="form-control" id="adminPassword" name="adminPassword" required 
                                   placeholder="Enter password" minlength="4">
                        </div>
                        <div class="mb-3">
                            <label for="confirmPassword" class="form-label">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required 
                                   placeholder="Confirm password" minlength="4">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Add Admin</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Password confirmation validation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form[action="AddAdminServlet"]');
            const password = document.getElementById('adminPassword');
            const confirmPassword = document.getElementById('confirmPassword');
            
            form.addEventListener('submit', function(e) {
                if (password.value !== confirmPassword.value) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    confirmPassword.focus();
                }
            });
        });
    </script>
</body>
</html>
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

// Get current settings
String candidateRegistration = "disabled";
String votingEnabled = "disabled";

try {
    Connection conn = DBConnection.getConnection();
    String sql = "SELECT setting_key, setting_value FROM system_settings";
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    
    while (rs.next()) {
        String key = rs.getString("setting_key");
        String value = rs.getString("setting_value");
        if ("candidate_registration".equals(key)) {
            candidateRegistration = value;
        } else if ("voting_enabled".equals(key)) {
            votingEnabled = value;
        }
    }
    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .navbar {
            background-color: #22303c;
        }
        .navbar-brand, .nav-link {
            color: white !important;
        }
        .settings-card {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
            background: white;
        }
        .setting-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
        }
        .setting-item:last-child {
            border-bottom: none;
        }
        .btn-save {
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(39, 133, 255, 0.3);
        }
        .status-badge {
            font-size: 0.8rem;
            padding: 5px 10px;
        }
        .setting-description {
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 5px;
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
                    <a class="nav-link active" href="system-settings.jsp">
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
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="settings-card">
                    <h2 class="text-center mb-4">System Settings</h2>
                    
                    <%-- Status Messages --%>
                    <%
                        String success = request.getParameter("success");
                        String error = request.getParameter("error");
                        
                        if ("updated".equals(success)) {
                    %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong>Success!</strong> System settings have been updated successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <%
                        } else if ("failed".equals(error)) {
                    %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <strong>Error!</strong> Failed to update settings. Please try again.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <%
                        } else if ("invalid".equals(error)) {
                    %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <strong>Error!</strong> Invalid settings parameters.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <%
                        } else if ("exception".equals(error)) {
                    %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>
                            <strong>Error!</strong> Something went wrong. Please try again.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <%
                        }
                    %>
                    
                    <form action="SystemSettingsServlet" method="post" id="settingsForm">
                        <!-- Candidate Registration Setting -->
                        <div class="setting-item">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h5 class="fw-bold mb-1">
                                        <i class="fas fa-user-plus me-2 text-primary"></i>
                                        Candidate Self-Registration
                                    </h5>
                                    <p class="setting-description">
                                        Allow candidates to register themselves through the public portal. 
                                        When enabled, candidates can fill out registration forms which will require admin approval.
                                    </p>
                                    <div class="current-status">
                                        <small class="text-muted">
                                            <strong>Current Status:</strong> 
                                            <span id="candidateStatusText" class="<%= "enabled".equals(candidateRegistration) ? "text-success" : "text-danger" %>">
                                                <%= "enabled".equals(candidateRegistration) ? "ENABLED - Candidates can register" : "DISABLED - Registration closed" %>
                                            </span>
                                        </small>
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" role="switch" 
                                               id="candidateRegistration" name="candidate_registration" 
                                               value="enabled" <%= "enabled".equals(candidateRegistration) ? "checked" : "" %>>
                                        <!-- Hidden field for when checkbox is unchecked -->
                                        <input type="hidden" name="candidate_registration" value="disabled">
                                        <label class="form-check-label fw-bold" for="candidateRegistration">
                                            <span id="candidateBadge" class="badge <%= "enabled".equals(candidateRegistration) ? "bg-success" : "bg-secondary" %> status-badge">
                                                <%= "enabled".equals(candidateRegistration) ? "ENABLED" : "DISABLED" %>
                                            </span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Voting System Setting -->
                        <div class="setting-item">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <h5 class="fw-bold mb-1">
                                        <i class="fas fa-vote-yea me-2 text-success"></i>
                                        Voting System
                                    </h5>
                                    <p class="setting-description">
                                        Enable or disable the entire voting system. When disabled, no voting activities can be performed by anyone.
                                        This setting is immediately reflected on the user dashboard.
                                    </p>
                                    <div class="current-status">
                                        <small class="text-muted">
                                            <strong>Current Status:</strong> 
                                            <span id="votingStatusText" class="<%= "enabled".equals(votingEnabled) ? "text-success" : "text-danger" %>">
                                                <%= "enabled".equals(votingEnabled) ? "ENABLED - Voting active" : "DISABLED - Voting suspended" %>
                                            </span>
                                        </small>
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" role="switch" 
                                               id="votingEnabled" name="voting_enabled" 
                                               value="enabled" <%= "enabled".equals(votingEnabled) ? "checked" : "" %>>
                                        <!-- Hidden field for when checkbox is unchecked -->
                                        <input type="hidden" name="voting_enabled" value="disabled">
                                        <label class="form-check-label fw-bold" for="votingEnabled">
                                            <span id="votingBadge" class="badge <%= "enabled".equals(votingEnabled) ? "bg-success" : "bg-danger" %> status-badge">
                                                <%= "enabled".equals(votingEnabled) ? "ENABLED" : "DISABLED" %>
                                            </span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-save text-white">
                                <i class="fas fa-save me-2"></i>Save Settings
                            </button>
                            <a href="admin-dashboard.jsp" class="btn btn-secondary ms-2">
                                <i class="fas fa-times me-2"></i>Cancel
                            </a>
                        </div>
                    </form>

                    <div class="mt-4">
                        <div class="card border-0 bg-light">
                            <div class="card-header bg-info text-white">
                                <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Settings Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6><i class="fas fa-user-plus me-2 text-primary"></i>Candidate Registration</h6>
                                        <ul class="small mb-3">
                                            <li>When enabled: Candidates can register themselves</li>
                                            <li>All registrations require admin approval</li>
                                            <li>Pending applications appear in "Manage Candidates"</li>
                                            <li>When disabled: Registration form is hidden</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <h6><i class="fas fa-vote-yea me-2 text-success"></i>Voting System</h6>
                                        <ul class="small mb-0">
                                            <li>When enabled: Normal voting operations</li>
                                            <li>When disabled: No voting allowed</li>
                                            <li>Voters see "Voting Disabled" message</li>
                                            <li>Useful for maintenance or between elections</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Update badge text and colors when switches are toggled
        document.getElementById('candidateRegistration').addEventListener('change', function() {
            const badge = document.getElementById('candidateBadge');
            const statusText = document.getElementById('candidateStatusText');
            
            if (this.checked) {
                badge.textContent = 'ENABLED';
                badge.className = 'badge bg-success status-badge';
                statusText.textContent = 'ENABLED - Candidates can register';
                statusText.className = 'text-success';
            } else {
                badge.textContent = 'DISABLED';
                badge.className = 'badge bg-secondary status-badge';
                statusText.textContent = 'DISABLED - Registration closed';
                statusText.className = 'text-danger';
            }
        });

        document.getElementById('votingEnabled').addEventListener('change', function() {
            const badge = document.getElementById('votingBadge');
            const statusText = document.getElementById('votingStatusText');
            
            if (this.checked) {
                badge.textContent = 'ENABLED';
                badge.className = 'badge bg-success status-badge';
                statusText.textContent = 'ENABLED - Voting active';
                statusText.className = 'text-success';
            } else {
                badge.textContent = 'DISABLED';
                badge.className = 'badge bg-danger status-badge';
                statusText.textContent = 'DISABLED - Voting suspended';
                statusText.className = 'text-danger';
            }
        });

        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Confirm before saving
        document.getElementById('settingsForm').addEventListener('submit', function(e) {
            const candidateReg = document.getElementById('candidateRegistration').checked;
            const votingEnabled = document.getElementById('votingEnabled').checked;
            
            let message = "Are you sure you want to update system settings?\n\n";
            message += "Candidate Registration: " + (candidateReg ? "ENABLED" : "DISABLED") + "\n";
            message += "Voting System: " + (votingEnabled ? "ENABLED" : "DISABLED");
            
            if (!confirm(message)) {
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
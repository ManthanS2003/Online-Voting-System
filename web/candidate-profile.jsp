<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.voting.DBConnection" %>

<%
// Session validation
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session == null || session.getAttribute("candidateId") == null) {
    response.sendRedirect("candidate-login.jsp");
    return;
}

int candidateId = (Integer) session.getAttribute("candidateId");
String candidateName = (String) session.getAttribute("candidateName");
String candidateEmail = (String) session.getAttribute("candidateEmail");

// Get candidate details from database
String candidatePhone = "";
String candidateParty = "";
String candidateDescription = "";
int totalVotes = 0;

try {
    Connection conn = DBConnection.getConnection();
    String sql = "SELECT phone, party, description, votes FROM candidates WHERE id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, candidateId);
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        candidatePhone = rs.getString("phone");
        candidateParty = rs.getString("party");
        candidateDescription = rs.getString("description");
        totalVotes = rs.getInt("votes");
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
    <title>My Profile - Candidate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .profile-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            margin: 30px auto;
        }
        .profile-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 30px;
            text-align: center;
        }
        .profile-avatar {
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .info-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #28a745;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-success shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="candidate-dashboard.jsp">
                <i class="fas fa-user-tie me-2"></i>Candidate Panel
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#candidateNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="candidateNavbar">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="candidate-dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="candidate-profile.jsp">
                            <i class="fas fa-user me-1"></i>My Profile
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-tie me-1"></i><%= candidateName %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item active" href="candidate-profile.jsp"><i class="fas fa-id-card me-2"></i>My Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="CandidateLogoutServlet"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="profile-container">
            <!-- Header -->
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user-tie fa-3x text-white"></i>
                </div>
                <h1 class="fw-bold">My Profile</h1>
                <p class="lead mb-0"><%= candidateName %></p>
            </div>

            <!-- Content -->
            <div class="p-4">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="info-card">
                            <h4 class="fw-bold text-success mb-3">
                                <i class="fas fa-info-circle me-2"></i>Candidate Details
                            </h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <strong><i class="fas fa-id-card me-2 text-success"></i>Candidate ID:</strong>
                                    <span class="float-end"><%= candidateId %></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong><i class="fas fa-user me-2 text-success"></i>Full Name:</strong>
                                    <span class="float-end"><%= candidateName %></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong><i class="fas fa-envelope me-2 text-success"></i>Email Address:</strong>
                                    <span class="float-end"><%= candidateEmail %></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong><i class="fas fa-phone me-2 text-success"></i>Phone Number:</strong>
                                    <span class="float-end"><%= candidatePhone != null ? candidatePhone : "Not provided" %></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong><i class="fas fa-landmark me-2 text-success"></i>Political Party:</strong>
                                    <span class="float-end"><%= candidateParty != null ? candidateParty : "Independent" %></span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <strong><i class="fas fa-vote-yea me-2 text-success"></i>Total Votes:</strong>
                                    <span class="float-end badge bg-success fs-6"><%= totalVotes %></span>
                                </div>
                                <div class="col-12">
                                    <strong><i class="fas fa-file-alt me-2 text-success"></i>Description:</strong>
                                    <div class="mt-2 p-3 bg-white rounded">
                                        <%= candidateDescription != null && !candidateDescription.trim().isEmpty() ? candidateDescription : "No description provided." %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="info-card">
                            <h4 class="fw-bold text-success mb-3">
                                <i class="fas fa-chart-pie me-2"></i>Quick Stats
                            </h4>
                            <div class="text-center">
                                <div class="display-4 fw-bold text-success mb-2"><%= totalVotes %></div>
                                <p class="text-muted">Total Votes Received</p>
                            </div>
                        </div>

                        <div class="info-card">
                            <h4 class="fw-bold text-success mb-3">
                                <i class="fas fa-shield-alt me-2"></i>Account Status
                            </h4>
                            <div class="text-center">
                                <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                                <h5>Approved Candidate</h5>
                                <p class="text-muted small">Your account is active and approved by administrators.</p>
                            </div>
                        </div>

                        <div class="d-grid gap-2">
                            <a href="candidate-dashboard.jsp" class="btn btn-outline-success">
                                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                            </a>
                            <a href="index.html" class="btn btn-outline-primary">
                                <i class="fas fa-home me-2"></i>Home Page
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
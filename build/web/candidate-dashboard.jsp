<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.voting.DBConnection" %>

<%
// Session validation for candidate pages
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session == null || session.getAttribute("candidateId") == null) {
    response.sendRedirect("candidate-login.jsp");
    return;
}

// Get candidate details
String candidateName = (String) session.getAttribute("candidateName");
String candidateEmail = (String) session.getAttribute("candidateEmail");
int candidateId = (Integer) session.getAttribute("candidateId");

// Get candidate statistics
int totalVotes = 0;
String candidateParty = "";
String candidateDescription = "";

try {
    Connection conn = DBConnection.getConnection();
    String sql = "SELECT votes, party, description FROM candidates WHERE id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, candidateId);
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        totalVotes = rs.getInt("votes");
        candidateParty = rs.getString("party");
        candidateDescription = rs.getString("description");
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
    <title>Candidate Dashboard - Bharat E-Voting</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .dashboard-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            margin: 30px auto;
            overflow: hidden;
        }
        .dashboard-header {
            background: linear-gradient(135deg, #0d6efd, #4facfe);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 30px;
            position: relative;
            overflow: hidden;
        }
        .dashboard-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, rgba(255,255,255,0) 70%);
            z-index: 1;
        }
        .candidate-avatar {
            width: 100px;
            height: 100px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            border: 3px solid rgba(255, 255, 255, 0.5);
            position: relative;
            z-index: 2;
        }
        .stat-card {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 8px 20px rgba(13, 110, 253, 0.15);
            margin-bottom: 20px;
            border: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
            border-left: 4px solid #0d6efd;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0) 100%);
            z-index: 1;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(13, 110, 253, 0.2);
        }
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #0d6efd;
            display: block;
            position: relative;
            z-index: 2;
        }
        .stat-label {
            color: #495057;
            font-size: 1rem;
            position: relative;
            z-index: 2;
        }
        .info-card {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            border: none;
            transition: transform 0.3s ease;
            border-left: 4px solid #0d6efd;
        }
        .info-card:hover {
            transform: translateY(-3px);
        }
        .progress {
            height: 25px;
            border-radius: 12px;
            background-color: #e9ecef;
            overflow: hidden;
            box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
        }
        .progress-bar {
            background: linear-gradient(90deg, #0d6efd, #4facfe);
            border-radius: 12px;
        }
        .btn-action {
            background: linear-gradient(135deg, #0d6efd, #4facfe);
            border: none;
            color: white;
            border-radius: 50px;
            padding: 8px 15px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(13, 110, 253, 0.4);
            color: white;
        }
        .badge-votes {
            background: linear-gradient(135deg, #0d6efd, #4facfe);
            color: white;
            font-size: 1rem;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 500;
        }
        .icon-circle {
            width: 50px;
            height: 50px;
            background: rgba(13, 110, 253, 0.15);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        .info-icon {
            color: #0d6efd;
        }
        .card-title-blue {
            color: #0d6efd;
        }
        .nav-gradient {
            background: linear-gradient(135deg, #0d6efd, #4facfe) !important;
        }
        
        /* Pulse animation for important elements */
        @keyframes pulse-blue {
            0% { box-shadow: 0 0 0 0 rgba(13, 110, 253, 0.4); }
            70% { box-shadow: 0 0 0 10px rgba(13, 110, 253, 0); }
            100% { box-shadow: 0 0 0 0 rgba(13, 110, 253, 0); }
        }
        
        .pulse {
            animation: pulse-blue 2s infinite;
        }
        
        /* Responsive fixes */
        @media (max-width: 768px) {
            .dashboard-header {
                padding: 20px;
            }
            .candidate-avatar {
                width: 80px;
                height: 80px;
            }
            .stat-number {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark nav-gradient shadow-sm">
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
                        <a class="nav-link active" href="candidate-dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="candidate-profile.jsp">
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
                            <li><a class="dropdown-item" href="candidate-profile.jsp"><i class="fas fa-id-card me-2"></i>My Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="CandidateLogoutServlet"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="dashboard-container">
            <!-- Header -->
            <div class="dashboard-header text-center">
                <div class="candidate-avatar">
                    <i class="fas fa-user-tie fa-3x text-white"></i>
                </div>
                <h1 class="fw-bold">Candidate Dashboard</h1>
                <p class="lead mb-0">Welcome back, <%= candidateName %></p>
            </div>

            <!-- Content -->
            <div class="p-4">
                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="icon-circle">
                                <i class="fas fa-vote-yea fa-lg text-primary"></i>
                            </div>
                            <span class="stat-number"><%= totalVotes %></span>
                            <span class="stat-label">Total Votes</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <div class="icon-circle">
                                <i class="fas fa-id-card fa-lg text-primary"></i>
                            </div>
                            <span class="stat-number"><%= candidateId %></span>
                            <span class="stat-label">Candidate ID</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card pulse">
                            <div class="icon-circle">
                                <i class="fas fa-check-circle fa-lg text-primary"></i>
                            </div>
                            <span class="stat-number">Active</span>
                            <span class="stat-label">Status</span>
                        </div>
                    </div>
                </div>

                <!-- Candidate Information -->
                <div class="row">
                    <div class="col-lg-6">
                        <div class="info-card">
                            <h4 class="fw-bold card-title-blue mb-3">
                                <i class="fas fa-info-circle me-2"></i>Candidate Information
                            </h4>
                            <div class="row">
                                <div class="col-12 mb-3">
                                    <strong><i class="fas fa-id-card me-2 info-icon"></i>Candidate ID:</strong>
                                    <span class="float-end"><%= candidateId %></span>
                                </div>
                                <div class="col-12 mb-3">
                                    <strong><i class="fas fa-user me-2 info-icon"></i>Full Name:</strong>
                                    <span class="float-end"><%= candidateName %></span>
                                </div>
                                <div class="col-12 mb-3">
                                    <strong><i class="fas fa-envelope me-2 info-icon"></i>Email Address:</strong>
                                    <span class="float-end"><%= candidateEmail %></span>
                                </div>
                                <div class="col-12 mb-3">
                                    <strong><i class="fas fa-landmark me-2 info-icon"></i>Political Party:</strong>
                                    <span class="float-end"><%= candidateParty != null ? candidateParty : "Independent" %></span>
                                </div>
                                <div class="col-12">
                                    <strong><i class="fas fa-vote-yea me-2 info-icon"></i>Current Votes:</strong>
                                    <span class="float-end badge-votes"><%= totalVotes %> votes</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="info-card">
                            <h4 class="fw-bold card-title-blue mb-3">
                                <i class="fas fa-bullhorn me-2"></i>Campaign Information
                            </h4>
                            <% if (candidateDescription != null && !candidateDescription.trim().isEmpty()) { %>
                                <p class="mb-0" style="line-height: 1.6;"><%= candidateDescription %></p>
                            <% } else { %>
                                <p class="text-muted mb-0">No campaign description provided.</p>
                            <% } %>
                            
                            <hr>
                            
                            <h6 class="fw-bold mt-3 card-title-blue">Quick Actions</h6>
                            <div class="row g-2 mt-2">
                                <div class="col-6">
                                    <a href="candidate-profile.jsp" class="btn btn-action w-100">
                                        <i class="fas fa-edit me-1"></i>Edit Profile
                                    </a>
                                </div>
                                <div class="col-6">
                                    <a href="index.html" class="btn btn-action w-100">
                                        <i class="fas fa-home me-1"></i>Home Page
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Voting Progress -->
                <div class="info-card mt-4">
                    <h4 class="fw-bold card-title-blue mb-3">
                        <i class="fas fa-chart-line me-2"></i>Voting Progress
                    </h4>
                    <div class="progress mb-3">
                        <div class="progress-bar progress-bar-striped progress-bar-animated" 
                             role="progressbar" 
                             style="width: <%= Math.min(totalVotes, 100) %>%"
                             aria-valuenow="<%= totalVotes %>" 
                             aria-valuemin="0" 
                             aria-valuemax="100">
                            <%= totalVotes %> Votes
                        </div>
                    </div>
                    <p class="text-muted mb-0 text-center">
                        <small>Your current vote count. Keep campaigning!</small>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add some interactive animations
        document.addEventListener('DOMContentLoaded', function() {
            // Animate progress bar on page load
            const progressBar = document.querySelector('.progress-bar');
            const originalWidth = progressBar.style.width;
            progressBar.style.width = '0%';
            
            setTimeout(() => {
                progressBar.style.width = originalWidth;
            }, 500);
            
            // Add hover effects to cards
            const cards = document.querySelectorAll('.stat-card, .info-card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
            });
            
            // Add click animation to buttons
            const buttons = document.querySelectorAll('.btn-action');
            buttons.forEach(button => {
                button.addEventListener('click', function() {
                    this.style.transform = 'scale(0.95)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });
        });
    </script>
</body>
</html>
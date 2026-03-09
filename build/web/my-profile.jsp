<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.voting.DBConnection" %>

<%
// Session validation for voter pages
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session == null || session.getAttribute("voterId") == null) {
    response.sendRedirect("voter-login.jsp");
    return;
}

// Get voter details from database
String voterName = "";
String voterEmail = "";
String voterMobile = "";
String voterStatus = "Not Voted";
String voterAddress = "";
String votingArea = "";
int voterAge = 0;
String dateOfBirth = "";
int voterId = 0;
String createdDate = "";

try {
    Connection conn = DBConnection.getConnection();
    int sessionVoterId = (Integer) session.getAttribute("voterId");
    
    String sql = "SELECT id, name, email, mobile, status, address, voting_area, age, date_of_birth, DATE_FORMAT(created_at, '%M %d, %Y') as created_date FROM voters WHERE id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, sessionVoterId);
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        voterId = rs.getInt("id");
        voterName = rs.getString("name") != null ? rs.getString("name") : "";
        voterEmail = rs.getString("email") != null ? rs.getString("email") : "";
        voterMobile = rs.getString("mobile") != null ? rs.getString("mobile") : "";
        voterStatus = rs.getString("status") != null ? rs.getString("status") : "Not Voted";
        voterAddress = rs.getString("address") != null ? rs.getString("address") : "Not provided";
        votingArea = rs.getString("voting_area") != null ? rs.getString("voting_area") : "Not assigned";
        voterAge = rs.getInt("age");
        dateOfBirth = rs.getString("date_of_birth") != null ? rs.getString("date_of_birth") : "";
        createdDate = rs.getString("created_date") != null ? rs.getString("created_date") : "";
        
        // Update session with current name
        session.setAttribute("voterName", voterName);
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
    <title>My Profile - Bharat E-Voting</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2785ff;
            --secondary-color: #6c757d;
            --success-color: #198754;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .profile-container {
            max-width: 1200px;
            margin: 30px auto;
        }
        
        .profile-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            overflow: hidden;
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), #1a6fd8);
            color: white;
            padding: 40px 30px;
            position: relative;
            overflow: hidden;
        }
        
        .profile-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transform: rotate(30deg);
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-stats {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-top: -50px;
            position: relative;
            z-index: 2;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
        .stat-item {
            text-align: center;
            padding: 15px;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-color);
            display: block;
        }
        
        .stat-label {
            color: var(--secondary-color);
            font-size: 0.9rem;
        }
        
        .info-section {
            padding: 30px;
        }
        
        .section-title {
            color: var(--dark-color);
            font-weight: 600;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid;
            display: inline-block;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, var(--primary-color), #1a6fd8);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 20px;
            color: white;
            font-size: 1.2rem;
        }
        
        .info-content {
            flex: 1;
        }
        
        .info-label {
            color: var(--secondary-color);
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .info-value {
            color: var(--dark-color);
            font-weight: 500;
            font-size: 1.1rem;
        }
        
        .status-badge {
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.9rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn-modern {
            padding: 12px 30px;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-modern:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
        }
        
        .btn-primary-modern {
            background: linear-gradient(135deg, var(--primary-color), #1a6fd8);
            color: white;
        }
        
        .btn-outline-modern {
            border: 2px solid;
            color: var(--primary-color);
            background: transparent;
        }
        
        .btn-outline-modern:hover {
            background: var(--primary-color);
            color: white;
        }
        
        .timeline {
            position: relative;
            padding-left: 30px;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 15px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--primary-color);
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 25px;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -23px;
            top: 5px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--primary-color);
            border: 3px solid white;
        }
        
        .timeline-date {
            color: var(--secondary-color);
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        
        .timeline-content {
            background: var(--light-color);
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid;
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .profile-header {
                padding: 30px 20px;
            }
            
            .profile-avatar {
                width: 100px;
                height: 100px;
            }
            
            .profile-stats {
                margin-top: -30px;
                padding: 20px;
            }
            
            .stat-number {
                font-size: 1.5rem;
            }
            
            .info-section {
                padding: 20px;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-modern {
                width: 100%;
            }
        }
        
        @media (max-width: 576px) {
            .profile-container {
                margin: 15px;
            }
            
            .profile-header {
                padding: 25px 15px;
            }
            
            .profile-avatar {
                width: 80px;
                height: 80px;
            }
            
            .info-item {
                flex-direction: column;
                text-align: center;
                padding: 20px 0;
            }
            
            .info-icon {
                margin-right: 0;
                margin-bottom: 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="user-dashboard.jsp">
                <i class="fas fa-vote-yea me-2"></i>Bharat E-Voting
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#voterNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="voterNavbar">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="user-dashboard.jsp">
                            <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="my-profile.jsp">
                            <i class="fas fa-user me-1"></i>My Profile
                        </a>
                    </li>
                </ul>
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i><%= voterName %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="my-profile.jsp"><i class="fas fa-id-card me-2"></i>My Profile</a></li>
                            <li><a class="dropdown-item" href="user-dashboard.jsp"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="VoterLogoutServlet"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Profile Content -->
    <div class="container profile-container">
        <div class="profile-card">
            <!-- Profile Header -->
            <div class="profile-header text-center">
                <div class="profile-avatar">
                    <i class="fas fa-user fa-3x text-white"></i>
                </div>
                <h1 class="fw-bold mb-2"><%= voterName %></h1>
                <p class="lead mb-0">Registered Voter | <%= votingArea %> Constituency</p>
            </div>

            <!-- Profile Statistics -->
            <div class="profile-stats">
                <div class="row text-center">
                    <div class="col-md-3 col-6 stat-item">
                        <span class="stat-number"><%= voterId %></span>
                        <span class="stat-label">Voter ID</span>
                    </div>
                    <div class="col-md-3 col-6 stat-item">
                        <span class="stat-number">
                            <% if ("Voted".equalsIgnoreCase(voterStatus)) { %>
                                <i class="fas fa-check text-success"></i>
                            <% } else { %>
                                <i class="fas fa-clock text-warning"></i>
                            <% } %>
                        </span>
                        <span class="stat-label">Voting Status</span>
                    </div>
                    <div class="col-md-3 col-6 stat-item">
                        <span class="stat-number"><%= voterAge > 0 ? voterAge : "N/A" %></span>
                        <span class="stat-label">Age</span>
                    </div>
                    <div class="col-md-3 col-6 stat-item">
                        <span class="stat-number">
                            <i class="fas fa-shield-alt text-info"></i>
                        </span>
                        <span class="stat-label">Verified</span>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Left Column: Personal Information -->
                <div class="col-lg-8">
                    <div class="info-section">
                        <h3 class="section-title">
                            <i class="fas fa-user-circle me-2"></i>Personal Information
                        </h3>
                        
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-id-card"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Voter Identification Number</div>
                                <div class="info-value">VOTER-<%= String.format("%06d", voterId) %></div>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Full Name</div>
                                <div class="info-value"><%= voterName %></div>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Email Address</div>
                                <div class="info-value"><%= voterEmail %></div>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Phone Number</div>
                                <div class="info-value">+91 <%= voterMobile %></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Date of Birth & Age</div>
                                <div class="info-value">
                                    <%= dateOfBirth != null && !dateOfBirth.isEmpty() ? 
                                        dateOfBirth + " (" + voterAge + " years)" : "Not provided" %>
                                </div>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Voting Area/Constituency</div>
                                <div class="info-value"><%= votingArea %></div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-home"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Complete Address</div>
                                <div class="info-value" style="white-space: pre-line;"><%= voterAddress %></div>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-vote-yea"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Voting Status</div>
                                <div class="info-value">
                                    <span class="badge <%= "Voted".equalsIgnoreCase(voterStatus) ? "bg-success status-badge" : "bg-warning status-badge" %>">
                                        <i class="fas <%= "Voted".equalsIgnoreCase(voterStatus) ? "fa-check-circle" : "fa-clock" %> me-1"></i>
                                        <%= voterStatus %>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="info-item">
                            <div class="info-icon">
                                <i class="fas fa-calendar-plus"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Registration Date</div>
                                <div class="info-value"><%= createdDate %></div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <button class="btn btn-primary-modern btn-modern" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                <i class="fas fa-edit"></i> Edit Profile
                            </button>
                            <a href="user-dashboard.jsp" class="btn btn-outline-modern btn-modern">
                                <i class="fas fa-tachometer-alt"></i> Go to Dashboard
                            </a>
                            <a href="index.html" class="btn btn-outline-modern btn-modern">
                                <i class="fas fa-home"></i> Back to Home
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Activity Timeline -->
                <div class="col-lg-4">
                    <div class="info-section">
                        <h3 class="section-title">
                            <i class="fas fa-history me-2"></i>Activity Timeline
                        </h3>
                        
                        <div class="timeline">
                            <div class="timeline-item">
                                <div class="timeline-date">
                                    <i class="fas fa-calendar me-1"></i><%= createdDate %>
                                </div>
                                <div class="timeline-content">
                                    <strong>Account Created</strong>
                                    <p class="mb-0 small">You registered as a voter in Bharat E-Voting System</p>
                                </div>
                            </div>
                            
                            <% if ("Voted".equalsIgnoreCase(voterStatus)) { %>
                            <div class="timeline-item">
                                <div class="timeline-date">
                                    <i class="fas fa-calendar me-1"></i>Recently
                                </div>
                                <div class="timeline-content">
                                    <strong>Vote Cast Successfully</strong>
                                    <p class="mb-0 small">You have exercised your democratic right to vote</p>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="timeline-item">
                                <div class="timeline-date">
                                    <i class="fas fa-calendar me-1"></i>Pending
                                </div>
                                <div class="timeline-content">
                                    <strong>Awaiting Your Vote</strong>
                                    <p class="mb-0 small">Visit dashboard to cast your vote in <%= votingArea %> constituency</p>
                                </div>
                            </div>
                            <% } %>
                            
                            <div class="timeline-item">
                                <div class="timeline-date">
                                    <i class="fas fa-calendar me-1"></i>Future
                                </div>
                                <div class="timeline-content">
                                    <strong>Election Results</strong>
                                    <p class="mb-0 small">Results will be announced after voting period</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Quick Stats -->
                    <div class="info-section">
                        <h3 class="section-title">
                            <i class="fas fa-chart-bar me-2"></i>Quick Stats
                        </h3>
                        
                        <div class="card border-0 bg-light mb-3">
                            <div class="card-body text-center">
                                <i class="fas fa-user-check fa-2x text-success mb-2"></i>
                                <h5>Verified Voter</h5>
                                <p class="text-muted mb-0">Your identity is verified and approved</p>
                            </div>
                        </div>
                        
                        <div class="card border-0 bg-light">
                            <div class="card-body text-center">
                                <i class="fas fa-map-marked-alt fa-2x text-primary mb-2"></i>
                                <h5><%= votingArea %></h5>
                                <p class="text-muted mb-0">Your voting constituency</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editProfileModalLabel">
                        <i class="fas fa-edit me-2"></i>Edit Profile Information
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="UpdateVoterServlet" method="post">
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Full Name</label>
                                <input type="text" class="form-control" id="name" name="name" value="<%= voterName %>" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <input type="email" class="form-control" id="email" name="email" value="<%= voterEmail %>" required>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="mobile" class="form-label">Phone Number</label>
                                <input type="tel" class="form-control" id="mobile" name="mobile" value="<%= voterMobile %>" 
                                       pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number" required>
                                <div class="form-text">Enter your 10-digit mobile number</div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="dob" class="form-label">Date of Birth</label>
                                <input type="date" class="form-control" id="dob" name="dob" value="<%= dateOfBirth %>"
                                       max="<%= java.time.LocalDate.now().minusYears(18).toString() %>">
                                <div class="form-text">Must be 18 years or older</div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="voting_area" class="form-label">Voting Area/Constituency</label>
                            <select class="form-control" id="voting_area" name="voting_area" required>
                                <option value="North Delhi" <%= "North Delhi".equals(votingArea) ? "selected" : "" %>>North Delhi</option>
                                <option value="South Delhi" <%= "South Delhi".equals(votingArea) ? "selected" : "" %>>South Delhi</option>
                                <option value="East Delhi" <%= "East Delhi".equals(votingArea) ? "selected" : "" %>>East Delhi</option>
                                <option value="West Delhi" <%= "West Delhi".equals(votingArea) ? "selected" : "" %>>West Delhi</option>
                                <option value="Central Delhi" <%= "Central Delhi".equals(votingArea) ? "selected" : "" %>>Central Delhi</option>
                                <option value="New Delhi" <%= "New Delhi".equals(votingArea) ? "selected" : "" %>>New Delhi</option>
                                <option value="Other" <%= "Other".equals(votingArea) ? "selected" : "" %>>Other Area</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="address" class="form-label">Complete Address</label>
                            <textarea class="form-control" id="address" name="address" rows="3" required><%= voterAddress %></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Phone number formatting
        document.getElementById('mobile')?.addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '').substring(0, 10);
        });
        
        // Age validation for date of birth
        document.getElementById('dob')?.addEventListener('change', function() {
            if (this.value) {
                const birthDate = new Date(this.value);
                const today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                const monthDiff = today.getMonth() - birthDate.getMonth();
                
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                
                if (age < 18) {
                    alert('You must be 18 years or older to register as a voter.');
                    this.value = '';
                }
            }
        });
    </script>
</body>
</html>
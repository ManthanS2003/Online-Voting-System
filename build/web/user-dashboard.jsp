<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.voting.DBConnection" %>

<%
// Session validation for voter pages - ADD CACHE CONTROL
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

try {
    Connection conn = DBConnection.getConnection();
    int sessionVoterId = (Integer) session.getAttribute("voterId");
    
    String sql = "SELECT id, name, email, mobile, status, address, voting_area, age, date_of_birth FROM voters WHERE id = ?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setInt(1, sessionVoterId);
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        voterId = rs.getInt("id");
        voterName = rs.getString("name") != null ? rs.getString("name") : "";
        voterEmail = rs.getString("email") != null ? rs.getString("email") : "";
        voterMobile = rs.getString("mobile") != null ? rs.getString("mobile") : "";
        voterStatus = rs.getString("status") != null ? rs.getString("status") : "Not Voted";
        voterAddress = rs.getString("address") != null ? rs.getString("address") : "";
        votingArea = rs.getString("voting_area") != null ? rs.getString("voting_area") : "";
        voterAge = rs.getInt("age");
        dateOfBirth = rs.getString("date_of_birth") != null ? rs.getString("date_of_birth") : "";
        
        // Update session with current name
        session.setAttribute("voterName", voterName);
    }
    
    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}

// Check if voting is enabled
boolean votingEnabled = false;
boolean settingsError = false;
try {
    Connection checkConn = DBConnection.getConnection();
    String sql = "SELECT setting_value FROM system_settings WHERE setting_key = 'voting_enabled'";
    PreparedStatement checkPs = checkConn.prepareStatement(sql);
    ResultSet checkRs = checkPs.executeQuery();
    if (checkRs.next()) {
        votingEnabled = "enabled".equals(checkRs.getString("setting_value"));
    } else {
        settingsError = true;
    }
    checkRs.close();
    checkPs.close();
    checkConn.close();
} catch (Exception e) {
    e.printStackTrace();
    settingsError = true;
    votingEnabled = false;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Profile - Bharat E-Voting</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
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
        background: linear-gradient(135deg, #2785ff, #0d6efd);
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
        border-left: 4px solid #2785ff;
    }
    .voting-card {
        background: #fff;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        margin-bottom: 20px;
    }
    .status-badge {
        font-size: 0.9rem;
        padding: 8px 15px;
        border-radius: 20px;
    }
    .btn-edit {
        background: linear-gradient(135deg, #2785ff, #0d6efd);
        border: none;
        border-radius: 25px;
        padding: 10px 25px;
        transition: all 0.3s ease;
    }
    .btn-edit:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(39, 133, 255, 0.3);
    }
    .candidate-card {
        border: none;
        border-radius: 12px;
        transition: all 0.3s ease;
        margin-bottom: 15px;
        border-left: 4px solid #2785ff;
    }
    .candidate-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    }
    .voting-disabled {
        background: linear-gradient(135deg, #ff6b6b, #ee5a52);
        color: white;
        padding: 20px;
        border-radius: 15px;
        text-align: center;
        margin-bottom: 20px;
    }
    
    /* Responsive fixes */
    @media (max-width: 768px) {
        .profile-header {
            padding: 20px;
        }
        .profile-avatar {
            width: 80px;
            height: 80px;
        }
        .profile-avatar i {
            font-size: 2rem !important;
        }
    }
  </style>
</head>
<body>
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
                    <a class="nav-link active" href="user-dashboard.jsp">
                        <i class="fas fa-tachometer-alt me-1"></i>Dashboard
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i><%= voterName %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="my-profile.jsp"><i class="fas fa-id-card me-2"></i>My Profile</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="VoterLogoutServlet"><i class="fas fa-sign-out-alt me-2"></i>Logout</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="profile-container">
        <!-- Profile Header -->
        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-user fa-3x text-white"></i>
            </div>
            <h2 class="fw-bold">My Profile</h2>
            <p class="lead mb-0">Welcome back, <%= voterName %></p>
        </div>

        <!-- Content -->
        <div class="p-4">
            <%-- System Status Messages --%>
            <% if (settingsError) { %>
            <div class="voting-disabled">
                <i class="fas fa-exclamation-triangle fa-2x mb-2"></i>
                <h5>System Configuration Error</h5>
                <p class="mb-0">Unable to load system settings. Please contact administrator.</p>
            </div>
            <% } else if (!votingEnabled) { %>
            <div class="voting-disabled">
                <i class="fas fa-ban fa-2x mb-2"></i>
                <h5>Voting System Temporarily Disabled</h5>
                <p class="mb-0">The voting system is currently under maintenance. Please check back later.</p>
            </div>
            <% } %>

            <div class="row">
                <!-- Left Column: Profile Information -->
                <div class="col-lg-6 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-primary">
                            <i class="fas fa-user-circle me-2"></i>Personal Information
                        </h4>
                        <button class="btn btn-edit text-white" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i class="fas fa-edit me-2"></i>Edit Profile
                        </button>
                    </div>

                    <div class="info-card">
                        <div class="row">
                            <div class="col-12 mb-3">
                                <strong><i class="fas fa-id-card me-2 text-primary"></i>Voter ID:</strong>
                                <span class="float-end"><%= voterId %></span>
                            </div>
                            <div class="col-12 mb-3">
                                <strong><i class="fas fa-user me-2 text-primary"></i>Full Name:</strong>
                                <span class="float-end"><%= voterName %></span>
                            </div>
                            <div class="col-12 mb-3">
                                <strong><i class="fas fa-envelope me-2 text-primary"></i>Email Address:</strong>
                                <span class="float-end"><%= voterEmail %></span>
                            </div>
                            <div class="col-12 mb-3">
                                <strong><i class="fas fa-phone me-2 text-primary"></i>Phone Number:</strong>
                                <span class="float-end"><%= voterMobile %></span>
                            </div>
                            
                            <!-- ADDED PROFILE INFORMATION ROWS -->
                            <div class="col-12 mb-3">
                                <strong><i class="fas fa-birthday-cake me-2 text-primary"></i>Age:</strong>
                                <span class="float-end">
                                    <% if (voterAge > 0) { %>
                                        <%= voterAge %> years
                                    <% } else { %>
                                        Not provided
                                    <% } %>
                                </span>
                            </div>

                            <div class="col-12 mb-3">
                                <strong><i class="fas fa-map-marker-alt me-2 text-primary"></i>Voting Area:</strong>
                                <span class="float-end"><%= votingArea != null ? votingArea : "Not assigned" %></span>
                            </div>

                            <div class="col-12 mb-3">
                                <strong><i class="fas fa-home me-2 text-primary"></i>Address:</strong>
                                <span class="float-end" style="max-width: 200px; text-align: right;">
                                    <%= voterAddress != null ? (voterAddress.length() > 30 ? voterAddress.substring(0, 30) + "..." : voterAddress) : "Not provided" %>
                                </span>
                            </div>
                            <!-- END OF ADDED ROWS -->
                            
                            <div class="col-12">
                                <strong><i class="fas fa-vote-yea me-2 text-primary"></i>Voting Status:</strong>
                                <span class="float-end badge <%= "Voted".equalsIgnoreCase(voterStatus) ? "bg-success status-badge" : "bg-warning status-badge" %>">
                                    <i class="fas <%= "Voted".equalsIgnoreCase(voterStatus) ? "fa-check-circle" : "fa-clock" %> me-1"></i>
                                    <%= voterStatus %>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="info-card">
                        <h5 class="fw-bold mb-3">
                            <i class="fas fa-bolt me-2 text-warning"></i>Quick Actions
                        </h5>
                        <div class="row g-2">
                            <div class="col-6">
                                <a href="index.html" class="btn btn-outline-primary w-100 btn-sm">
                                    <i class="fas fa-home me-1"></i>Home
                                </a>
                            </div>
                            <div class="col-6">
                                <a href="VoterLogoutServlet" class="btn btn-outline-danger w-100 btn-sm">
                                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Voting Section -->
                <div class="col-lg-6">
                    <div class="voting-card">
                        <h4 class="fw-bold text-success mb-4">
                            <i class="fas fa-vote-yea me-2"></i>Cast Your Vote
                        </h4>

                        <%
                        boolean alreadyVoted = "Voted".equalsIgnoreCase(voterStatus);
                        %>

                        <% if (alreadyVoted) { %>
                            <div class="alert alert-success text-center">
                                <i class="fas fa-check-circle fa-2x mb-3 text-success"></i>
                                <h5 class="fw-bold">Thank You for Voting!</h5>
                                <p class="mb-0">You have successfully cast your vote in this election.</p>
                            </div>
                        <% } else if (settingsError || !votingEnabled) { %>
                            <div class="alert alert-warning text-center">
                                <i class="fas fa-exclamation-triangle fa-2x mb-3 text-warning"></i>
                                <h5 class="fw-bold">Voting Unavailable</h5>
                                <p class="mb-0">The voting system is currently unavailable. Please try again later.</p>
                            </div>
                        <% } else { %>
                            <!-- Dynamic candidate listing -->
                            <%
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;
                            boolean hasCandidates = false;
                            try {
                                conn = DBConnection.getConnection();
                                ps = conn.prepareStatement("SELECT id, name, party, description FROM candidates WHERE status = 'Approved' ORDER BY name");
                                rs = ps.executeQuery();
                                
                                if (!rs.isBeforeFirst()) {
                            %>
                                    <div class="alert alert-info text-center">
                                        <i class="fas fa-info-circle fa-2x mb-3 text-info"></i>
                                        <h5 class="fw-bold">No Candidates Available</h5>
                                        <p class="mb-0">No candidates are available for voting at this time.</p>
                                    </div>
                            <%
                                } else {
                                    hasCandidates = true;
                            %>
                                    <form action="VoteServlet" method="post" id="voteForm">
                                        <h6 class="fw-bold mb-3 text-dark">Select Your Candidate:</h6>
                                        <div class="candidates-list">
                            <%
                                    while (rs.next()) {
                                        int candidateId = rs.getInt("id");
                                        String candidateName = rs.getString("name");
                                        String candidateParty = rs.getString("party");
                                        String candidateDesc = rs.getString("description");
                                        String partyDisplay = candidateParty != null && !candidateParty.trim().isEmpty() ? candidateParty : "Independent";
                            %>
                                            <div class="card candidate-card mb-3">
                                                <div class="card-body">
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="radio" name="candidate" 
                                                               value="<%= candidateId %>" id="candidate<%= candidateId %>" required>
                                                        <label class="form-check-label w-100" for="candidate<%= candidateId %>">
                                                            <h6 class="fw-bold mb-1 text-dark"><%= candidateName %></h6>
                                                            <p class="text-muted mb-1 small">
                                                                <i class="fas fa-landmark me-1"></i>Party: <%= partyDisplay %>
                                                            </p>
                                                            <% if (candidateDesc != null && !candidateDesc.trim().isEmpty()) { %>
                                                                <p class="text-muted mb-0 small">
                                                                    <i class="fas fa-info-circle me-1"></i>
                                                                    <%= candidateDesc.length() > 80 ? candidateDesc.substring(0, 80) + "..." : candidateDesc %>
                                                                </p>
                                                            <% } %>
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                            <%
                                    }
                            %>
                                        </div>
                                        
                                        <% if (hasCandidates) { %>
                                        <div class="text-center mt-4">
                                            <button class="btn btn-success btn-lg px-5" type="submit">
                                                <i class="fas fa-vote-yea me-2"></i>Cast Your Vote
                                            </button>
                                        </div>
                                        
                                        <div class="alert alert-info mt-3 text-center">
                                            <small>
                                                <i class="fas fa-info-circle me-1"></i>
                                                You can only vote once. This action cannot be undone.
                                            </small>
                                        </div>
                                        <% } %>
                                    </form>
                            <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            %>
                                <div class="alert alert-danger text-center">
                                    <i class="fas fa-exclamation-triangle fa-2x mb-3 text-danger"></i>
                                    <h5 class="fw-bold">Error Loading Candidates</h5>
                                    <p class="mb-0">Please try refreshing the page or contact support.</p>
                                </div>
                            <%
                            } finally {
                                try { if (rs != null) rs.close(); } catch (Exception e) {}
                                try { if (ps != null) ps.close(); } catch (Exception e) {}
                                try { if (conn != null) conn.close(); } catch (Exception e) {}
                            }
                            }
                            %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editProfileModalLabel">
                    <i class="fas fa-edit me-2"></i>Edit Profile
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="UpdateVoterServlet" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="name" class="form-label">Full Name</label>
                        <input type="text" class="form-control" id="name" name="name" value="<%= voterName %>" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" value="<%= voterEmail %>" required>
                    </div>
                    <div class="mb-3">
                        <label for="mobile" class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" id="mobile" name="mobile" value="<%= voterMobile %>" 
                               pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
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

    // Form validation for voting
    document.getElementById('voteForm')?.addEventListener('submit', function(e) {
        const selectedCandidate = document.querySelector('input[name="candidate"]:checked');
        if (!selectedCandidate) {
            e.preventDefault();
            alert('Please select a candidate before voting.');
            return false;
        }
        
        if (!confirm('Are you sure you want to cast your vote? This action cannot be undone.')) {
            e.preventDefault();
            return false;
        }
    });
</script>
</body>
</html>
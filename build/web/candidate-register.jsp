<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="com.voting.DBConnection" %>

<%
// Check if candidate registration is enabled
boolean registrationEnabled = false;
try {
    Connection conn = DBConnection.getConnection();
    String sql = "SELECT setting_value FROM system_settings WHERE setting_key = 'candidate_registration'";
    PreparedStatement ps = conn.prepareStatement(sql);
    ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        registrationEnabled = "enabled".equals(rs.getString("setting_value"));
    }
    rs.close();
    ps.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}

if (!registrationEnabled) {
    response.sendRedirect("candidate-registration-disabled.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Registration - Bharat E-Voting</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            flex-direction: column;
        }
        .registration-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            flex: 1;
            margin: 20px;
            display: flex;
            flex-direction: column;
        }
        .registration-header {
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 30px;
            text-align: center;
        }
        .registration-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .btn-register {
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(39, 133, 255, 0.3);
        }
        .info-card {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
        }
        .password-strength {
            height: 5px;
            border-radius: 5px;
            margin-top: 5px;
            transition: all 0.3s ease;
        }
        .strength-weak { background-color: #dc3545; width: 25%; }
        .strength-fair { background-color: #ffc107; width: 50%; }
        .strength-good { background-color: #28a745; width: 75%; }
        .strength-strong { background-color: #20c997; width: 100%; }
        
        /* New full-screen layout styles */
        .form-content {
            flex: 1;
            padding: 30px;
            display: flex;
            flex-direction: column;
        }
        .form-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .form-fields {
            flex: 1;
        }
        .form-footer {
            margin-top: auto;
            padding-top: 20px;
        }
        @media (min-width: 992px) {
            .registration-container {
                margin: 30px;
            }
            .form-content {
                padding: 40px;
            }
        }
        @media (min-width: 1200px) {
            .registration-container {
                margin: 50px;
            }
            .form-content {
                padding: 50px;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.html">
                <i class="fas fa-vote-yea me-2"></i>Bharat E-Voting
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#publicNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="publicNavbar">
                <div class="navbar-nav ms-auto">
                    <a class="nav-link" href="index.html">
                        <i class="fas fa-home me-1"></i>Home
                    </a>
                    <a class="nav-link" href="voter-login.jsp">
                        <i class="fas fa-sign-in-alt me-1"></i>Voter Login
                    </a>
                    <a class="nav-link" href="admin-login.jsp">
                        <i class="fas fa-lock me-1"></i>Admin Login
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid flex-grow-1 d-flex">
        <div class="registration-container w-100">
            <!-- Header -->
            <div class="registration-header">
                <div class="registration-icon">
                    <i class="fas fa-user-tie fa-2x text-white"></i>
                </div>
                <h1 class="display-6 fw-bold">Candidate Registration</h1>
                <p class="lead mb-0">Register as a candidate for the elections</p>
            </div>

            <!-- Content -->
            <div class="form-content">
                <%-- Status Messages --%>
                <%
                    String success = request.getParameter("success");
                    String error = request.getParameter("error");
                    
                    if (success != null) {
                %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <strong>Success!</strong> Your registration has been submitted and is pending admin approval.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <% if (error != null) {
                        String message = "";
                        if ("disabled".equals(error)) {
                            message = "Candidate registration is currently disabled by administrators.";
                        } else if ("empty_fields".equals(error)) {
                            message = "Please fill all required fields.";
                        } else if ("duplicate".equals(error)) {
                            message = "Email or phone number already registered.";
                        } else if ("failed".equals(error)) {
                            message = "Registration failed. Please try again.";
                        } else if ("exception".equals(error)) {
                            message = "Something went wrong. Please try again.";
                        } else if ("invalid_email".equals(error)) {
                            message = "Please enter a valid email address.";
                        } else if ("invalid_phone".equals(error)) {
                            message = "Please enter a valid 10-digit phone number.";
                        } else if ("password_mismatch".equals(error)) {
                            message = "Passwords do not match.";
                        } else if ("password_weak".equals(error)) {
                            message = "Password is too weak. Please use a stronger password.";
                        }
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <%= message %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="form-container">
                    <form action="CandidateRegistrationServlet" method="post" id="registrationForm" class="form-fields">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="candidateName" class="form-label fw-bold">Full Name <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="candidateName" name="candidateName" 
                                       placeholder="Enter your full name" required maxlength="100">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="candidateEmail" class="form-label fw-bold">Email Address <span class="text-danger">*</span></label>
                                <input type="email" class="form-control" id="candidateEmail" name="candidateEmail" 
                                       placeholder="Enter your email" required maxlength="100">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="candidatePhone" class="form-label fw-bold">Phone Number <span class="text-danger">*</span></label>
                                <input type="tel" class="form-control" id="candidatePhone" name="candidatePhone" 
                                       placeholder="Enter your phone number" required maxlength="15"
                                       pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="candidateParty" class="form-label fw-bold">Political Party</label>
                                <input type="text" class="form-control" id="candidateParty" name="candidateParty" 
                                       placeholder="Enter party name (if any)" maxlength="100">
                            </div>
                        </div>

                        <!-- Password Fields -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="password" class="form-label fw-bold">Password <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="Create a strong password" required minlength="6"
                                           pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$"
                                           title="Password must contain at least 6 characters including uppercase, lowercase and number">
                                    <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('password')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="password-strength" id="passwordStrength"></div>
                                <div class="form-text">
                                    Password must contain at least 6 characters with uppercase, lowercase and number
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label fw-bold">Confirm Password <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                           placeholder="Confirm your password" required minlength="6">
                                    <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('confirmPassword')">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div id="passwordMatch" class="form-text"></div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="candidateDescription" class="form-label fw-bold">Description / Manifesto</label>
                            <textarea class="form-control" id="candidateDescription" name="candidateDescription" 
                                      rows="4" placeholder="Describe your candidacy, goals, and manifesto..."
                                      maxlength="500"></textarea>
                            <div class="form-text">Maximum 500 characters</div>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="termsAgreement" required>
                            <label class="form-check-label" for="termsAgreement">
                                I agree to the <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Terms and Conditions</a>
                                and confirm that all information provided is accurate.
                            </label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-register text-white" id="registerBtn">
                                <i class="fas fa-user-plus me-2"></i>Submit Registration
                            </button>
                        </div>
                    </form>

                    <div class="form-footer">
                        <div class="info-card">
                            <h6><i class="fas fa-info-circle me-2 text-primary"></i>Registration Process</h6>
                            <ul class="mb-0 small">
                                <li>All registrations require admin approval</li>
                                <li>You will be notified once your application is reviewed</li>
                                <li>Ensure all information provided is accurate</li>
                                <li>Contact administrators for any queries</li>
                                <li>Remember your password for future login</li>
                            </ul>
                        </div>

                        <div class="text-center mt-4">
                            <a href="index.html" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-home me-1"></i>Back to Home
                            </a>
                            <a href="candidate-login.jsp" class="btn btn-outline-primary btn-sm ms-2">
                                <i class="fas fa-sign-in-alt me-1"></i>Already Registered? Login
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Terms and Conditions Modal -->
    <div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="termsModalLabel">Terms and Conditions</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <h6>Candidate Registration Agreement</h6>
                    <p>By registering as a candidate, you agree to:</p>
                    <ul>
                        <li>Provide accurate and truthful information</li>
                        <li>Maintain ethical campaign practices</li>
                        <li>Accept the decision of the election administrators</li>
                        <li>Keep your login credentials secure and confidential</li>
                        <li>Abide by all election rules and regulations</li>
                    </ul>
                    <p>Your registration is subject to admin approval and may be rejected if found violating any terms.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Phone number formatting
        document.getElementById('candidatePhone').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
        });

        // Character counter for description
        const description = document.getElementById('candidateDescription');
        const charCount = document.createElement('div');
        charCount.className = 'form-text text-end';
        charCount.textContent = '0/500 characters';
        description.parentNode.appendChild(charCount);

        description.addEventListener('input', function() {
            charCount.textContent = this.value.length + '/500 characters';
        });

        // Password visibility toggle
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.parentNode.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'fas fa-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'fas fa-eye';
            }
        }

        // Password strength indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrength');
            let strength = 0;
            
            if (password.length >= 6) strength += 25;
            if (/[a-z]/.test(password)) strength += 25;
            if (/[A-Z]/.test(password)) strength += 25;
            if (/[0-9]/.test(password)) strength += 25;
            
            strengthBar.className = 'password-strength';
            if (strength <= 25) {
                strengthBar.classList.add('strength-weak');
            } else if (strength <= 50) {
                strengthBar.classList.add('strength-fair');
            } else if (strength <= 75) {
                strengthBar.classList.add('strength-good');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        });

        // Password match validation
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('passwordMatch');

        function validatePasswordMatch() {
            if (confirmPassword.value === '') {
                passwordMatch.textContent = '';
                passwordMatch.className = 'form-text';
            } else if (password.value === confirmPassword.value) {
                passwordMatch.textContent = '✓ Passwords match';
                passwordMatch.className = 'form-text text-success';
            } else {
                passwordMatch.textContent = '✗ Passwords do not match';
                passwordMatch.className = 'form-text text-danger';
            }
        }

        password.addEventListener('input', validatePasswordMatch);
        confirmPassword.addEventListener('input', validatePasswordMatch);

        // Form validation
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Check password match
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match. Please check and try again.');
                return;
            }
            
            // Check password strength
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long.');
                return;
            }
            
            // Show loading state
            const btn = document.getElementById('registerBtn');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Registering...';
            btn.disabled = true;
        });

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
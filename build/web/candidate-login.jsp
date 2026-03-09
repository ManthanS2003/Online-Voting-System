<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candidate Login - Bharat E-Voting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
            --success-color: #27ae60;
            --light-bg: #f8f9fa;
            --dark-text: #2c3e50;
            --shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        
    body {
        background: 
            linear-gradient(135deg, #0F2027 0%, #203A43 50%, #2C5364 100%),
            radial-gradient(circle at 20% 80%, rgba(255,255,255,0.1) 0%, transparent 50%),
            radial-gradient(circle at 80% 20%, rgba(255,255,255,0.05) 0%, transparent 50%);
        background-blend-mode: overlay, overlay, normal;
        min-height: 100vh;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        display: flex;
        align-items: center;
        padding: 20px 0;
    }

        
        .login-container {
            max-width: 900px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 20px;
            box-shadow: var(--shadow);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            overflow: hidden;
            display: flex;
            min-height: 500px;
        }
        
        .login-left {
            flex: 1;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
        }
        
        .login-left::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-color), var(--success-color));
        }
        
        .logo-container {
            width: 90px;
            height: 90px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }
        
        .logo-icon {
            font-size: 2.8rem;
            color: white;
        }
        
        .welcome-title {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 15px;
            line-height: 1.2;
        }
        
        .welcome-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .features-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .features-list li {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            font-size: 0.95rem;
        }
        
        .feature-icon {
            margin-right: 12px;
            font-size: 1rem;
            color: var(--success-color);
        }
        
        .login-right {
            flex: 1;
            padding: 50px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 35px;
        }
        
        .form-title {
            color: var(--primary-color);
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 8px;
        }
        
        .form-subtitle {
            color: #6c757d;
            font-size: 1rem;
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-label {
            font-weight: 600;
            color: var(--dark-text);
            margin-bottom: 8px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .input-group {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
            z-index: 5;
        }
        
        .form-control {
            padding: 14px 15px 14px 45px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: var(--light-bg);
        }
        
        .form-control:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background: white;
        }
        
        .btn-login {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            padding: 14px 30px;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
            width: 100%;
            color: white;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 10px;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(52, 152, 219, 0.3);
            color: white;
        }
        
        .action-links {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 25px;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .btn-action {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-register {
            background: linear-gradient(135deg, var(--success-color), #2ecc71);
            color: white;
            border: none;
        }
        
        .btn-forgot {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            border: none;
        }
        
        .btn-home {
            background: var(--light-bg);
            color: var(--dark-text);
            border: 1px solid #e9ecef;
        }
        
        .btn-action:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            color: white;
            text-decoration: none;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 25px;
            font-size: 0.9rem;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, #ffeaea, #ffcccc);
            color: #d63031;
            border-left: 4px solid var()(--accent-color);
        }
        
        .alert-success {
            background: linear-gradient(135deg, #e8f8ef, #d1f2eb);
            color: var(--success-color);
            border-left: 4px solid var()(--success-color);
        }
        
        .alert-warning {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border-left: 4px solid #ffc107;
        }
        
        /* Animation */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .login-left {
            animation: fadeIn 0.6s ease-out;
        }
        
        .login-right {
            animation: fadeIn 0.6s ease-out 0.2s both;
        }
        
        /* Loading state */
        .btn-loading {
            position: relative;
            color: transparent;
        }
        
        .btn-loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            top: 50%;
            left: 50%;
            margin-left: -10px;
            margin-top: -10px;
            border: 2px solid transparent;
            border-top-color: white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .login-card {
                flex-direction: column;
                min-height: auto;
            }
            
            .login-left {
                padding: 40px 30px;
            }
            
            .login-right {
                padding: 40px 30px;
            }
            
            .welcome-title {
                font-size: 1.8rem;
            }
            
            .action-links {
                flex-direction: column;
                align-items: stretch;
            }
            
            .btn-action {
                justify-content: center;
                text-align: center;
            }
        }
        
        @media (max-width: 576px) {
            .login-left, .login-right {
                padding: 30px 25px;
            }
            
            .welcome-title {
                font-size: 1.6rem;
            }
            
            .form-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="login-card">
                <!-- Left Side - Welcome Section -->
                <div class="login-left">
                    <div class="logo-container">
                        <i class="fas fa-user-tie logo-icon"></i>
                    </div>
                    
                    <h1 class="welcome-title">Candidate Portal Access</h1>
                    <p class="welcome-subtitle">
                        Secure login to manage your campaign, track votes, and connect with your constituents.
                    </p>
                    
                    <ul class="features-list">
                        <li>
                            <i class="fas fa-shield-alt feature-icon"></i>
                            <span>Secure & Encrypted Platform</span>
                        </li>
                        <li>
                            <i class="fas fa-chart-line feature-icon"></i>
                            <span>Real-time Vote Analytics</span>
                        </li>
                        <li>
                            <i class="fas fa-user-check feature-icon"></i>
                            <span>Admin-Verified Candidates Only</span>
                        </li>
                        <li>
                            <i class="fas fa-mobile-alt feature-icon"></i>
                            <span>Responsive Dashboard Access</span>
                        </li>
                        <li>
                            <i class="fas fa-key feature-icon"></i>
                            <span>Secure Password Authentication</span>
                        </li>
                    </ul>
                </div>

                <!-- Right Side - Login Form -->
                <div class="login-right">
                    <div class="form-header">
                        <h2 class="form-title">Candidate Sign In</h2>
                        <p class="form-subtitle">Enter your credentials to continue</p>
                    </div>

                    <%-- Error Messages --%>
                    <%
                        String error = request.getParameter("error");
                        if (error != null) {
                            String message = "";
                            if ("invalid".equals(error)) {
                                message = "Invalid email or password. Please try again.";
                            } else if ("not_approved".equals(error)) {
                                message = "Your candidate account is pending approval by administrators.";
                            } else if ("not_found".equals(error)) {
                                message = "No candidate account found with this email.";
                            } else if ("login_disabled".equals(error)) {
                                message = "Your account login is currently disabled. Please contact administrator.";
                            } else if ("required".equals(error)) {
                                message = "Please fill in all required fields.";
                            } else if ("exception".equals(error)) {
                                message = "System error. Please contact support if the problem persists.";
                            }
                    %>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Authentication Error:</strong> <%= message %>
                        </div>
                    <% } %>

                    <%-- Success Messages --%>
                    <%
                        String success = request.getParameter("success");
                        if (success != null) {
                            String message = "";
                            if ("logout".equals(success)) {
                                message = "You have been securely logged out.";
                            } else if ("password_reset".equals(success)) {
                                message = "Password reset successful! You can now login with your new password.";
                            } else if ("registered".equals(success)) {
                                message = "Registration submitted successfully! Please wait for admin approval.";
                            }
                    %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong>Success:</strong> <%= message %>
                        </div>
                    <% } %>

                    <form action="CandidateLoginServlet" method="post" id="loginForm">
                        <div class="form-group">
                            <label for="email" class="form-label">Email Address</label>
                            <div class="input-group">
                                <i class="fas fa-envelope input-icon"></i>
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder="candidate@example.com" required
                                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group">
                                <i class="fas fa-lock input-icon"></i>
                                <input type="password" class="form-control" id="password" name="password" 
                                       placeholder="Enter your password" required
                                       minlength="6">
                            </div>
                            <div class="form-text">
                                <small>Default password for new candidates: <code>candidate123</code></small>
                            </div>
                        </div>

                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="showPassword">
                            <label class="form-check-label" for="showPassword">
                                Show Password
                            </label>
                        </div>

                        <button type="submit" class="btn btn-login" id="loginBtn">
                            <i class="fas fa-sign-in-alt me-2"></i>Access Dashboard
                        </button>
                    </form>

                    <div class="action-links">
                        <a href="candidate-forgot-password.jsp" class="btn btn-action btn-forgot">
                            <i class="fas fa-key me-1"></i>Forgot Password?
                        </a>
                        <a href="candidate-register.jsp" class="btn btn-action btn-register">
                            <i class="fas fa-user-plus me-1"></i>New Candidate Registration
                        </a>
                        <a href="index.html" class="btn btn-action btn-home">
                            <i class="fas fa-home me-1"></i>Return to Homepage
                        </a>
                    </div>

                    <div class="mt-4 p-3 bg-light rounded">
                        <h6 class="fw-bold mb-2"><i class="fas fa-info-circle me-2 text-primary"></i>Login Information</h6>
                        <p class="small mb-1"><strong>New Candidates:</strong> Use default password provided during registration</p>
                        <p class="small mb-0"><strong>Approved Candidates:</strong> Reset password if forgotten using 'Forgot Password'</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form submission loading state
        document.getElementById('loginForm').addEventListener('submit', function() {
            const btn = document.getElementById('loginBtn');
            btn.classList.add('btn-loading');
            btn.disabled = true;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Authenticating...';
        });

        // Show/Hide Password
        document.getElementById('showPassword').addEventListener('change', function() {
            const passwordField = document.getElementById('password');
            if (this.checked) {
                passwordField.type = 'text';
            } else {
                passwordField.type = 'password';
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

        // Add focus effects
        const inputs = document.querySelectorAll('.form-control');
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.querySelector('.input-icon').style.color = 'var(--secondary-color)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.querySelector('.input-icon').style.color = 'var(--secondary-color)';
            });
        });

        // Auto-focus on email field
        document.getElementById('email').focus();
    </script>
</body>
</html>
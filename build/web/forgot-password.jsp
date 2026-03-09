<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Bharat E-Voting</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .forgot-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            max-width: 450px;
            margin: 50px auto;
        }
        .forgot-header {
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 30px;
            text-align: center;
        }
        .forgot-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .btn-reset {
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-reset:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(39, 133, 255, 0.3);
        }
        
        /* Responsive fixes */
        @media (max-width: 576px) {
            .forgot-container {
                margin: 20px 15px;
                max-width: none;
            }
            
            .forgot-header {
                padding: 20px;
            }
            
            .forgot-icon {
                width: 60px;
                height: 60px;
            }
            
            .forgot-icon i {
                font-size: 1.5rem !important;
            }
            
            .display-6 {
                font-size: 1.5rem;
            }
            
            .p-4 {
                padding: 20px !important;
            }
        }
        
        @media (max-width: 400px) {
            .forgot-header {
                padding: 15px;
            }
            
            .btn-reset {
                padding: 10px 20px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="forgot-container">
            <!-- Header -->
            <div class="forgot-header">
                <div class="forgot-icon">
                    <i class="fas fa-lock fa-2x text-white"></i>
                </div>
                <h1 class="display-6 fw-bold">Forgot Password</h1>
                <p class="lead mb-0">Reset your password using your registered phone number</p>
            </div>

            <!-- Content -->
            <div class="p-4">
                <%
                    String error = request.getParameter("error");
                    if (error != null) {
                        String message = "";
                        if ("empty".equals(error)) {
                            message = "Please enter your phone number";
                        } else if ("not_found".equals(error)) {
                            message = "No account found with this phone number";
                        } else if ("sms_failed".equals(error)) {
                            message = "Failed to send OTP. Please try again.";
                        } else if ("exception".equals(error)) {
                            message = "Something went wrong. Please try again.";
                        } else if ("session_expired".equals(error)) {
                            message = "Session expired. Please start again.";
                        }
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <%= message %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <form action="ForgotPasswordServlet" method="post">
                    <div class="mb-4">
                        <label for="phone" class="form-label fw-bold">Registered Phone Number</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-mobile-alt"></i>
                            </span>
                            <input type="tel" 
                                   class="form-control form-control-lg" 
                                   id="phone" 
                                   name="phone" 
                                   placeholder="Enter your registered phone number"
                                   pattern="[0-9]{10}"
                                   title="Please enter a valid 10-digit phone number"
                                   required>
                        </div>
                        <div class="form-text">
                            We'll send a 6-digit OTP to this number
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-reset text-white">
                            <i class="fas fa-paper-plane me-2"></i>Send OTP
                        </button>
                    </div>
                </form>

                <div class="text-center mt-4">
                    <p class="text-muted">
                        Remember your password? 
                        <a href="voter-login.jsp" class="text-decoration-none fw-bold">
                            Back to Login
                        </a>
                    </p>
                    <a href="index.html" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-home me-1"></i>Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Phone number formatting
        document.getElementById('phone').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
        });
    </script>
</body>
</html>
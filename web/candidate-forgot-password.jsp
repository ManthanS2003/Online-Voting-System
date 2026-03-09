<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Candidate</title>
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
            background: linear-gradient(135deg, #28a745, #20c997);
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
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-reset:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="forgot-container">
      
            <div class="forgot-header">
                <div class="forgot-icon">
                    <i class="fas fa-lock fa-2x text-white"></i>
                </div>
                <h1 class="display-6 fw-bold">Candidate Password Reset</h1>
                <p class="lead mb-0">Reset your password using your registered email</p>
            </div>

            <div class="p-4">
                <%
                    String error = request.getParameter("error");
                    if (error != null) {
                        String message = "";
                        if ("empty".equals(error)) {
                            message = "Please enter your email address";
                        } else if ("not_found".equals(error)) {
                            message = "No approved candidate found with this email";
                        } else if ("email_failed".equals(error)) {
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

                <form action="CandidateForgotPasswordServlet" method="post">
                    <div class="mb-4">
                        <label for="email" class="form-label fw-bold">Registered Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-envelope"></i>
                            </span>
                            <input type="email" 
                                   class="form-control form-control-lg" 
                                   id="email" 
                                   name="email" 
                                   placeholder="candidate@example.com"
                                   required>
                        </div>
                        <div class="form-text">
                            We'll send a 6-digit OTP to this email address
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
                        <a href="candidate-login.jsp" class="text-decoration-none fw-bold">
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
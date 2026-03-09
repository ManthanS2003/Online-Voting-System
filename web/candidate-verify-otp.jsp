<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - Candidate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .verify-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            max-width: 500px;
            margin: 50px auto;
        }
        .verify-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 30px;
            text-align: center;
        }
        .verify-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .otp-input {
            text-align: center;
            font-size: 1.5rem;
            font-weight: bold;
            letter-spacing: 8px;
        }
        .btn-verify {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            padding: 12px 30px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-verify:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(40, 167, 69, 0.3);
        }
        .countdown {
            font-size: 0.9rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="verify-container">
 
            <div class="verify-header">
                <div class="verify-icon">
                    <i class="fas fa-shield-alt fa-2x text-white"></i>
                </div>
                <h1 class="display-6 fw-bold">Verify OTP</h1>
                <p class="lead mb-0">Enter the 6-digit OTP sent to your email</p>
            </div>

   
            <div class="p-4">
                <%
                    String success = request.getParameter("success");
                    String error = request.getParameter("error");
                    
                    if (success != null) {
                        String message = "";
                        if ("otp_sent".equals(success)) {
                            message = "OTP has been sent to your registered email address";
                        } else if ("otp_resent".equals(success)) {
                            message = "New OTP has been sent to your email";
                        }
                %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <%= message %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>
                
                <% if (error != null) {
                        String message = "";
                        if ("empty".equals(error)) {
                            message = "Please enter OTP and new password";
                        } else if ("invalid_otp".equals(error)) {
                            message = "Invalid or expired OTP. Please try again.";
                        } else if ("password_mismatch".equals(error)) {
                            message = "Passwords do not match";
                        } else if ("password_short".equals(error)) {
                            message = "Password must be at least 6 characters long";
                        } else if ("update_failed".equals(error)) {
                            message = "Failed to reset password. Please try again.";
                        } else if ("email_failed".equals(error)) {
                            message = "Failed to send OTP. Please try again.";
                        } else if ("exception".equals(error)) {
                            message = "Something went wrong. Please try again.";
                        } else if ("session_expired".equals(error)) {
                            message = "Session expired. Please start again.";
                %>
                            <script>
                                setTimeout(function() {
                                    window.location.href = 'candidate-forgot-password.jsp';
                                }, 3000);
                            </script>
                <%
                        }
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <%= message %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="text-center mb-4">
                    <p class="text-muted">
                        OTP sent to: 
                        <strong>
                            <% 
                                String email = (String) session.getAttribute("candidateResetEmail");
                                if (email != null) {
                                    // Mask email for privacy
                                    String[] parts = email.split("@");
                                    if (parts.length == 2) {
                                        String username = parts[0];
                                        String domain = parts[1];
                                        if (username.length() > 2) {
                                            String maskedUsername = username.substring(0, 2) + "***" + username.substring(username.length() - 1);
                                            out.print(maskedUsername + "@" + domain);
                                        } else {
                                            out.print("***@" + domain);
                                        }
                                    } else {
                                        out.print(email);
                                    }
                                }
                            %>
                        </strong>
                    </p>
                </div>

                <form action="CandidateVerifyOTPServlet" method="post" id="verifyForm">
                  
                    <div class="mb-4">
                        <label for="otp" class="form-label fw-bold">6-Digit OTP</label>
                        <input type="text" 
                               class="form-control form-control-lg otp-input" 
                               id="otp" 
                               name="otp" 
                               maxlength="6"
                               pattern="[0-9]{6}"
                               title="Please enter 6-digit OTP"
                               placeholder="000000"
                               required>
                        <div class="form-text">
                            Enter the 6-digit code sent to your email
                        </div>
                    </div>

  
                    <div class="mb-3">
                        <label for="newPassword" class="form-label fw-bold">New Password</label>
                        <div class="input-group">
                            <input type="password" 
                                   class="form-control" 
                                   id="newPassword" 
                                   name="newPassword" 
                                   placeholder="Enter new password"
                                   minlength="6"
                                   required>
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

 
                    <div class="mb-4">
                        <label for="confirmPassword" class="form-label fw-bold">Confirm Password</label>
                        <div class="input-group">
                            <input type="password" 
                                   class="form-control" 
                                   id="confirmPassword" 
                                   name="confirmPassword" 
                                   placeholder="Confirm new password"
                                   minlength="6"
                                   required>
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                        <div id="passwordMatch" class="form-text"></div>
                    </div>

                    <div class="d-grid gap-2 mb-3">
                        <button type="submit" class="btn btn-verify text-white" id="submitBtn">
                            <i class="fas fa-check-circle me-2"></i>Reset Password
                        </button>
                    </div>
                </form>

          
                <form action="CandidateResendOTPServlet" method="post" class="text-center">
                    <p class="countdown mb-2" id="countdown">Resend OTP in: <span id="timer">10:00</span></p>
                    <button type="submit" class="btn btn-outline-success btn-sm" id="resendBtn" disabled>
                        <i class="fas fa-redo me-1"></i>Resend OTP
                    </button>
                </form>

                <div class="text-center mt-4">
                    <a href="candidate-forgot-password.jsp" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-arrow-left me-1"></i>Use Different Email
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
   
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


        const newPassword = document.getElementById('newPassword');
        const confirmPassword = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('passwordMatch');

        function validatePassword() {
            if (confirmPassword.value === '') {
                passwordMatch.textContent = '';
                passwordMatch.className = 'form-text';
            } else if (newPassword.value === confirmPassword.value) {
                passwordMatch.textContent = '✓ Passwords match';
                passwordMatch.className = 'form-text text-success';
            } else {
                passwordMatch.textContent = '✗ Passwords do not match';
                passwordMatch.className = 'form-text text-danger';
            }
        }

        newPassword.addEventListener('input', validatePassword);
        confirmPassword.addEventListener('input', validatePassword);


        document.getElementById('otp').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '');
        });

   
        let timeLeft = 600; 
        const timerElement = document.getElementById('timer');
        const resendBtn = document.getElementById('resendBtn');

        function updateTimer() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            timerElement.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            
            if (timeLeft > 0) {
                timeLeft--;
                setTimeout(updateTimer, 1000);
            } else {
                resendBtn.disabled = false;
                timerElement.textContent = 'Ready';
            }
        }

        updateTimer();

 
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('https://static.vecteezy.com/system/resources/previews/011/635/825/non_2x/abstract-square-interface-modern-background-concept-fingerprint-digital-scanning-visual-security-system-authentication-login-vector.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            height: 100vh;
            display: flex;
            align-items: center;
            position: relative;
        }
        
        /* Overlay for better readability */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: -1;
        }
        
        .login-container {
            max-width: 400px;
            margin: 0 auto;
            padding: 30px;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
        }
        
        .login-header {
            color: #2c3e50;
            margin-bottom: 25px;
        }
        
        .form-label {
            font-weight: 500;
            color: #2c3e50;
        }
        
        .btn-primary {
            background-color: #2785ff;
            border-color: #2785ff;
            padding: 10px;
            font-weight: 600;
        }
        
        .btn-primary:hover {
            background-color: #1a6fd8;
            border-color: #1a6fd8;
        }
        
        /* Responsive fixes */
        @media (max-width: 576px) {
            .login-container {
                margin: 20px 15px;
                padding: 20px;
            }
            
            .login-header {
                font-size: 1.5rem;
                margin-bottom: 20px;
            }
            
            body {
                align-items: flex-start;
                padding-top: 50px;
            }
        }
    </style>
</head>
<body>
    
    <div class="container">
        <div class="login-container">
            <h2 class="text-center mb-4 login-header">Admin Login</h2>
            
            <%
                String error = request.getParameter("error");
                if (error != null) {
                    String msg = "";
                    if ("invalid".equals(error)) {
                        msg = "Invalid username or password";
                    } else if ("required".equals(error)) {
                        msg = "Please enter both username and password";
                    } else if ("exception".equals(error)) {
                        msg = "Something went wrong. Please try again.";
                    }
            %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= msg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% } %>
            
            <form action="AdminLoginServlet" method="post">
                <div style="text-align: right; margin-bottom: 8px;">
                    <a href="index.html" style="display:inline-block; padding:6px 10px; font-size:14px; color:#374151; text-decoration:none; border:1px solid #d1d5db; border-radius:6px; background:#fff;">&larr; Back Home</a>
                </div>
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-lock me-2"></i>Login
                </button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
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
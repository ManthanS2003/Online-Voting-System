<%-- 
    Document   : voter-login
    Created on : 11 Aug, 2025, 1:21:23 AM
    Author     : Manth
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Voter Login</title>
   
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        padding: 0;
        height: 100vh;
      }

      .login-container {
        display: flex;
        height: 100%;
      }

      .login-left {
        background-color: #2785ff;
        width: 40%;
        padding: 20px;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
      }

      .login-right {
        background-color: white;
        width: 60%;
        padding: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-direction: column;
      }

      .login-right h1 {
        text-align: center;
        margin-bottom: 20px;
      }
      
      .forgot-password-link {
        color: #2785ff;
        text-decoration: none;
        font-weight: 500;
      }
      
      .forgot-password-link:hover {
        color: #1a6fd8;
        text-decoration: underline;
      }
      
      .alert {
        margin-bottom: 20px;
        width: 80%;
        max-width: 400px;
      }
    </style>
  </head>
  <body>
    <div class="login-container">
      <div class="login-left">
        <h1>Voter Login</h1>
        <p class="text-center">Secure and Transparent Voting System</p>
      </div>

      <div class="login-right">
        <h1>Voter Login</h1>
        
        <%-- Error Messages --%>
        <%
            String error = request.getParameter("error");
            if (error != null) {
                String message = "";
                String alertType = "danger";
                
                if ("invalid".equals(error)) {
                    message = "Invalid phone number or password. Please try again.";
                } else if ("required".equals(error)) {
                    message = "Please enter both phone number and password.";
                } else if ("exception".equals(error)) {
                    message = "System error. Please try again later.";
                } else if ("notfound".equals(error)) {
                    message = "Account not found. Please register first.";
                }
        %>
            <div class="alert alert-<%= alertType %> alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <%-- Success Messages --%>
        <%
            String success = request.getParameter("success");
            if (success != null) {
                String message = "";
                
                if ("registered".equals(success)) {
                    message = "Registration successful! You can now login.";
                } else if ("password_reset".equals(success)) {
                    message = "Password reset successful! You can now login with your new password.";
                }
        %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <form action="LoginServlet" method="post" style="width: 80%; max-width: 400px;">
          <div style="text-align: right; margin-bottom: 8px;">
            <a href="index.html" style="display:inline-block; padding:6px 10px; font-size:14px; color:#374151; text-decoration:none; border:1px solid #d1d5db; border-radius:6px; background:#fff;">&larr; Back Home</a>
          </div>
          
          <div class="mb-3">
            <label for="InputPhone" class="form-label">Phone Number</label>
            <input type="tel" class="form-control" name="mobile" id="InputPhone" 
                   pattern="[0-9]{10}" title="Please enter a valid 10-digit phone number"
                   required/>
            <div id="phoneHelp" class="form-text">
              Enter your registered 10-digit phone number
            </div>
          </div>
          
          <div class="mb-3">
            <label for="InputPassword1" class="form-label">Password</label>
            <input type="password" name="password" class="form-control" id="InputPassword1" 
                   required minlength="4"/>
            <div class="form-text">
              Enter your password
            </div>
          </div>
          
          <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="rememberMe" />
            <label class="form-check-label" for="rememberMe">Remember me</label>
          </div>
          
          <button type="submit" class="btn btn-primary w-100">
            <i class="fas fa-sign-in-alt me-2"></i>Login
          </button>
          
          <!-- Forgot Password Link -->
          <div class="text-center mt-3">
            <a href="forgot-password.jsp" class="forgot-password-link">
                <i class="fas fa-key me-1"></i>Forgot Password?
            </a>
          </div>
          
          <div class="signup-link mt-2">
            <p class="text-center">
              Don't have an account? <a href="voter-register.jsp">Sign Up</a>
            </p>
          </div>
        </form>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

        // Phone number validation
        document.getElementById('InputPhone').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '').substring(0, 10);
        });
    </script>
  </body>
</html>
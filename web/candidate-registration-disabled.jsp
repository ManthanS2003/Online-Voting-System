<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Disabled - Bharat E-Voting</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .disabled-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            max-width: 500px;
            margin: 100px auto;
            text-align: center;
            padding: 40px;
        }
        .disabled-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #ff6b6b, #ee5a52);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.html">
                <i class="fas fa-vote-yea me-2"></i>Bharat E-Voting
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="index.html">
                    <i class="fas fa-home me-1"></i>Home
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="disabled-container">
            <div class="disabled-icon">
                <i class="fas fa-ban fa-3x text-white"></i>
            </div>
            
            <h1 class="display-6 fw-bold text-danger mb-3">Registration Disabled</h1>
            <p class="lead text-muted mb-4">
                Candidate registration is currently disabled by the administrators.
            </p>
            
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Notice:</strong> New candidate registrations are not being accepted at this time.
                Please check back later or contact the election administrators for more information.
            </div>

            <div class="mt-4">
                <a href="index.html" class="btn btn-primary">
                    <i class="fas fa-home me-2"></i>Return to Home
                </a>
                <a href="contact-us.jsp" class="btn btn-outline-secondary ms-2">
                    <i class="fas fa-headset me-2"></i>Contact Support
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
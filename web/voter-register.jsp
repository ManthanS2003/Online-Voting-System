<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Get current date for max date calculation
    java.time.LocalDate currentDate = java.time.LocalDate.now();
    java.time.LocalDate maxDate = currentDate.minusYears(18);
    String maxDateStr = maxDate.toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voter Registration</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            display: flex;
            margin: 0;
            font-family: Arial, sans-serif; 
            min-height: 100vh;
            flex-direction: column;
        }
        .left-container {
            width: 100%;
            background: linear-gradient(to bottom, #2785ff, #0d6efd);
            padding: 20px;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            min-height: 200px;
        }
        .left-container h2 {
            font-size: 26px;
            text-align: center;
            margin-bottom: 20px;
        }
        .left-container p {
            font-size: 18px;
            text-align: center;
            max-width: 80%;
        }
        .right-container {
            width: 100%;
            background-color: #f8f9fa; 
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            flex: 1;
        }
        .form-container {
            width: 100%;
            max-width: 500px;
            border: 1px solid #e0e0e0;
            padding: 30px;
            border-radius: 15px;
            background-color: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        h3 {
            color: #2785ff;
            text-align: center;
            margin-bottom: 25px;
            font-size: 24px;
        }
        label {
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
            display: block;
        }
        input, select, textarea {
            width: 100%;
            padding: 12px;
            margin-top: 5px;
            margin-bottom: 18px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
        }
        input:focus, select:focus, textarea:focus {
            border-color: #2785ff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(39, 133, 255, 0.2);
        }
        button {
            width: 100%;
            background: linear-gradient(to right, #2785ff, #0d6efd);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
            transition: all 0.3s;
        }
        button:hover {
            background: linear-gradient(to right, #1c75e0, #0b5ed7);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        .button-login {
            margin-top: 20px;
            text-align: center;
            color: #666;
        }
        .button-login a {
            color: #2785ff;
            text-decoration: none;
            font-weight: bold;
        }
        .button-login a:hover {
            text-decoration: underline;
        }
        
        /* Message Styles */
        .alert {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-icon {
            margin-right: 10px;
            font-size: 20px;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        .form-row > div {
            flex: 1;
        }
        
        .required {
            color: red;
        }
        
        /* Success animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .alert {
            animation: fadeIn 0.5s ease;
        }
        
        /* Responsive fixes */
        @media (min-width: 768px) {
            body {
                flex-direction: row;
            }
            .left-container {
                width: 40%;
                min-height: 100vh;
            }
            .right-container {
                width: 60%;
                padding: 40px;
            }
        }
        
        @media (max-width: 576px) {
            .right-container {
                padding: 20px 15px;
            }
            
            .form-container {
                padding: 20px;
                margin: 0 10px;
            }
            
            h3 {
                font-size: 1.5rem;
                margin-bottom: 20px;
            }
            
            .left-container h2 {
                font-size: 1.5rem;
            }
            
            .left-container p {
                font-size: 1rem;
            }
            
            input, select, textarea {
                padding: 10px;
                font-size: 14px;
            }
            
            button {
                padding: 10px;
                font-size: 16px;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>
    <div class="left-container">
        <h2>Welcome to Bharat E-Voting</h2>
        <p>सुरक्षित और पारदर्शी मतदान में भाग लेने के लिए अपना पंजीकरण कराएं</p>
        <p>Register yourself to participate in secure and transparent voting.</p>
        <p><strong>Note:</strong> You must be 18 years or older to register.</p>
    </div>

    <div class="right-container">
        <div class="form-container">
            <h3>Voter Registration</h3>

            <% 
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                
                if (success != null) {
            %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle alert-icon"></i>
                    <div>
                        <strong>Registration Successful!</strong> You can now login with your credentials.
                    </div>
                </div>
            <% 
                } 
                
                if (error != null) {
                    String msg = "";
                    if ("failed".equals(error)) {
                        msg = "Registration failed. Please try again.";
                    } else if ("exception".equals(error)) {
                        msg = "Something went wrong. Please check your details.";
                    } else if ("duplicate".equals(error)) {
                        msg = "Email or mobile number already registered. Please use different credentials.";
                    } else if ("underage".equals(error)) {
                        msg = "You must be 18 years or older to register as a voter.";
                    } else if ("invalid_dob".equals(error)) {
                        msg = "Please enter a valid date of birth.";
                    } else if ("required".equals(error)) {
                        msg = "Please fill all required fields.";
                    }
            %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle alert-icon"></i>
                    <div>
                        <strong>Registration Error!</strong> <%= msg %>
                    </div>
                </div>
            <% } %>

            <form action="RegisterServlet" method="post" id="registrationForm"> 
                <div style="text-align: right; margin-bottom: 8px;">
                    <a href="index.html" style="display:inline-block; padding:6px 10px; font-size:14px; color:#374151; text-decoration:none; border:1px solid #d1d5db; border-radius:6px; background:#fff;">&larr; Back Home</a>
                </div>
                
                <label for="name">Full Name <span class="required">*</span></label>
                <input type="text" id="name" name="name" placeholder="Enter your full name" required>

                <div class="form-row">
                    <div>
                        <label for="email">Email <span class="required">*</span></label>
                        <input type="email" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                    <div>
                        <label for="mobile">Mobile Number <span class="required">*</span></label>
                        <input type="tel" id="mobile" name="mobile" placeholder="Enter mobile number" required
                               pattern="[0-9]{10}" title="Please enter a valid 10-digit mobile number">
                    </div>
                </div>

                <label for="dob">Date of Birth <span class="required">*</span></label>
                <input type="date" id="dob" name="dob" required 
                       max="<%= maxDateStr %>"
                       onchange="calculateAge()">
                <div id="ageDisplay" class="form-text" style="margin-top: -10px; margin-bottom: 15px;"></div>

                <label for="voting_area">Voting Area/Constituency <span class="required">*</span></label>
                <select id="voting_area" name="voting_area" required>
                    <option value="">Select Your Voting Area</option>
                    <option value="North Delhi">North Delhi</option>
                    <option value="South Delhi">South Delhi</option>
                    <option value="East Delhi">East Delhi</option>
                    <option value="West Delhi">West Delhi</option>
                    <option value="Central Delhi">Central Delhi</option>
                    <option value="New Delhi">New Delhi</option>
                    <option value="Other">Other Area</option>
                </select>

                <label for="address">Complete Address <span class="required">*</span></label>
                <textarea id="address" name="address" rows="3" placeholder="Enter your complete address with PIN code" required></textarea>
                
                <label for="password">Password <span class="required">*</span></label>
                <input type="password" id="password" name="password" placeholder="Create a strong password" required
                       minlength="6" title="Password must be at least 6 characters">
                
                <button type="submit" id="registerBtn">
                    <i class="fas fa-user-plus"></i> Register as Voter
                </button>

                <div class="button-login">
                    <p>Already have an account? <a href="voter-login.jsp">Login here</a></p>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Calculate age from date of birth
        function calculateAge() {
            const dobInput = document.getElementById('dob');
            const ageDisplay = document.getElementById('ageDisplay');
            
            if (dobInput.value) {
                const birthDate = new Date(dobInput.value);
                const today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                const monthDiff = today.getMonth() - birthDate.getMonth();
                
                if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                
                if (age < 18) {
                    ageDisplay.innerHTML = `<span style="color: red;">Age: ${age} years - You must be 18 or older to register</span>`;
                    document.getElementById('registerBtn').disabled = true;
                } else {
                    ageDisplay.innerHTML = `<span style="color: green;">Age: ${age} years - Eligible to vote</span>`;
                    document.getElementById('registerBtn').disabled = false;
                }
            } else {
                ageDisplay.innerHTML = '';
                document.getElementById('registerBtn').disabled = false;
            }
        }

        // Simple form validation
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            const dob = document.getElementById('dob').value;
            if (!dob) {
                e.preventDefault();
                alert('Please enter your date of birth.');
                return;
            }
            
            document.getElementById('registerBtn').disabled = true;
            document.getElementById('registerBtn').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Registering...';
        });
        
        // Phone number validation
        document.getElementById('mobile').addEventListener('input', function(e) {
            this.value = this.value.replace(/\D/g, '').substring(0, 10);
        });
        
        // Clear error messages after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                alert.style.display = 'none';
            });
        }, 5000);
    </script>
</body>
</html>
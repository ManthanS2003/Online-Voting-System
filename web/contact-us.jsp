<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - Bharat E-Voting System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .contact-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        .contact-header {
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 30px;
        }
        .contact-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
        }
        .feature-card {
            border: none;
            border-radius: 15px;
            transition: transform 0.3s ease;
            background: #f8f9fa;
        }
        .feature-card:hover {
            transform: translateY(-5px);
        }
        .btn-contact {
            background: linear-gradient(135deg, #2785ff, #0d6efd);
            border: none;
            padding: 15px 40px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: all 0.3s ease;
        }
        .btn-contact:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(39, 133, 255, 0.3);
        }
        
        /* Responsive fixes */
        @media (max-width: 768px) {
            .contact-header {
                padding: 20px;
            }
            
            .contact-icon {
                width: 60px;
                height: 60px;
            }
            
            .contact-icon i {
                font-size: 1.5rem !important;
            }
            
            .display-5 {
                font-size: 1.75rem;
            }
            
            .p-5 {
                padding: 30px 20px !important;
            }
            
            .feature-card {
                margin-bottom: 15px;
            }
        }
        
        @media (max-width: 576px) {
            .contact-header {
                padding: 15px;
            }
            
            .btn-contact {
                padding: 12px 30px;
                font-size: 1rem;
                width: 100%;
            }
            
            .container.my-5 {
                margin: 20px auto !important;
            }
            
            .contact-container {
                margin: 0 10px;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
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

    <div class="container my-5">
        <div class="contact-container">
            <!-- Header -->
            <div class="contact-header text-center">
                <div class="contact-icon">
                    <i class="fas fa-headset fa-2x text-white"></i>
                </div>
                <h1 class="display-5 fw-bold">Contact Us</h1>
                <p class="lead mb-0">We're here to help you with any questions or concerns</p>
            </div>

            <!-- Content -->
            <div class="p-5">
                <div class="row mb-5">
                    <div class="col-md-8 mx-auto text-center">
                        <h3 class="mb-4">Get in Touch</h3>
                        <p class="text-muted mb-4">
                            Have questions about the Bharat E-Voting System? Need technical support? 
                            Want to provide feedback? Use our Google Form to contact us directly. 
                            We'll get back to you as soon as possible.
                        </p>
                    </div>
                </div>

                <!-- Contact Options -->
                <div class="row mb-5">
                    <div class="col-md-4 mb-4">
                        <div class="card feature-card h-100 text-center p-4">
                            <i class="fas fa-envelope fa-3x text-primary mb-3"></i>
                            <h5>Email Support</h5>
                            <p class="text-muted">Send us an email for general inquiries</p>
                            <p class="fw-bold text-primary">info@bharatevote.com</p>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="card feature-card h-100 text-center p-4">
                            <i class="fas fa-phone fa-3x text-primary mb-3"></i>
                            <h5>Phone Support</h5>
                            <p class="text-muted">Call us for immediate assistance</p>
                            <p class="fw-bold text-primary">+91 1234567890</p>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="card feature-card h-100 text-center p-4">
                            <i class="fas fa-clock fa-3x text-primary mb-3"></i>
                            <h5>Support Hours</h5>
                            <p class="text-muted">Monday - Friday: 9:00 AM - 6:00 PM</p>
                            <p class="text-muted">Saturday: 10:00 AM - 2:00 PM</p>
                        </div>
                    </div>
                </div>

                <!-- Google Form Redirect -->
                <div class="text-center py-4" style="background: linear-gradient(135deg, #f8f9fa, #e9ecef); border-radius: 15px;">
                    <h4 class="mb-3">Contact Us via Google Form</h4>
                    <p class="text-muted mb-4">
                        Fill out our Google Form to send us a detailed message. This helps us serve you better.
                    </p>
                    <a href="https://docs.google.com/forms/d/e/1FAIpQLScqGyPJdBA0Xp5ntRe9HAL1FNIYRYapGPC0BxFSGEJ3MM8SFg/viewform?usp=header" 
                       target="_blank" 
                       class="btn btn-contact text-white">
                        <i class="fas fa-external-link-alt me-2"></i>Open Contact Form
                    </a>
                    <p class="mt-3 text-muted">
                        <small><i class="fas fa-info-circle me-1"></i>Opens in a new window</small>
                    </p>
                </div>

                <!-- FAQ Section -->
                <div class="row mt-5">
                    <div class="col-lg-10 mx-auto">
                        <h4 class="text-center mb-4">Frequently Asked Questions</h4>
                        <div class="accordion" id="faqAccordion">
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">
                                        How long does it take to get a response?
                                    </button>
                                </h2>
                                <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        We typically respond within 24-48 hours during business days.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq2">
                                        What information should I include in my message?
                                    </button>
                                </h2>
                                <div id="faq2" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Please include your name, contact information, and a detailed description of your query or issue.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#faq3">
                                        Can I contact for technical support?
                                    </button>
                                </h2>
                                <div id="faq3" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Yes, we provide technical support for all voting system related issues.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-4 mt-5">
        <div class="container">
            <p>&copy; 2025 Bharat E-Voting System. All rights reserved.</p>
            <p>Made with <i class="fas fa-heart text-danger"></i> for India</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
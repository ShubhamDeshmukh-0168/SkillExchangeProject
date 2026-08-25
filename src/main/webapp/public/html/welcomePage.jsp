<%@ page import="javabean.UserDataBean" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Welcome to SkillExchange</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #6F69E8;
            --secondary-color: #FB4899;
            --bg-light: #f8f9fa;
            --text-dark: #333;
            --card-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* Updated Navbar Styles - Transparent with logo left and toggle right */
        .navbar {
            background: transparent !important;
            padding: 1rem;
            transition: all 0.3s ease;
            position: absolute;
            width: 100%;
            z-index: 1000;
        }

        .navbar.scrolled {
            background: rgba(255,255,255,0.95) !important;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }

        .navbar-brand img {
            height: 70px;
            transition: all 0.3s ease;
        }

        .navbar-brand img:hover {
            transform: scale(1.05);
        }

        .navbar-toggler {
            border: none;
            padding: 0.25rem;
            color: white;
            font-size: 3rem;
        }

        .navbar.scrolled .navbar-toggler {
            color: var(--text-dark);
        }

        .navbar-toggler:focus {
            box-shadow: none;
        }

        .offcanvas-profile-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--primary-color);
            margin-bottom: 1rem;
        }

        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, rgba(111, 105, 232, 0.8), rgba(251, 72, 153, 0.7)), 
                        url('https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=2071&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            min-height: 100vh;
            display: flex;
            align-items: center;
            color: white;
            padding-top: 60px;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            z-index: 2;
            position: relative;
        }

        .hero-title {
            font-size: 3.5rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 1.5rem;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.2);
        }

        .hero-subtitle {
            font-size: 1.5rem;
            margin-bottom: 2.5rem;
            max-width: 700px;
            opacity: 0.9;
        }

        .btn-hero-primary {
            background: white;
            color: var(--primary-color);
            font-weight: 600;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border: none;
        }

        .btn-hero-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .btn-hero-secondary {
            background: transparent;
            color: white;
            border: 2px solid white;
            font-weight: 600;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }

        .btn-hero-secondary:hover {
            background: rgba(255,255,255,0.1);
            transform: translateY(-3px);
            color: white;
        }

        /* Features Section */
        .features-section {
            padding: 6rem 0;
            background: white;
        }

        .section-title {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 3rem;
            color: var(--primary-color);
            position: relative;
            display: inline-block;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 60px;
            height: 4px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border-radius: 2px;
        }

        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 2.5rem;
            height: 100%;
            box-shadow: var(--card-shadow);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: none;
            text-align: center;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.12);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
        }

        /* Popular Skills Section */
        .skills-section {
            padding: 6rem 0;
            background: var(--bg-light);
        }

        .skill-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            height: 100%;
            border: none;
        }

        .skill-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .skill-img {
            height: 180px;
            object-fit: cover;
            width: 100%;
        }

        .skill-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: var(--secondary-color);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        /* Testimonials Section */
        .testimonials-section {
            padding: 6rem 0;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            position: relative;
            overflow: hidden;
        }

        .testimonial-card {
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2rem;
            height: 100%;
            transition: all 0.3s ease;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .testimonial-card:hover {
            transform: translateY(-5px);
            background: rgba(255,255,255,0.2);
        }

        .user-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            margin-bottom: 1.5rem;
        }

        /* CTA Section */
        .cta-section {
            padding: 6rem 0;
            background: white;
        }

        .cta-card {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 15px;
            padding: 4rem;
            color: white;
            text-align: center;
            box-shadow: 0 15px 35px rgba(111, 105, 232, 0.2);
        }

        /* Responsive Adjustments */
        @media (max-width: 992px) {
            .hero-title {
                font-size: 2.8rem;
            }
            
            .hero-subtitle {
                font-size: 1.2rem;
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.2rem;
            }
            
            .navbar {
                padding: 1rem;
            }
            
            .navbar-brand img {
                height: 28px;
            }
        }

        @media (max-width: 576px) {
            .hero-title {
                font-size: 1.8rem;
            }
            
            .hero-subtitle {
                font-size: 1rem;
            }
            
            .btn-hero-primary, 
            .btn-hero-secondary {
                padding: 0.6rem 1.5rem;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>

<%
    // Session check
    if (session == null || session.getAttribute("userbean") == null) {
        response.sendRedirect(request.getContextPath() + "/public/html/userlogin.jsp");
        return;
    }

    // Prevent back navigation after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Get user data
    UserDataBean ub = (UserDataBean) session.getAttribute("userbean");
    String userName = ub.getUsername();
    long phNo = ub.getPhno();
    String destiny = (phNo == 0) ? "startJourneyForm.html" : request.getContextPath() + "/allUsersServlet";
%>

<nav class="navbar fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">
            <img src="../assets/image/Header-logo.png" alt="SkillExchange Logo" class="logo">
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" 
                data-bs-target="#offcanvasNavbar" aria-controls="offcanvasNavbar">
            <i class="bi bi-list"></i>
        </button>
        
       
        <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasNavbarLabel">Menu</h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <div class="text-center mb-4">
                    <img src="<%=request.getContextPath()%>/userImage?username=<%=java.net.URLEncoder.encode(userName, "UTF-8")%>" 
                         alt="Profile" class="offcanvas-profile-img">
                    <h5 class="mt-2">Hi, <%= userName %></h5>
                </div>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="<%=request.getContextPath()%>/view?username=<%=userName%>">
                            <i class="bi bi-person me-2"></i>Profile
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="settingPage.html">
                            <i class="bi bi-gear me-2"></i>Settings
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="helpPage.html">
                            <i class="bi bi-question-circle me-2"></i>Help
                        </a>
                    </li>
                    <li class="nav-item mt-3">
                        <a class="btn btn-outline-danger w-100" href="<%=request.getContextPath()%>/logoutServlet">
                            <i class="bi bi-box-arrow-right me-2"></i>Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>
<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8 hero-content">
                <h1 class="hero-title">Share Your Skills, Grow Together</h1>
                <p class="hero-subtitle">Join our community where knowledge is exchanged, not bought. Teach what you know, learn what you don't, and grow together with like-minded individuals.</p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="<%= destiny %>" class="btn btn-hero-primary">
                        <i class="bi bi-arrow-right me-2"></i> Start Your Journey
                    </a>
                    <a href="about.html" class="btn btn-hero-secondary">
                        <i class="bi bi-info-circle me-2"></i> Learn More
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section">
    <div class="container">
        <h2 class="section-title text-center mb-5">Why SkillExchange?</h2>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <h3 class="h4 mb-3">Community Learning</h3>
                    <p>Connect with passionate individuals who are eager to share knowledge and learn from others in a supportive environment.</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-currency-exchange"></i>
                    </div>
                    <h3 class="h4 mb-3">Skill Bartering</h3>
                    <p>Exchange your expertise for new skills without monetary transactions. Your knowledge is your currency.</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="bi bi-graph-up-arrow"></i>
                    </div>
                    <h3 class="h4 mb-3">Personal Growth</h3>
                    <p>Expand your skill set, build meaningful connections, and accelerate your personal and professional development.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Popular Skills Section -->
<section class="skills-section">
    <div class="container">
        <h2 class="section-title text-center mb-5">Popular Skills to Exchange</h2>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="skill-card">
                    <div class="position-relative">
                        <img src="https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=2070&auto=format&fit=crop" 
                             alt="Programming" class="skill-img">
                        <span class="skill-badge">High Demand</span>
                    </div>
                    <div class="p-4">
                        <h3 class="h5">Programming</h3>
                        <p>Exchange coding skills in Java, Python, JavaScript and more with fellow developers.</p>
                        <a href="#" class="btn btn-sm btn-outline-primary">Find Partners</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="skill-card">
                    <div class="position-relative">
                        <img src="https://images.unsplash.com/photo-1546410531-bb4caa6b424d?q=80&w=2070&auto=format&fit=crop" 
                             alt="Design" class="skill-img">
                        <span class="skill-badge">Trending</span>
                    </div>
                    <div class="p-4">
                        <h3 class="h5">Graphic Design</h3>
                        <p>Share your design expertise or learn tools like Photoshop, Illustrator, and Figma.</p>
                        <a href="#" class="btn btn-sm btn-outline-primary">Find Partners</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="skill-card">
                    <div class="position-relative">
                        <img src="https://images.unsplash.com/photo-1542621334-a254cf47733d?q=80&w=2070&auto=format&fit=crop" 
                             alt="Languages" class="skill-img">
                        <span class="skill-badge">Popular</span>
                    </div>
                    <div class="p-4">
                        <h3 class="h5">Language Learning</h3>
                        <p>Practice speaking with native speakers and exchange language teaching.</p>
                        <a href="#" class="btn btn-sm btn-outline-primary">Find Partners</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="testimonials-section">
    <div class="container">
        <h2 class="text-center mb-5" style="color: white;">What Our Community Says</h2>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="testimonial-card">
                    <img src="../../public/assets/image/review-2.jpeg" alt="User" class="user-img">
                    <h3 class="h5">Priya Halke</h3>
                    <p class="mb-0">"I taught web development and in return learned graphic design. It's amazing how much you can grow through skill exchange!"</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="testimonial-card">
                    <img src="../../public/assets/image/review-1.jpeg" alt="User" class="user-img">
                    <h3 class="h5">Harun Patel</h3>
                    <p class="mb-0">"As a recent graduate, this platform helped me learn new skills without spending money. Highly recommended!"</p>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="testimonial-card">
                    <img src="../../public/assets/image/review-3.jpeg" alt="User" class="user-img">
                    <h3 class="h5">Amrita Sutte</h3>
                    <p class="mb-0">"The community is so supportive. I've made friends while expanding my skill set. Win-win!"</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="cta-card">
                    <h2 class="mb-4">Ready to Start Your Skill Exchange Journey?</h2>
                    <p class="mb-4">Join thousands of learners and teachers who are growing together through knowledge sharing.</p>
                    <a href="<%= destiny %>" class="btn btn-light btn-lg rounded-pill px-4">
                        Get Started Now <i class="bi bi-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white py-5">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-4 mb-lg-0">
                <img src="../assets/image/Header-logo.png" alt="Logo" width="160" class="mb-3">
                <p>SkillExchange - Where knowledge is shared, not sold. Join our community of lifelong learners.</p>
            </div>
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="mb-3">Quick Links</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Home</a></li>
                    <li class="mb-2"><a href="about.html" class="text-white-50 text-decoration-none">About</a></li>
                    <li class="mb-2"><a href="about.html" class="text-white-50 text-decoration-none">Contact</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-6 mb-4 mb-md-0">
                <h5 class="mb-3">Support</h5>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="helpPage.html" class="text-white-50 text-decoration-none">Help Center</a></li>
                    <li class="mb-2"><a href="settingPage.html" class="text-white-50 text-decoration-none">Settings</a></li>
                </ul>
            </div>
            <div class="col-lg-4">
                <h5 class="mb-3">Connect With Us</h5>
                <div class="d-flex gap-3 mb-3">
                    <a href="#" class="text-white"><i class="bi bi-facebook fs-4"></i></a>
                    <a href="#" class="text-white"><i class="bi bi-twitter-x fs-4"></i></a>
                    <a href="#" class="text-white"><i class="bi bi-instagram fs-4"></i></a>
                    <a href="#" class="text-white"><i class="bi bi-linkedin fs-4"></i></a>
                </div>
                <p class="text-white-50 small">&copy; 2025 SkillExchange. All rights reserved.</p>
            </div>
        </div>
    </div>
</footer>

<!-- Back to Top Button -->
<a href="#" class="back-to-top-btn position-fixed d-flex align-items-center justify-content-center bg-primary text-white rounded-circle" style="width: 50px; height: 50px; bottom: 30px; right: 30px;">
    <i class="bi bi-arrow-up"></i>
</a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Navbar scroll effect
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });

    // Back to top button
    const backToTopBtn = document.querySelector('.back-to-top-btn');
    window.addEventListener('scroll', function() {
        if (window.scrollY > 300) {
            backToTopBtn.style.opacity = '1';
            backToTopBtn.style.visibility = 'visible';
        } else {
            backToTopBtn.style.opacity = '0';
            backToTopBtn.style.visibility = 'hidden';
        }
    });

    backToTopBtn.addEventListener('click', function(e) {
        e.preventDefault();
        window.scrollTo({top: 0, behavior: 'smooth'});
    });
</script>
</body>
</html>
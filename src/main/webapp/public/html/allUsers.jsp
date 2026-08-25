<%@ page import="java.util.Set" %>
<%@ page import="javabean.UserDataBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Set<UserDataBean> users = (Set<UserDataBean>) session.getAttribute("allUsers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SkillExchange - Discover Users</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #6F69E8;
            --secondary-color: #FB4899;
            --bg-light: #f8f9fa;
            --text-dark: #333;
            --card-shadow: 0 10px 30px rgba(111, 105, 232, 0.15);
            --card-shadow-hover: 0 15px 35px rgba(111, 105, 232, 0.25);
            --section-padding: 4rem;
        }
        
        body {
            background-color: var(--bg-light);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding-bottom: 5rem;
        }
        
        .discover-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: var(--section-padding) 0;
            margin-bottom: 3rem;
            position: relative;
            overflow: hidden;
            border-radius: 0 0 30px 30px;
        }
        
        .discover-header::before {
            content: '';
            position: absolute;
            bottom: -50px;
            left: 0;
            width: 100%;
            height: 100px;
            background: var(--bg-light);
            transform: skewY(-3deg);
            z-index: 1;
        }
        
        .discover-title {
            position: relative;
            z-index: 2;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.2);
        }
        
        .search-container {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
            position: relative;
            z-index: 3;
            margin-top: -2rem;
        }
        
        .user-card {
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            margin-bottom: 2rem;
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            position: relative;
            background: white;
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        
        .user-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--card-shadow-hover);
        }
        
        .user-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 8px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
        }
        
        .card-body {
            padding: 1.2rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .profile-img-container {
            width: 120px;
            height: 120px;
            margin: 0px auto 1.5rem;
            position: relative;
            z-index: 2;
        }
        
        .profile-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border: 5px solid white;
            border-radius: 50%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .user-card:hover .profile-img {
            transform: scale(1.05);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        
        .user-name {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 0.5rem;
            font-size: 1.3rem;
        }
        
        .username {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }
        
        .skill-section {
            margin-bottom: 1rem;
            flex: 1;
        }
        
        .skill-title {
            font-size: 0.9rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .skill-badge {
            border-radius: 20px;
            padding: 0.5rem 1rem;
            font-weight: 500;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
            display: inline-block;
            font-size: 0.85rem;
        }
        
        .teaches-badge {
            background: rgba(111, 105, 232, 0.1);
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
        }
        
        .learns-badge {
            background: rgba(251, 72, 153, 0.1);
            color: var(--secondary-color);
            border: 1px solid var(--secondary-color);
        }
        
        .rating-section {
            margin-bottom: 1rem;
        }
        
        .rating-stars {
            color: #FFD700;
            font-size: 1rem;
            letter-spacing: 2px;
        }
        
        .action-buttons {
            margin-top: auto;
            display: flex;
            gap: 0.75rem;
            justify-content: center;
        }
        
        .btn-contact {
            border-radius: 50px;
            padding: 0.5rem 1.25rem;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.9rem;
            flex: 1;
            justify-content: center;
            max-width: 150px;
        }
        
        .btn-email {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
        }
        
        .btn-email:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(111, 105, 232, 0.3);
            color: white;
        }
        
        .btn-whatsapp {
            background: white;
            color: #25D366;
            border: 1px solid #25D366;
        }
        
        .btn-whatsapp:hover {
            background: #25D366;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(37, 211, 102, 0.3);
        }
        
        .no-users {
            background: white;
            border-radius: 15px;
            padding: 3rem;
            text-align: center;
            box-shadow: var(--card-shadow);
            margin-top: 2rem;
        }
        
        .no-users-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }
        
        .back-to-home-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            z-index: 1000;
            transition: all 0.3s ease;
        }
        
        .back-to-home-btn:hover {
            transform: translateY(-5px) scale(1.1);
            box-shadow: 0 8px 25px rgba(0,0,0,0.3);
            color: white;
        }
        
        /* Improved grid layout */
        .users-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 2rem;
            padding: 1rem 0;
        }
        
        @media (max-width: 768px) {
            .profile-img-container {
                width: 100px;
                height: 100px;
                margin-top: -50px;
            }
            
            .back-to-home-btn {
                width: 50px;
                height: 50px;
                font-size: 1.2rem;
                bottom: 20px;
                right: 20px;
            }
            
            .discover-header {
                padding: 3rem 0;
            }
            
            .search-container {
                padding: 1rem;
            }
            
            .users-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <!-- Header Section -->
    <header class="discover-header text-center">
        <div class="container">
            <h1 class="discover-title display-4 fw-bold mb-3">Discover SkillExchange Users</h1>
            <p class="lead">Connect with fellow learners and teachers in our community</p>
        </div>
    </header>

    <div class="container">
        <!-- Search and Filter Section -->
        <div class="search-container">
    <div class="row g-3">
        <div class="col-md-10">
            <div class="input-group">
                <span class="input-group-text bg-white border-end-0">
                    <i class="bi bi-search text-muted"></i>
                </span>
                <input type="text" class="form-control border-start-0" placeholder="Search by name, username or skill" id="searchInput">
            </div>
        </div>
        <div class="col-md-2">
            <button onclick="searchUsers()" class="btn btn-primary w-100" style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); border: none;">
                Search
            </button>
        </div>
    </div>
</div>


        <!-- User Cards Grid -->
        <div class="users-grid">
            <%
                if (users != null && !users.isEmpty()) {
                    for (UserDataBean user : users) {
                        if(user.getSkillToLearn() != null) {
            %>
            <div class="user-card">
                <div class="card-body text-center">
                    <div class="profile-img-container">
                        <img 
                            src="<%= request.getContextPath() %>/userImage?username=<%= user.getUsername() %>" 
                            alt="<%= user.getFname() %>'s profile" 
                            class="profile-img"
                            onerror="this.onerror=null;this.src='<%= request.getContextPath() %>/public/assets/image/default-profile.png';"
                        />
                    </div>
                    
                    <h3 class="user-name"><%= user.getFname() %> <%= user.getLname() %></h3>
                    <p class="username">@<%= user.getUsername() %></p>

                    <div class="skill-section">
                        <h5 class="skill-title">Teaches</h5>
                        <span class="skill-badge teaches-badge">
                            <%= user.getSkillToTeach() %>
                        </span>
                    </div>

                    <div class="skill-section">
                        <h5 class="skill-title">Wants to Learn</h5>
                        <span class="skill-badge learns-badge">
                            <%= user.getSkillToLearn() %>
                        </span>
                    </div>

                    <div class="rating-section">
                        <h5 class="skill-title">Skill Level</h5>
                        <div class="rating-stars">
                            <% for (int i = 0; i < user.getRating(); i++) { %>
                                <i class="bi bi-star-fill"></i>
                            <% } %>
                            <% for (int i = user.getRating(); i < 10; i++) { %>
                                <i class="bi bi-star"></i>
                            <% } %>
                        </div>
                    </div>

                    <div class="action-buttons">
                        <a href="mailto:<%= user.getEmail() %>" class="btn btn-contact btn-email">
                            <i class="bi bi-envelope-fill"></i> Email
                        </a>
                        <a href="https://wa.me/<%= user.getPhno() %>" target="_blank" class="btn btn-contact btn-whatsapp">
                            <i class="bi bi-whatsapp"></i> Chat
                        </a>
                    </div>
                </div>
            </div>
            <%
                        }
                    }
                } else {
            %>
            <div class="no-users">
                <div class="no-users-icon"><i class="bi bi-people-fill"></i></div>
                <h4>No users found!</h4>
                <p class="text-muted">It looks like no users are currently available.</p>
                <a href="home.jsp" class="btn btn-primary mt-3">
                    <i class="bi bi-arrow-left"></i> Back to Home
                </a>
            </div>
            <%
                }
            %>
        </div>
    </div>

    <!-- Back to Home Floating Button -->
    <a href="welcomePage.jsp" class="back-to-home-btn" title="Back to Home">
        <i class="bi bi-house-door-fill"></i>
    </a>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
<script>
    function searchUsers() {
        const input = document.getElementById("searchInput").value.toLowerCase();
        const cards = document.querySelectorAll(".user-card");

        cards.forEach(card => {
            const name = card.querySelector(".user-name").textContent.toLowerCase();
            const username = card.querySelector(".username").textContent.toLowerCase();
            const skills = card.querySelector(".skill-section").textContent.toLowerCase();

            if (name.includes(input) || username.includes(input) || skills.includes(input)) {
                card.style.display = "flex";
            } else {
                card.style.display = "none";
            }
        });
    }
</script>

</body>
</html>
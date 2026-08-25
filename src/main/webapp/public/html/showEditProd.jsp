<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="javabean.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update Profile</title>
<link rel="icon" type="image/x-icon" href="public/assets/image/profile/fav-img.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<style>
    :root {
        --primary-color: #6F69E8;
        --secondary-color: #FB4899;
        --bg-light: #f8f9fa;
        --text-dark: #333;
        --border-color: #e0e0e0;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: var(--bg-light);
        color: var(--text-dark);
        line-height: 1.6;
    }

    .profile-header {
        height: 250px;
        background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        position: relative;
        overflow: hidden;
    }

    .profile-header::before {
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

    .profile-container {
        max-width: 800px;
        margin: -200px auto 50px;
        position: relative;
        z-index: 2;
    }

    .profile-card {
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        overflow: visible;
        background: white;
        padding-bottom: 30px;
    }

    .profile-pic-container {
        width: 180px;
        height: 180px;
        margin: -90px auto 20px;
        position: relative;
        z-index: 3;
    }

    .profile-pic {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border: 5px solid white;
        border-radius: 50%;
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .profile-pic:hover {
        transform: scale(1.05);
    }

    .form-container {
        padding: 0 40px;
    }

    .form-row {
        display: flex;
        margin-bottom: 20px;
        align-items: center;
    }

    .form-label {
        flex: 0 0 180px;
        font-weight: 600;
        color: var(--primary-color);
        font-size: 1.1rem;
    }

    .form-input {
        flex: 1;
        padding: 12px 15px;
        border: 1px solid var(--border-color);
        border-radius: 8px;
        font-size: 1rem;
        transition: all 0.3s;
        background-color: var(--bg-light);
    }

    .form-input:focus {
        outline: none;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 3px rgba(111, 105, 232, 0.2);
        background-color: white;
    }

    .form-input[readonly] {
        background-color: #f0f0f0;
        color: #666;
    }

    .btn-update {
        background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        border: none;
        border-radius: 30px;
        padding: 12px 30px;
        color: white;
        font-weight: 600;
        font-size: 1.1rem;
        transition: all 0.3s;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        margin-top: 20px;
        cursor: pointer;
    }

    .btn-update:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(111, 105, 232, 0.3);
    }

    .file-input-container {
        position: relative;
        width: 100%;
    }

    .file-input-label {
        display: flex;
        align-items: center;
        gap: 10px;
        cursor: pointer;
        color: var(--primary-color);
        font-weight: 500;
    }

    .file-input {
        position: absolute;
        opacity: 0;
        width: 0.1px;
        height: 0.1px;
    }

    .file-input-icon {
        font-size: 1.2rem;
    }

    @media (max-width: 768px) {
        .profile-pic-container {
            width: 150px;
            height: 150px;
            margin-top: -75px;
        }
        
        .form-row {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .form-label {
            margin-bottom: 8px;
        }
        
        .form-input {
            width: 100%;
        }
        
        .form-container {
            padding: 0 20px;
        }
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
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0,0,0,0.3);
    color: white;
}

@media (max-width: 768px) {
    .back-to-home-btn {
        width: 50px;
        height: 50px;
        font-size: 1.2rem;
        bottom: 20px;
        right: 20px;
    }
}
</style>
</head>
<body>
    <header class="profile-header"></header>

    <%
    UserDataBean msg = (UserDataBean) request.getAttribute("user");
    String userName = msg.getUsername();
    %>

    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-pic-container">
                <img class="profile-pic" alt="Profile picture"
                    src="<%=request.getContextPath()%>/userImage?username=<%=java.net.URLEncoder.encode(userName, "UTF-8")%>">
            </div>

            <div class="form-container">
                <form action="update" method="post" enctype="multipart/form-data">
                    <div class="form-row">
                        <label class="form-label">First Name</label>
                        <input type="text" class="form-input" name="fname" value="<%=msg.getFname()%>">
                    </div>

                    <div class="form-row">
                        <label class="form-label">Last Name</label>
                        <input type="text" class="form-input" name="lname" value="<%=msg.getLname()%>">
                    </div>

                    <div class="form-row">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-input" name="uname" readonly value="<%=msg.getUsername()%>">
                    </div>

                    <div class="form-row">
                        <label class="form-label">Email</label>
                        <input type="text" class="form-input" name="email" value="<%=msg.getEmail()%>">
                    </div>

                    <div class="form-row">
                        <label class="form-label">Phone Number</label>
                        <input type="text" class="form-input" name="phno" value="<%=msg.getPhno()%>">
                    </div>

                    <div class="form-row">
                        <label class="form-label">Profile Image</label>
                        <div class="file-input-container">
                            <label class="file-input-label">
                                <i class="bi bi-camera-fill file-input-icon"></i>
                                <span>Choose new image</span>
                                <input type="file" class="file-input" name="profileImage" accept=".jpg, .jpeg, .png">
                            </label>
                        </div>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn-update">
                            <i class="bi bi-save"></i> Update Profile
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <a href="<%= request.getContextPath() %>/public/html/welcomePage.jsp" class="back-to-home-btn">
        <i class="bi bi-house-door-fill"></i>
    </a>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Show selected file name
        document.querySelector('.file-input').addEventListener('change', function(e) {
            const fileName = e.target.files[0]?.name || 'No file chosen';
            document.querySelector('.file-input-label span').textContent = fileName;
        });
    </script>
</body>
</html>
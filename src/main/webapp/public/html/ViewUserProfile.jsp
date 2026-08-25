<%@page import="javabean.UserDataBean"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Profile</title>
<link rel="icon" type="image/x-icon" href="public/assets/image/profile/fav-img.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
<link rel="stylesheet" href="src/style/ViewUserProfile.css" />
</head>
<body>
    <header class="profile-header"></header>

    <%
    ArrayList<UserDataBean> al = (ArrayList<UserDataBean>) request.getAttribute("profile");
    String msg = (String) request.getAttribute("msg");
    String userName = null;

    for (UserDataBean user : al)
        userName = user.getUsername();
    %>

    <div class="container profile-container">
        <div class="profile-card">
            <div class="profile-pic-container">
                <img class="profile-pic" alt="Profile picture"
                    src="<%=request.getContextPath()%>/userImage?username=<%=java.net.URLEncoder.encode(userName, "UTF-8")%>">
            </div>

            <div class="profile-details">
                <%
                if (msg != null) {
                %>
                <div class="message">
                    <i class="bi bi-check-circle-fill"></i> <%=msg%>
                </div>
                <%
                }
                %>

                <%
                for (UserDataBean view : al) {
                    if (al != null) {
                %>
                <div class="detail-row">
                    <div class="detail-label">First Name</div>
                    <div class="detail-value"><%=view.getFname()%></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Last Name</div>
                    <div class="detail-value"><%=view.getLname()%></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Username</div>
                    <div class="detail-value"><%=view.getUsername()%></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Mobile Number</div>
                    <div class="detail-value"><%=view.getPhno()%></div>
                </div>

                <div class="detail-row">
                    <div class="detail-label">Email</div>
                    <div class="detail-value"><%=view.getEmail()%></div>
                </div>

                <div class="text-center mt-4">
                    <a href="showEditUserPro?username=<%=java.net.URLEncoder.encode(view.getUsername(), "UTF-8")%>">
                        <button class="btn-update">
                            <i class="bi bi-pencil-square"></i> Update Profile
                        </button>
                    </a>
                </div>
                <%
                    } // end of if
                } // end of for each loop
                %>
            </div>
        </div>
    </div>
 <!-- Fixed back button at the bottom right -->
    <a href="<%= request.getContextPath() %>/public/html/welcomePage.jsp" class="back-to-home-btn">
        <i class="bi bi-house-door-fill"></i>
    </a>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


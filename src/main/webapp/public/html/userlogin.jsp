<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert title here</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: #333;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }
        .message {
            color: #006064;
            margin-bottom: 3px;
            text-align: center;
            max-width: 468px;
            width: 100%;
        }
        .content {
            width: 100%;
            max-width: 600px;
            padding: 20px;
        }
        .login-fail{
        color: red;
        }
        .reg-succces{
        	color: green;
        }
    </style>
</head>
<body>
    <div class="content">
        <% String msg = (String) request.getAttribute("msg"); %>
        
        <div class="message">
            <p><%= msg %></p>
        </div>
        <%@ include file="login.html" %>
    </div>
</body>
</html>
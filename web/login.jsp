<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Attendance Management System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-container">
        <div class="login-box">
            <h2>Attendance Management System</h2>
            <h3 style="text-align: center; color: #667eea; margin-bottom: 20px;">Login</h3>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("success") %>
                </div>
            <% } %>
            
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
            
            <p style="text-align: center; margin-top: 20px; color: #666;">
                Don't have an account? <a href="register.jsp" style="color: #667eea;">Register here</a>
            </p>
            
<!--            <div style="margin-top: 30px; padding: 15px; background: #f8f9fa; border-radius: 5px;">
                <p style="margin: 5px 0; font-size: 12px;"><strong>Demo Credentials:</strong></p>
                <p style="margin: 5px 0; font-size: 12px;">Admin - Username: admin, Password: admin123</p>
                <p style="margin: 5px 0; font-size: 12px;">Teacher - Username: teacher1, Password: teacher123</p>
            </div>-->
        </div>
    </div>
</body>
</html>
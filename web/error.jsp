<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Attendance Management System</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="login-container">
        <div class="card" style="max-width: 600px; margin: 0 auto;">
            <div class="card-header">
                <h2 style="color: #dc3545;">❌ Error Occurred</h2>
            </div>
            
            <div class="alert alert-error">
                <h3>Oops! Something went wrong.</h3>
                <% if (exception != null) { %>
                    <p><strong>Error Message:</strong> <%= exception.getMessage() %></p>
                <% } else { %>
                    <p>The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
                <% } %>
            </div>
            
            <div style="margin-top: 20px; text-align: center;">
                <a href="dashboard" class="btn btn-primary">Go to Dashboard</a>
                <a href="login.jsp" class="btn btn-secondary">Go to Login</a>
            </div>
        </div>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String currentPage = request.getRequestURI();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Attendance Management System" %></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <h1>📚 Attendance Management System</h1>
                </div>
                <div class="user-info">
                    <span>Welcome, <strong><%= currentUser.getFullName() %></strong> (<%= currentUser.getRole() %>)</span>
                    <a href="logout" class="btn-logout">Logout</a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="nav-menu">
            <ul>
                <li><a href="dashboard" class="<%= currentPage.contains("dashboard") ? "active" : "" %>">Dashboard</a></li>
                <li><a href="students?action=list" class="<%= currentPage.contains("students") ? "active" : "" %>">Students</a></li>
                <li><a href="courses?action=list" class="<%= currentPage.contains("courses") ? "active" : "" %>">Courses</a></li>
                <li><a href="attendance?action=mark" class="<%= currentPage.contains("mark-attendance") ? "active" : "" %>">Mark Attendance</a></li>
                <li><a href="attendance?action=view" class="<%= currentPage.contains("view-attendance") ? "active" : "" %>">View Attendance</a></li>
                <li><a href="reports" class="<%= currentPage.contains("reports") ? "active" : "" %>">Reports</a></li>
            </ul>
        </div>
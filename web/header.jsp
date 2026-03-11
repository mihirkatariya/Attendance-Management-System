<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get current page URL
    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();
    
    // Helper function to check if link should be active
    boolean isDashboard = currentPage.contains("dashboard");
    boolean isStudents = currentPage.contains("student");
    boolean isCourses = currentPage.contains("course");
    boolean isMarkAttendance = currentPage.contains("mark-attendance");
    boolean isViewAttendance = currentPage.contains("view-attendance");
    boolean isReports = currentPage.contains("report");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "Attendance Management System" %></title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
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
                    <a href="<%= contextPath %>/logout" class="btn-logout">Logout</a>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="nav-menu">
            <ul>
                <li>
                    <a href="<%= contextPath %>/dashboard" class="<%= isDashboard ? "active" : "" %>">
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/students?action=list" class="<%= isStudents ? "active" : "" %>">
                        Students
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/courses?action=list" class="<%= isCourses ? "active" : "" %>">
                        Courses
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/attendance?action=mark" class="<%= isMarkAttendance ? "active" : "" %>">
                        Mark Attendance
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/attendance?action=view" class="<%= isViewAttendance ? "active" : "" %>">
                        View Attendance
                    </a>
                </li>
                <li>
                    <a href="<%= contextPath %>/reports" class="<%= isReports ? "active" : "" %>">
                        Reports
                    </a>
                </li>
            </ul>
        </div>
    
    <div class="container">
        
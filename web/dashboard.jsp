<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Dashboard - Attendance Management System");
%>
<jsp:include page="header.jsp" />

<div class="stats-container">
    <div class="stat-card blue">
        <h3>Total Students</h3>
        <div class="stat-value"><%= request.getAttribute("totalStudents") %></div>
    </div>
    
    <div class="stat-card green">
        <h3>Total Courses</h3>
        <div class="stat-value"><%= request.getAttribute("totalCourses") %></div>
    </div>
    
    <div class="stat-card orange">
        <h3>Total Attendance Records</h3>
        <div class="stat-value"><%= request.getAttribute("totalAttendance") %></div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h2>Quick Actions</h2>
    </div>
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px;">
        <a href="students?action=add" class="btn btn-primary">Add New Student</a>
        <a href="courses?action=add" class="btn btn-success">Add New Course</a>
        <a href="attendance?action=mark" class="btn btn-warning">Mark Attendance</a>
        <a href="reports" class="btn btn-secondary">Generate Reports</a>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h2>System Information</h2>
    </div>
    <table>
        <tr>
            <td><strong>Logged in as:</strong></td>
            <td><%= session.getAttribute("fullName") %></td>
        </tr>
        <tr>
            <td><strong>Role:</strong></td>
            <td><%= session.getAttribute("role") %></td>
        </tr>
        <tr>
            <td><strong>Email:</strong></td>
            <td><%= ((model.User)session.getAttribute("user")).getEmail() %></td>
        </tr>
        <tr>
            <td><strong>Session ID:</strong></td>
            <td><%= session.getId() %></td>
        </tr>
    </table>
</div>

<jsp:include page="footer.jsp" />
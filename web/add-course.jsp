<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%
    request.setAttribute("pageTitle", "Add Course - Attendance Management System");
    List<User> teachers = (List<User>) request.getAttribute("teachers");
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header">
        <h2>Add New Course</h2>
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <form action="courses" method="post">
        <input type="hidden" name="action" value="add">
        
        <div class="form-group">
            <label for="courseCode">Course Code *</label>
            <input type="text" id="courseCode" name="courseCode" class="form-control" required>
        </div>
        
        <div class="form-group">
            <label for="courseName">Course Name *</label>
            <input type="text" id="courseName" name="courseName" class="form-control" required>
        </div>
        
        <div class="form-group">
            <label for="department">Department *</label>
            <select id="department" name="department" class="form-control" required>
                <option value="">Select Department</option>
                <option value="Computer Science">Computer Science</option>
                <option value="Information Technology">Information Technology</option>
                <option value="Electronics">Electronics</option>
                <option value="Mechanical">Mechanical</option>
                <option value="Civil">Civil</option>
                <option value="Electrical">Electrical</option>
            </select>
        </div>
        
        <div class="form-group">
            <label for="semester">Semester *</label>
            <select id="semester" name="semester" class="form-control" required>
                <option value="">Select Semester</option>
                <% for (int i = 1; i <= 8; i++) { %>
                    <option value="<%= i %>"><%= i %></option>
                <% } %>
            </select>
        </div>
        
        <div class="form-group">
            <label for="teacherId">Teacher *</label>
            <select id="teacherId" name="teacherId" class="form-control" required>
                <option value="">Select Teacher</option>
                <% if (teachers != null) {
                    for (User teacher : teachers) { %>
                        <option value="<%= teacher.getUserId() %>"><%= teacher.getFullName() %> (<%= teacher.getRole() %>)</option>
                    <% }
                } %>
            </select>
        </div>
        
        <div style="margin-top: 20px;">
            <button type="submit" class="btn btn-primary">Add Course</button>
            <a href="courses?action=list" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<jsp:include page="footer.jsp" />
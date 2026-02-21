<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setAttribute("pageTitle", "Add Student - Attendance Management System");
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header">
        <h2>Add New Student</h2>
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <form action="students" method="post">
        <input type="hidden" name="action" value="add">
        
        <div class="form-group">
            <label for="rollNumber">Roll Number *</label>
            <input type="text" id="rollNumber" name="rollNumber" class="form-control" required>
        </div>
        
        <div class="form-group">
            <label for="name">Student Name *</label>
            <input type="text" id="name" name="name" class="form-control" required>
        </div>
        
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" class="form-control">
        </div>
        
        <div class="form-group">
            <label for="phone">Phone</label>
            <input type="text" id="phone" name="phone" class="form-control">
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
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
            </select>
        </div>
        
        <div style="margin-top: 20px;">
            <button type="submit" class="btn btn-primary">Add Student</button>
            <a href="students?action=list" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<jsp:include page="footer.jsp" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Student" %>
<%
    request.setAttribute("pageTitle", "Edit Student - Attendance Management System");
    Student student = (Student) request.getAttribute("student");
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header">
        <h2>Edit Student</h2>
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <% if (student != null) { %>
        <form action="students" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="studentId" value="<%= student.getStudentId() %>">
            
            <div class="form-group">
                <label for="rollNumber">Roll Number *</label>
                <input type="text" id="rollNumber" name="rollNumber" class="form-control" 
                       value="<%= student.getRollNumber() %>" required>
            </div>
            
            <div class="form-group">
                <label for="name">Student Name *</label>
                <input type="text" id="name" name="name" class="form-control" 
                       value="<%= student.getName() %>" required>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control" 
                       value="<%= student.getEmail() != null ? student.getEmail() : "" %>">
            </div>
            
            <div class="form-group">
                <label for="phone">Phone</label>
                <input type="text" id="phone" name="phone" class="form-control" 
                       value="<%= student.getPhone() != null ? student.getPhone() : "" %>">
            </div>
            
            <div class="form-group">
                <label for="department">Department *</label>
                <select id="department" name="department" class="form-control" required>
                    <option value="">Select Department</option>
                    <option value="Computer Science" <%= "Computer Science".equals(student.getDepartment()) ? "selected" : "" %>>Computer Science</option>
                    <option value="Information Technology" <%= "Information Technology".equals(student.getDepartment()) ? "selected" : "" %>>Information Technology</option>
                    <option value="Electronics" <%= "Electronics".equals(student.getDepartment()) ? "selected" : "" %>>Electronics</option>
                    <option value="Mechanical" <%= "Mechanical".equals(student.getDepartment()) ? "selected" : "" %>>Mechanical</option>
                    <option value="Civil" <%= "Civil".equals(student.getDepartment()) ? "selected" : "" %>>Civil</option>
                    <option value="Electrical" <%= "Electrical".equals(student.getDepartment()) ? "selected" : "" %>>Electrical</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="semester">Semester *</label>
                <select id="semester" name="semester" class="form-control" required>
                    <option value="">Select Semester</option>
                    <% for (int i = 1; i <= 8; i++) { %>
                        <option value="<%= i %>" <%= student.getSemester() == i ? "selected" : "" %>><%= i %></option>
                    <% } %>
                </select>
            </div>
            
            <div style="margin-top: 20px;">
                <button type="submit" class="btn btn-primary">Update Student</button>
                <a href="students?action=list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    <% } else { %>
        <div class="alert alert-error">Student not found!</div>
        <a href="students?action=list" class="btn btn-secondary">Back to Students</a>
    <% } %>
</div>

<jsp:include page="footer.jsp" />
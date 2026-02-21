<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Course" %>
<%@ page import="model.User" %>
<%
    request.setAttribute("pageTitle", "Edit Course - Attendance Management System");
    Course course = (Course) request.getAttribute("course");
    List<User> teachers = (List<User>) request.getAttribute("teachers");
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header">
        <h2>Edit Course</h2>
    </div>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <% if (course != null) { %>
        <form action="courses" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">
            
            <div class="form-group">
                <label for="courseCode">Course Code *</label>
                <input type="text" id="courseCode" name="courseCode" class="form-control" 
                       value="<%= course.getCourseCode() %>" required>
            </div>
            
            <div class="form-group">
                <label for="courseName">Course Name *</label>
                <input type="text" id="courseName" name="courseName" class="form-control" 
                       value="<%= course.getCourseName() %>" required>
            </div>
            
            <div class="form-group">
                <label for="department">Department *</label>
                <select id="department" name="department" class="form-control" required>
                    <option value="">Select Department</option>
                    <option value="Computer Science" <%= "Computer Science".equals(course.getDepartment()) ? "selected" : "" %>>Computer Science</option>
                    <option value="Information Technology" <%= "Information Technology".equals(course.getDepartment()) ? "selected" : "" %>>Information Technology</option>
                    <option value="Electronics" <%= "Electronics".equals(course.getDepartment()) ? "selected" : "" %>>Electronics</option>
                    <option value="Mechanical" <%= "Mechanical".equals(course.getDepartment()) ? "selected" : "" %>>Mechanical</option>
                    <option value="Civil" <%= "Civil".equals(course.getDepartment()) ? "selected" : "" %>>Civil</option>
                    <option value="Electrical" <%= "Electrical".equals(course.getDepartment()) ? "selected" : "" %>>Electrical</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="semester">Semester *</label>
                <select id="semester" name="semester" class="form-control" required>
                    <option value="">Select Semester</option>
                    <% for (int i = 1; i <= 8; i++) { %>
                        <option value="<%= i %>" <%= course.getSemester() == i ? "selected" : "" %>><%= i %></option>
                    <% } %>
                </select>
            </div>
            
            <div class="form-group">
                <label for="teacherId">Teacher *</label>
                <select id="teacherId" name="teacherId" class="form-control" required>
                    <option value="">Select Teacher</option>
                    <% if (teachers != null) {
                        for (User teacher : teachers) { %>
                            <option value="<%= teacher.getUserId() %>" 
                                    <%= course.getTeacherId() == teacher.getUserId() ? "selected" : "" %>>
                                <%= teacher.getFullName() %> (<%= teacher.getRole() %>)
                            </option>
                        <% }
                    } %>
                </select>
            </div>
            
            <div style="margin-top: 20px;">
                <button type="submit" class="btn btn-primary">Update Course</button>
                <a href="courses?action=list" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    <% } else { %>
        <div class="alert alert-error">Course not found!</div>
        <a href="courses?action=list" class="btn btn-secondary">Back to Courses</a>
    <% } %>
</div>

<jsp:include page="footer.jsp" />
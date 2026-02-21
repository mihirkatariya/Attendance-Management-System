<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Course" %>
<%
    request.setAttribute("pageTitle", "Courses - Attendance Management System");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Course Management</h2>
        <a href="courses?action=add" class="btn btn-primary">Add New Course</a>
    </div>
    
    <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("success") %>
        </div>
    <% } %>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    
    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Course Code</th>
                    <th>Course Name</th>
                    <th>Department</th>
                    <th>Semester</th>
                    <th>Teacher</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (courses != null && !courses.isEmpty()) {
                    for (Course course : courses) { %>
                        <tr>
                            <td><%= course.getCourseId() %></td>
                            <td><%= course.getCourseCode() %></td>
                            <td><%= course.getCourseName() %></td>
                            <td><%= course.getDepartment() %></td>
                            <td><%= course.getSemester() %></td>
                            <td><%= course.getTeacherName() != null ? course.getTeacherName() : "N/A" %></td>
                            <td>
                                <div class="action-buttons">
                                    <a href="courses?action=edit&id=<%= course.getCourseId() %>" class="btn btn-warning btn-sm">Edit</a>
                                    <a href="courses?action=delete&id=<%= course.getCourseId() %>" 
                                       class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Are you sure you want to delete this course?')">Delete</a>
                                </div>
                            </td>
                        </tr>
                    <% }
                } else { %>
                    <tr>
                        <td colspan="7" style="text-align: center;">No courses found</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
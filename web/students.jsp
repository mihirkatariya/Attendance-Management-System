<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Student" %>
<%
    request.setAttribute("pageTitle", "Students - Attendance Management System");
    List<Student> students = (List<Student>) request.getAttribute("students");
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
        <h2>Student Management</h2>
        <a href="students?action=add" class="btn btn-primary">Add New Student</a>
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
                    <th>Roll Number</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Department</th>
                    <th>Semester</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (students != null && !students.isEmpty()) {
                    for (Student student : students) { %>
                        <tr>
                            <td><%= student.getStudentId() %></td>
                            <td><%= student.getRollNumber() %></td>
                            <td><%= student.getName() %></td>
                            <td><%= student.getEmail() %></td>
                            <td><%= student.getPhone() %></td>
                            <td><%= student.getDepartment() %></td>
                            <td><%= student.getSemester() %></td>
                            <td>
                                <div class="action-buttons">
                                    <a href="students?action=edit&id=<%= student.getStudentId() %>" class="btn btn-warning btn-sm">Edit</a>
                                    <a href="students?action=delete&id=<%= student.getStudentId() %>" 
                                       class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Are you sure you want to delete this student?')">Delete</a>
                                </div>
                            </td>
                        </tr>
                    <% }
                } else { %>
                    <tr>
                        <td colspan="8" style="text-align: center;">No students found</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
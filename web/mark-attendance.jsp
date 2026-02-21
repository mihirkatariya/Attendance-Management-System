<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Course" %>
<%@ page import="model.Student" %>
<%@ page import="java.time.LocalDate" %>
<%
    request.setAttribute("pageTitle", "Mark Attendance - Attendance Management System");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Student> students = (List<Student>) request.getAttribute("students");
    String today = LocalDate.now().toString();
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header">
        <h2>Mark Attendance</h2>
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
    
    <form action="attendance" method="post" id="attendanceForm">
        <input type="hidden" name="action" value="mark">
        
        <div class="form-group">
            <label for="courseId">Select Course *</label>
            <select id="courseId" name="courseId" class="form-control" required>
                <option value="">Select Course</option>
                <% if (courses != null) {
                    for (Course course : courses) { %>
                        <option value="<%= course.getCourseId() %>">
                            <%= course.getCourseCode() %> - <%= course.getCourseName() %>
                        </option>
                    <% }
                } %>
            </select>
        </div>
        
        <div class="form-group">
            <label for="date">Date *</label>
            <input type="date" id="date" name="date" class="form-control" 
                   value="<%= today %>" max="<%= today %>" required>
        </div>
        
        <div class="card-header">
            <h3>Students</h3>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Roll Number</th>
                        <th>Student Name</th>
                        <th>Department</th>
                        <th>Status</th>
                        <th>Remarks</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (students != null && !students.isEmpty()) {
                        for (Student student : students) { %>
                            <tr>
                                <td><%= student.getRollNumber() %></td>
                                <td><%= student.getName() %></td>
                                <td><%= student.getDepartment() %></td>
                                <td>
                                    <input type="hidden" name="studentId" value="<%= student.getStudentId() %>">
                                    <select name="status_<%= student.getStudentId() %>" class="form-control" required>
                                        <option value="PRESENT">Present</option>
                                        <option value="ABSENT">Absent</option>
                                        <option value="LATE">Late</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="remarks_<%= student.getStudentId() %>" 
                                           class="form-control" placeholder="Optional remarks">
                                </td>
                            </tr>
                        <% }
                    } else { %>
                        <tr>
                            <td colspan="5" style="text-align: center;">No students found</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <div style="margin-top: 20px;">
            <button type="submit" class="btn btn-primary">Mark Attendance</button>
            <button type="button" class="btn btn-success" onclick="markAllPresent()">Mark All Present</button>
            <button type="button" class="btn btn-danger" onclick="markAllAbsent()">Mark All Absent</button>
        </div>
    </form>
</div>

<script>
function markAllPresent() {
    const selects = document.querySelectorAll('select[name^="status_"]');
    selects.forEach(select => select.value = 'PRESENT');
}

function markAllAbsent() {
    const selects = document.querySelectorAll('select[name^="status_"]');
    selects.forEach(select => select.value = 'ABSENT');
}
</script>

<jsp:include page="footer.jsp" />
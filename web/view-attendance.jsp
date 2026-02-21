<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Course" %>
<%@ page import="model.Attendance" %>
<%@ page import="java.time.LocalDate" %>
<%
    request.setAttribute("pageTitle", "View Attendance - Attendance Management System");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<Attendance> attendanceList = (List<Attendance>) request.getAttribute("attendanceList");
    Course selectedCourse = (Course) request.getAttribute("selectedCourse");
    String selectedDate = (String) request.getAttribute("selectedDate");
    String today = LocalDate.now().toString();
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header">
        <h2>View Attendance</h2>
    </div>
    
    <form action="attendance" method="get">
        <input type="hidden" name="action" value="view">
        
        <div class="form-group">
            <label for="courseId">Select Course *</label>
            <select id="courseId" name="courseId" class="form-control" required>
                <option value="">Select Course</option>
                <% if (courses != null) {
                    for (Course course : courses) { %>
                        <option value="<%= course.getCourseId() %>" 
                                <%= selectedCourse != null && selectedCourse.getCourseId() == course.getCourseId() ? "selected" : "" %>>
                            <%= course.getCourseCode() %> - <%= course.getCourseName() %>
                        </option>
                    <% }
                } %>
            </select>
        </div>
        
        <div class="form-group">
            <label for="date">Date *</label>
            <input type="date" id="date" name="date" class="form-control" 
                   value="<%= selectedDate != null ? selectedDate : today %>" 
                   max="<%= today %>" required>
        </div>
        
        <button type="submit" class="btn btn-primary">View Attendance</button>
    </form>
</div>

<% if (attendanceList != null && !attendanceList.isEmpty()) { %>
    <div class="card">
        <div class="card-header">
            <h3>Attendance Records for <%= selectedCourse.getCourseName() %> on <%= selectedDate %></h3>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Roll Number</th>
                        <th>Student Name</th>
                        <th>Status</th>
                        <th>Remarks</th>
                        <th>Marked At</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Attendance attendance : attendanceList) { %>
                        <tr>
                            <td><%= attendance.getRollNumber() %></td>
                            <td><%= attendance.getStudentName() %></td>
                            <td>
                                <% String status = attendance.getStatus();
                                   String badgeClass = "badge-present";
                                   if ("ABSENT".equals(status)) badgeClass = "badge-absent";
                                   else if ("LATE".equals(status)) badgeClass = "badge-late";
                                %>
                                <span class="badge <%= badgeClass %>"><%= status %></span>
                            </td>
                            <td><%= attendance.getRemarks() != null ? attendance.getRemarks() : "-" %></td>
                            <td><%= attendance.getCreatedAt() %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <% 
            int totalStudents = attendanceList.size();
            long presentCount = attendanceList.stream().filter(a -> "PRESENT".equals(a.getStatus())).count();
            long absentCount = attendanceList.stream().filter(a -> "ABSENT".equals(a.getStatus())).count();
            long lateCount = attendanceList.stream().filter(a -> "LATE".equals(a.getStatus())).count();
        %>
        
        <div style="margin-top: 20px; padding: 15px; background: #f8f9fa; border-radius: 5px;">
            <h4>Summary:</h4>
            <p><strong>Total Students:</strong> <%= totalStudents %></p>
            <p><strong>Present:</strong> <%= presentCount %> (<%= String.format("%.2f", (presentCount * 100.0 / totalStudents)) %>%)</p>
            <p><strong>Absent:</strong> <%= absentCount %> (<%= String.format("%.2f", (absentCount * 100.0 / totalStudents)) %>%)</p>
            <p><strong>Late:</strong> <%= lateCount %> (<%= String.format("%.2f", (lateCount * 100.0 / totalStudents)) %>%)</p>
        </div>
    </div>
<% } else if (selectedCourse != null) { %>
    <div class="card">
        <div class="alert alert-info">
            No attendance records found for the selected course and date.
        </div>
    </div>
<% } %>

<jsp:include page="footer.jsp" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.Course" %>
<%
    request.setAttribute("pageTitle", "Reports - Attendance Management System");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Course selectedCourse = (Course) request.getAttribute("selectedCourse");
    Map<Integer, Map<String, Object>> report = (Map<Integer, Map<String, Object>>) request.getAttribute("report");
%>
<jsp:include page="header.jsp" />

<div class="card">
    <div class="card-header">
        <h2>Attendance Reports</h2>
    </div>
    
    <form action="reports" method="get">
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
        
        <button type="submit" class="btn btn-primary">Generate Report</button>
    </form>
</div>

<% if (report != null && !report.isEmpty()) { %>
    <div class="card">
        <div class="card-header">
            <h3>Attendance Report for <%= selectedCourse.getCourseName() %></h3>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Roll Number</th>
                        <th>Student Name</th>
                        <th>Total Classes</th>
                        <th>Present</th>
                        <th>Absent</th>
                        <th>Late</th>
                        <th>Attendance %</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map.Entry<Integer, Map<String, Object>> entry : report.entrySet()) {
                        Map<String, Object> data = entry.getValue();
                        double percentage = Double.parseDouble((String) data.get("percentage"));
                        String statusClass = percentage >= 75 ? "badge-present" : "badge-absent";
                        String status = percentage >= 75 ? "Good" : "Low";
                    %>
                        <tr>
                            <td><%= data.get("rollNumber") %></td>
                            <td><%= data.get("name") %></td>
                            <td><%= data.get("totalClasses") %></td>
                            <td><%= data.get("presentCount") %></td>
                            <td><%= data.get("absentCount") %></td>
                            <td><%= data.get("lateCount") %></td>
                            <td><strong><%= data.get("percentage") %>%</strong></td>
                            <td><span class="badge <%= statusClass %>"><%= status %></span></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <div style="margin-top: 20px;">
            <button onclick="window.print()" class="btn btn-success">Print Report</button>
            <button onclick="exportToCSV()" class="btn btn-primary">Export to CSV</button>
        </div>
    </div>
<% } else if (selectedCourse != null) { %>
    <div class="card">
        <div class="alert alert-info">
            No attendance data available for this course.
        </div>
    </div>
<% } %>

<script>
function exportToCSV() {
    const table = document.querySelector('table');
    let csv = [];
    const rows = table.querySelectorAll('tr');
    
    for (let i = 0; i < rows.length; i++) {
        const row = [], cols = rows[i].querySelectorAll('td, th');
        
        for (let j = 0; j < cols.length; j++) {
            let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, '').replace(/(\s\s)/gm, ' ');
            data = data.replace(/"/g, '""');
            row.push('"' + data + '"');
        }
        
        csv.push(row.join(','));
    }
    
    const csvString = csv.join('\n');
    const link = document.createElement('a');
    link.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(csvString);
    link.download = 'attendance_report_<%= selectedCourse != null ? selectedCourse.getCourseCode() : "report" %>.csv';
    link.click();
}
</script>

<jsp:include page="footer.jsp" />
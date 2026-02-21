package controller;

import dao.AttendanceDAO;
import dao.CourseDAO;
import model.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private CourseDAO courseDAO;
    
    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        generateReport(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void generateReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);
        
        String courseIdStr = request.getParameter("courseId");
        
        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            int courseId = Integer.parseInt(courseIdStr);
            
            Course selectedCourse = courseDAO.getCourseById(courseId);
            Map<Integer, Map<String, Object>> report = attendanceDAO.getAttendanceReportByCourse(courseId);
            
            request.setAttribute("selectedCourse", selectedCourse);
            request.setAttribute("report", report);
        }
        
        request.getRequestDispatcher("reports.jsp").forward(request, response);
    }
}
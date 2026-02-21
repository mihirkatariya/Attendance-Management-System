package controller;

import dao.StudentDAO;
import dao.CourseDAO;
import dao.AttendanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private StudentDAO studentDAO;
    private CourseDAO courseDAO;
    private AttendanceDAO attendanceDAO;
    
    @Override
    public void init() {
        studentDAO = new StudentDAO();
        courseDAO = new CourseDAO();
        attendanceDAO = new AttendanceDAO();
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
        
        // Get dashboard statistics
        int totalStudents = studentDAO.getAllStudents().size();
        int totalCourses = courseDAO.getAllCourses().size();
        int totalAttendance = attendanceDAO.getAllAttendance().size();
        
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalCourses", totalCourses);
        request.setAttribute("totalAttendance", totalAttendance);
        
        // Forward to dashboard
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
package controller;

import dao.AttendanceDAO;
import dao.CourseDAO;
import dao.StudentDAO;
import model.Attendance;
import model.Course;
import model.Student;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {
    private AttendanceDAO attendanceDAO;
    private CourseDAO courseDAO;
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
        attendanceDAO = new AttendanceDAO();
        courseDAO = new CourseDAO();
        studentDAO = new StudentDAO();
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
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "mark";
        }
        
        switch (action) {
            case "mark":
                showMarkAttendanceForm(request, response);
                break;
            case "view":
                viewAttendance(request, response);
                break;
            default:
                showMarkAttendanceForm(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("mark".equals(action)) {
            markAttendance(request, response);
        }
    }
    
    private void showMarkAttendanceForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Course> courses = courseDAO.getAllCourses();
        List<Student> students = studentDAO.getAllStudents();
        
        request.setAttribute("courses", courses);
        request.setAttribute("students", students);
        request.getRequestDispatcher("mark-attendance.jsp").forward(request, response);
    }
    
    private void markAttendance(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String dateStr = request.getParameter("date");
        Date attendanceDate = Date.valueOf(dateStr);
        
        // Get all student IDs from the form
        String[] studentIds = request.getParameterValues("studentId");
        
        if (studentIds != null) {
            for (String studentIdStr : studentIds) {
                int studentId = Integer.parseInt(studentIdStr);
                String status = request.getParameter("status_" + studentId);
                String remarks = request.getParameter("remarks_" + studentId);
                
                Attendance attendance = new Attendance();
                attendance.setStudentId(studentId);
                attendance.setCourseId(courseId);
                attendance.setAttendanceDate(attendanceDate);
                attendance.setStatus(status);
                attendance.setRemarks(remarks);
                attendance.setMarkedBy(user.getUserId());
                
                attendanceDAO.markAttendance(attendance);
            }
            
            request.setAttribute("success", "Attendance marked successfully!");
        } else {
            request.setAttribute("error", "No students selected!");
        }
        
        response.sendRedirect("attendance?action=mark");
    }
    
    private void viewAttendance(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        String dateStr = request.getParameter("date");
        
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);
        
        if (courseIdStr != null && dateStr != null && !courseIdStr.isEmpty() && !dateStr.isEmpty()) {
            int courseId = Integer.parseInt(courseIdStr);
            Date date = Date.valueOf(dateStr);
            
            List<Attendance> attendanceList = attendanceDAO.getAttendanceByCourseAndDate(courseId, date);
            Course selectedCourse = courseDAO.getCourseById(courseId);
            
            request.setAttribute("attendanceList", attendanceList);
            request.setAttribute("selectedCourse", selectedCourse);
            request.setAttribute("selectedDate", dateStr);
        }
        
        request.getRequestDispatcher("view-attendance.jsp").forward(request, response);
    }
}
package controller;

import java.util.*;
import dao.CourseDAO;
import dao.UserDAO;
import model.Course;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() {
        courseDAO = new CourseDAO();
        userDAO = new UserDAO();
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
            action = "list";
        }
        
        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCourse(request, response);
                break;
            default:
                listCourses(request, response);
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
        
        if ("add".equals(action)) {
            addCourse(request, response);
        } else if ("update".equals(action)) {
            updateCourse(request, response);
        }
    }
    
    private void listCourses(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        List<Course> courses = courseDAO.getAllCourses();
        if (courses == null) {
            courses = new ArrayList<>();
        }
        request.setAttribute("courses", courses);
        request.getRequestDispatcher("course.jsp").forward(request, response);
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
}
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> teachers = userDAO.getAllUsers();
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("add-course.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseById(id);
        List<User> teachers = userDAO.getAllUsers();
        request.setAttribute("course", course);
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("edit-course.jsp").forward(request, response);
    }
    
    private void addCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Course course = new Course();
        course.setCourseCode(request.getParameter("courseCode"));
        course.setCourseName(request.getParameter("courseName"));
        course.setDepartment(request.getParameter("department"));
        course.setSemester(Integer.parseInt(request.getParameter("semester")));
        course.setTeacherId(Integer.parseInt(request.getParameter("teacherId")));
        
        boolean success = courseDAO.addCourse(course);
        
        if (success) {
            request.setAttribute("success", "Course added successfully!");
        } else {
            request.setAttribute("error", "Failed to add course!");
        }
        
        response.sendRedirect("courses?action=list");
    }
    
    private void updateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Course course = new Course();
        course.setCourseId(Integer.parseInt(request.getParameter("courseId")));
        course.setCourseCode(request.getParameter("courseCode"));
        course.setCourseName(request.getParameter("courseName"));
        course.setDepartment(request.getParameter("department"));
        course.setSemester(Integer.parseInt(request.getParameter("semester")));
        course.setTeacherId(Integer.parseInt(request.getParameter("teacherId")));
        
        boolean success = courseDAO.updateCourse(course);
        
        if (success) {
            request.setAttribute("success", "Course updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update course!");
        }
        
        response.sendRedirect("courses?action=list");
    }
    
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = courseDAO.deleteCourse(id);
        
        if (success) {
            request.setAttribute("success", "Course deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete course!");
        }
        
        response.sendRedirect("courses?action=list");
    }
}
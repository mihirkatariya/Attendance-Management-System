package controller;

import dao.StudentDAO;
import model.Student;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {
    private StudentDAO studentDAO;
    
    @Override
    public void init() {
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
                deleteStudent(request, response);
                break;
            default:
                listStudents(request, response);
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
            addStudent(request, response);
        } else if ("update".equals(action)) {
            updateStudent(request, response);
        }
    }
    
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("students", students);
        request.getRequestDispatcher("students.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("add-student.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Student student = studentDAO.getStudentById(id);
        request.setAttribute("student", student);
        request.getRequestDispatcher("edit-student.jsp").forward(request, response);
    }
    
    private void addStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        Student student = new Student();
        student.setRollNumber(request.getParameter("rollNumber"));
        student.setName(request.getParameter("name"));
        student.setEmail(request.getParameter("email"));
        student.setPhone(request.getParameter("phone"));
        student.setDepartment(request.getParameter("department"));
        student.setSemester(Integer.parseInt(request.getParameter("semester")));
        student.setCreatedBy(user.getUserId());
        
        boolean success = studentDAO.addStudent(student);
        
        if (success) {
            request.setAttribute("success", "Student added successfully!");
        } else {
            request.setAttribute("error", "Failed to add student!");
        }
        
        response.sendRedirect("students?action=list");
    }
    
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Student student = new Student();
        student.setStudentId(Integer.parseInt(request.getParameter("studentId")));
        student.setRollNumber(request.getParameter("rollNumber"));
        student.setName(request.getParameter("name"));
        student.setEmail(request.getParameter("email"));
        student.setPhone(request.getParameter("phone"));
        student.setDepartment(request.getParameter("department"));
        student.setSemester(Integer.parseInt(request.getParameter("semester")));
        
        boolean success = studentDAO.updateStudent(student);
        
        if (success) {
            request.setAttribute("success", "Student updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update student!");
        }
        
        response.sendRedirect("students?action=list");
    }
    
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = studentDAO.deleteStudent(id);
        
        if (success) {
            request.setAttribute("success", "Student deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete student!");
        }
        
        response.sendRedirect("students?action=list");
    }
}
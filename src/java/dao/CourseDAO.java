package dao;

import model.Course;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {
    
    // Add new course
    public boolean addCourse(Course course) {
        String query = "INSERT INTO courses (course_code, course_name, department, semester, teacher_id) " +
                      "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, course.getCourseCode());
            pstmt.setString(2, course.getCourseName());
            pstmt.setString(3, course.getDepartment());
            pstmt.setInt(4, course.getSemester());
            pstmt.setInt(5, course.getTeacherId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Update course
    public boolean updateCourse(Course course) {
        String query = "UPDATE courses SET course_code = ?, course_name = ?, department = ?, " +
                      "semester = ?, teacher_id = ? WHERE course_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setString(1, course.getCourseCode());
            pstmt.setString(2, course.getCourseName());
            pstmt.setString(3, course.getDepartment());
            pstmt.setInt(4, course.getSemester());
            pstmt.setInt(5, course.getTeacherId());
            pstmt.setInt(6, course.getCourseId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete course
    public boolean deleteCourse(int courseId) {
        String query = "DELETE FROM courses WHERE course_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, courseId);
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get all courses
    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String query = "SELECT c.*, u.full_name as teacher_name FROM courses c " +
                      "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                      "ORDER BY c.course_code";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
    
    // Get course by ID
    public Course getCourseById(int courseId) {
        Course course = null;
        String query = "SELECT c.*, u.full_name as teacher_name FROM courses c " +
                      "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                      "WHERE c.course_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                course = extractCourseFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return course;
    }
    
    // Get courses by teacher
    public List<Course> getCoursesByTeacher(int teacherId) {
        List<Course> courses = new ArrayList<>();
        String query = "SELECT c.*, u.full_name as teacher_name FROM courses c " +
                      "LEFT JOIN users u ON c.teacher_id = u.user_id " +
                      "WHERE c.teacher_id = ? ORDER BY c.course_code";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, teacherId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                courses.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
    
    // Helper method to extract course from ResultSet
    private Course extractCourseFromResultSet(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setCourseCode(rs.getString("course_code"));
        course.setCourseName(rs.getString("course_name"));
        course.setDepartment(rs.getString("department"));
        course.setSemester(rs.getInt("semester"));
        course.setTeacherId(rs.getInt("teacher_id"));
        course.setTeacherName(rs.getString("teacher_name"));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        return course;
    }
}
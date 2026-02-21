package dao;

import model.Attendance;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class AttendanceDAO {
    
    // Mark attendance
    public boolean markAttendance(Attendance attendance) {
        String query = "INSERT INTO attendance (student_id, course_id, attendance_date, status, remarks, marked_by) " +
                      "VALUES (?, ?, ?, ?, ?, ?) " +
                      "ON DUPLICATE KEY UPDATE status = ?, remarks = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, attendance.getStudentId());
            pstmt.setInt(2, attendance.getCourseId());
            pstmt.setDate(3, attendance.getAttendanceDate());
            pstmt.setString(4, attendance.getStatus());
            pstmt.setString(5, attendance.getRemarks());
            pstmt.setInt(6, attendance.getMarkedBy());
            pstmt.setString(7, attendance.getStatus());
            pstmt.setString(8, attendance.getRemarks());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get attendance by course and date
    public List<Attendance> getAttendanceByCourseAndDate(int courseId, Date date) {
        List<Attendance> attendanceList = new ArrayList<>();
        String query = "SELECT a.*, s.name as student_name, s.roll_number, " +
                      "c.course_name, c.course_code " +
                      "FROM attendance a " +
                      "JOIN students s ON a.student_id = s.student_id " +
                      "JOIN courses c ON a.course_id = c.course_id " +
                      "WHERE a.course_id = ? AND a.attendance_date = ? " +
                      "ORDER BY s.roll_number";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, courseId);
            pstmt.setDate(2, date);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Attendance attendance = extractAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return attendanceList;
    }
    
    // Get attendance by student
    public List<Attendance> getAttendanceByStudent(int studentId) {
        List<Attendance> attendanceList = new ArrayList<>();
        String query = "SELECT a.*, s.name as student_name, s.roll_number, " +
                      "c.course_name, c.course_code " +
                      "FROM attendance a " +
                      "JOIN students s ON a.student_id = s.student_id " +
                      "JOIN courses c ON a.course_id = c.course_id " +
                      "WHERE a.student_id = ? " +
                      "ORDER BY a.attendance_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Attendance attendance = extractAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return attendanceList;
    }
    
    // Get attendance report for course
    public Map<Integer, Map<String, Object>> getAttendanceReportByCourse(int courseId) {
        Map<Integer, Map<String, Object>> report = new HashMap<>();
        String query = "SELECT s.student_id, s.roll_number, s.name, " +
                      "COUNT(CASE WHEN a.status = 'PRESENT' THEN 1 END) as present_count, " +
                      "COUNT(CASE WHEN a.status = 'ABSENT' THEN 1 END) as absent_count, " +
                      "COUNT(CASE WHEN a.status = 'LATE' THEN 1 END) as late_count, " +
                      "COUNT(a.attendance_id) as total_classes " +
                      "FROM students s " +
                      "LEFT JOIN attendance a ON s.student_id = a.student_id AND a.course_id = ? " +
                      "GROUP BY s.student_id, s.roll_number, s.name " +
                      "ORDER BY s.roll_number";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                int studentId = rs.getInt("student_id");
                Map<String, Object> data = new HashMap<>();
                data.put("rollNumber", rs.getString("roll_number"));
                data.put("name", rs.getString("name"));
                data.put("presentCount", rs.getInt("present_count"));
                data.put("absentCount", rs.getInt("absent_count"));
                data.put("lateCount", rs.getInt("late_count"));
                data.put("totalClasses", rs.getInt("total_classes"));
                
                int totalClasses = rs.getInt("total_classes");
                if (totalClasses > 0) {
                    double percentage = (rs.getInt("present_count") * 100.0) / totalClasses;
                    data.put("percentage", String.format("%.2f", percentage));
                } else {
                    data.put("percentage", "0.00");
                }
                
                report.put(studentId, data);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return report;
    }
    
    // Get all attendance records
    public List<Attendance> getAllAttendance() {
        List<Attendance> attendanceList = new ArrayList<>();
        String query = "SELECT a.*, s.name as student_name, s.roll_number, " +
                      "c.course_name, c.course_code " +
                      "FROM attendance a " +
                      "JOIN students s ON a.student_id = s.student_id " +
                      "JOIN courses c ON a.course_id = c.course_id " +
                      "ORDER BY a.attendance_date DESC, s.roll_number";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                Attendance attendance = extractAttendanceFromResultSet(rs);
                attendanceList.add(attendance);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return attendanceList;
    }
    
    // Helper method to extract attendance from ResultSet
    private Attendance extractAttendanceFromResultSet(ResultSet rs) throws SQLException {
        Attendance attendance = new Attendance();
        attendance.setAttendanceId(rs.getInt("attendance_id"));
        attendance.setStudentId(rs.getInt("student_id"));
        attendance.setCourseId(rs.getInt("course_id"));
        attendance.setAttendanceDate(rs.getDate("attendance_date"));
        attendance.setStatus(rs.getString("status"));
        attendance.setRemarks(rs.getString("remarks"));
        attendance.setMarkedBy(rs.getInt("marked_by"));
        attendance.setCreatedAt(rs.getTimestamp("created_at"));
        attendance.setStudentName(rs.getString("student_name"));
        attendance.setRollNumber(rs.getString("roll_number"));
        attendance.setCourseName(rs.getString("course_name"));
        attendance.setCourseCode(rs.getString("course_code"));
        return attendance;
    }
}
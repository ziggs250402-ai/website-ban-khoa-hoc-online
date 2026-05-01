package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Enrollment;

public class EnrollmentDAO {

    public boolean addEnrollment(int userId, int courseId) {
        String sql = "INSERT INTO Enrollment(UserID, CourseID) VALUES (?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isEnrolled(int userId, int courseId) {
        String sql = "SELECT 1 FROM Enrollment WHERE UserID = ? AND CourseID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Enrollment> getEnrollmentsByUserId(int userId) {
        List<Enrollment> list = new ArrayList<>();
        String sql = "SELECT EnrollmentID, UserID, CourseID, EnrollDate FROM Enrollment WHERE UserID = ? ORDER BY EnrollmentID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Enrollment enrollment = new Enrollment();
                    enrollment.setEnrollmentID(rs.getInt("EnrollmentID"));
                    enrollment.setUserID(rs.getInt("UserID"));
                    enrollment.setCourseID(rs.getInt("CourseID"));
                    enrollment.setEnrollDate(rs.getTimestamp("EnrollDate"));
                    list.add(enrollment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}

package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Course;

public class CourseDAO {

    public List<Course> getFeaturedCourses() throws Exception {
        return getAllCourses();
    }

    public List<Course> getAllCourses() throws Exception {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.CourseID, c.Title, c.Description, c.Price, c.ImageURL, c.Level, c.CreatedDate, c.CategoryID, c.InstructorID, "
                + "cat.CategoryName, u.FullName AS InstructorName "
                + "FROM Course c "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Users u ON c.InstructorID = u.UserID "
                + "ORDER BY c.CreatedDate DESC, c.CourseID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapCourse(rs));
        }
        return list;
    }

    public List<Course> getCoursesByUserEnrollments(int userId) throws Exception {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.CourseID, c.Title, c.Description, c.Price, c.ImageURL, c.Level, c.CreatedDate, c.CategoryID, c.InstructorID, "
                + "cat.CategoryName, u.FullName AS InstructorName "
                + "FROM Enrollment e "
                + "INNER JOIN Course c ON e.CourseID = c.CourseID "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Users u ON c.InstructorID = u.UserID "
                + "WHERE e.UserID = ? ORDER BY e.EnrollDate DESC, c.CourseID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapCourse(rs));
            }
        }
        return list;
    }

    public Course getCourseById(int courseId) throws Exception {
        String sql = "SELECT c.CourseID, c.Title, c.Description, c.Price, c.ImageURL, c.Level, c.CreatedDate, c.CategoryID, c.InstructorID, "
                + "cat.CategoryName, u.FullName AS InstructorName "
                + "FROM Course c "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Users u ON c.InstructorID = u.UserID "
                + "WHERE c.CourseID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapCourse(rs);
            }
        }
        return null;
    }

    public int createCourse(Course course, Integer categoryId, Integer instructorId) throws Exception {
        String sql = "INSERT INTO Course(Title, Description, Price, ImageURL, CategoryID, InstructorID, Level) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setBigDecimal(3, course.getPrice());
            ps.setString(4, course.getImageURL());
            if (categoryId == null) ps.setNull(5, java.sql.Types.INTEGER); else ps.setInt(5, categoryId);
            if (instructorId == null) ps.setNull(6, java.sql.Types.INTEGER); else ps.setInt(6, instructorId);
            ps.setString(7, course.getLevel());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updateCourse(Course course, Integer categoryId, Integer instructorId) throws Exception {
        String sql = "UPDATE Course SET Title=?, Description=?, Price=?, ImageURL=?, CategoryID=?, InstructorID=?, Level=? WHERE CourseID=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setBigDecimal(3, course.getPrice());
            ps.setString(4, course.getImageURL());
            if (categoryId == null) ps.setNull(5, java.sql.Types.INTEGER); else ps.setInt(5, categoryId);
            if (instructorId == null) ps.setNull(6, java.sql.Types.INTEGER); else ps.setInt(6, instructorId);
            ps.setString(7, course.getLevel());
            ps.setInt(8, course.getCourseID());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteCourse(int courseId) throws Exception {
        String sqlDeleteCourse = "DELETE FROM Course WHERE CourseID = ?";
        String sqlDeleteLessons = "DELETE FROM Lesson WHERE CourseID = ?";
        String sqlDeleteCart = "DELETE FROM Cart WHERE CourseID = ?";
        String sqlDeleteEnrollment = "DELETE FROM Enrollment WHERE CourseID = ?";
        String sqlDeleteOrderDetail = "DELETE FROM OrderDetail WHERE CourseID = ?";

        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement ps = conn.prepareStatement(sqlDeleteOrderDetail)) {
                    ps.setInt(1, courseId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(sqlDeleteEnrollment)) {
                    ps.setInt(1, courseId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(sqlDeleteLessons)) {
                    ps.setInt(1, courseId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = conn.prepareStatement(sqlDeleteCart)) {
                    ps.setInt(1, courseId);
                    ps.executeUpdate();
                }
                int affected;
                try (PreparedStatement ps = conn.prepareStatement(sqlDeleteCourse)) {
                    ps.setInt(1, courseId);
                    affected = ps.executeUpdate();
                }
                conn.commit();
                return affected > 0;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    private Course mapCourse(ResultSet rs) throws Exception {
        Course course = new Course();
        course.setCourseID(rs.getInt("CourseID"));
        course.setTitle(rs.getString("Title"));
        course.setDescription(rs.getString("Description"));
        course.setPrice(rs.getBigDecimal("Price"));
        course.setImageURL(rs.getString("ImageURL"));
        course.setLevel(rs.getString("Level"));
        course.setCreatedDate(rs.getTimestamp("CreatedDate"));
        course.setCategoryID(rs.getObject("CategoryID") == null ? 0 : rs.getInt("CategoryID"));
        course.setInstructorID(rs.getObject("InstructorID") == null ? 0 : rs.getInt("InstructorID"));
        course.setCategoryName(rs.getString("CategoryName"));
        course.setInstructorName(rs.getString("InstructorName"));
        return course;
    }
}

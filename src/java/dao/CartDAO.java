package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.Course;

public class CartDAO {

    public List<Cart> getCartByUserId(int userId) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT CartID, UserID, CourseID, AddedDate FROM Cart WHERE UserID = ? ORDER BY CartID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cart cart = new Cart();
                    cart.setCartID(rs.getInt("CartID"));
                    cart.setUserID(rs.getInt("UserID"));
                    cart.setCourseID(rs.getInt("CourseID"));
                    cart.setAddedDate(rs.getTimestamp("AddedDate"));
                    list.add(cart);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> getCartCoursesByUserId(int userId) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT c.CourseID, c.Title, c.Description, c.Price, c.ImageURL, c.Level, "
                + "cat.CategoryName, u.FullName AS InstructorName, ct.AddedDate "
                + "FROM Cart ct "
                + "INNER JOIN Course c ON ct.CourseID = c.CourseID "
                + "LEFT JOIN Category cat ON c.CategoryID = cat.CategoryID "
                + "LEFT JOIN Users u ON c.InstructorID = u.UserID "
                + "WHERE ct.UserID = ? ORDER BY ct.CartID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getInt("CourseID"));
                    course.setTitle(rs.getString("Title"));
                    course.setDescription(rs.getString("Description"));
                    course.setPrice(rs.getBigDecimal("Price"));
                    course.setImageURL(rs.getString("ImageURL"));
                    course.setLevel(rs.getString("Level"));
                    course.setCategoryName(rs.getString("CategoryName"));
                    course.setInstructorName(rs.getString("InstructorName"));
                    list.add(course);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addCourseToCart(int userId, int courseId) {
        String sql = "INSERT INTO Cart(UserID, CourseID) VALUES (?, ?)";
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

    public boolean removeCourseFromCart(int userId, int courseId) {
        String sql = "DELETE FROM Cart WHERE UserID = ? AND CourseID = ?";
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

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM Cart WHERE UserID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

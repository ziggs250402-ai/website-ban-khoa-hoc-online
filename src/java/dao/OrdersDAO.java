package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Orders;

public class OrdersDAO {

    public int createOrder(int userId, java.math.BigDecimal totalAmount, String status) {
        String sql = "INSERT INTO Orders(UserID, TotalAmount, Status) VALUES (?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setBigDecimal(2, totalAmount);
            ps.setString(3, status);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public int getUserIdByOrderId(int orderId) {
        String sql = "SELECT UserID FROM Orders WHERE OrderID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("UserID");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public List<Orders> getOrdersByUserId(int userId) {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT OrderID, UserID, OrderDate, TotalAmount, Status FROM Orders WHERE UserID = ? ORDER BY OrderID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Orders order = new Orders();
                    order.setOrderID(rs.getInt("OrderID"));
                    order.setUserID(rs.getInt("UserID"));
                    order.setOrderDate(rs.getTimestamp("OrderDate"));
                    order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                    order.setStatus(rs.getString("Status"));
                    list.add(order);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Orders> getAllOrders() {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT o.OrderID, o.UserID, o.OrderDate, o.TotalAmount, o.Status, u.Username AS Username "
                + "FROM Orders o INNER JOIN Users u ON o.UserID = u.UserID ORDER BY o.OrderID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                order.setStatus(rs.getString("Status"));
                // Username is optional if model has no field; ignored here
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Orders> getPendingOrders() {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT OrderID, UserID, OrderDate, TotalAmount, Status FROM Orders WHERE Status = 'Pending' ORDER BY OrderID DESC";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                order.setStatus(rs.getString("Status"));
                list.add(order);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}

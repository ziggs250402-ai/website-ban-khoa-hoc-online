package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Payment;

public class PaymentDAO {

    public int createPayment(int orderId, java.math.BigDecimal amount, String status, String proofImagePath) {
        String sql = "INSERT INTO Payment(OrderID, Amount, Status, ProofImagePath) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, orderId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, status);
            ps.setString(4, proofImagePath);
            int affected = ps.executeUpdate();
            if (affected > 0) try (ResultSet rs = ps.getGeneratedKeys()) { if (rs.next()) return rs.getInt(1); }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public Payment getPaymentById(int paymentId) {
        String sql = "SELECT p.PaymentID, p.OrderID, p.Amount, p.Status, p.ProofImagePath, p.PaymentDate, u.Username "
                + "FROM Payment p INNER JOIN Orders o ON p.OrderID = o.OrderID INNER JOIN Users u ON o.UserID = u.UserID WHERE p.PaymentID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentID(rs.getInt("PaymentID"));
                    p.setOrderID(rs.getInt("OrderID"));
                    p.setAmount(rs.getBigDecimal("Amount"));
                    p.setStatus(rs.getString("Status"));
                    p.setProofImagePath(rs.getString("ProofImagePath"));
                    p.setPaymentDate(rs.getTimestamp("PaymentDate"));
                    p.setUsername(rs.getString("Username"));
                    return p;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.PaymentID, p.OrderID, p.Amount, p.Status, p.ProofImagePath, p.PaymentDate, u.Username "
                + "FROM Payment p INNER JOIN Orders o ON p.OrderID = o.OrderID INNER JOIN Users u ON o.UserID = u.UserID ORDER BY p.PaymentID DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(rs.getInt("PaymentID"));
                payment.setOrderID(rs.getInt("OrderID"));
                payment.setAmount(rs.getBigDecimal("Amount"));
                payment.setStatus(rs.getString("Status"));
                payment.setProofImagePath(rs.getString("ProofImagePath"));
                payment.setPaymentDate(rs.getTimestamp("PaymentDate"));
                payment.setUsername(rs.getString("Username"));
                list.add(payment);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Payment> getPendingPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.PaymentID, p.OrderID, p.Amount, p.Status, p.ProofImagePath, p.PaymentDate, u.Username "
                + "FROM Payment p INNER JOIN Orders o ON p.OrderID = o.OrderID INNER JOIN Users u ON o.UserID = u.UserID "
                + "WHERE p.Status = 'Pending' ORDER BY p.PaymentID DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setPaymentID(rs.getInt("PaymentID"));
                payment.setOrderID(rs.getInt("OrderID"));
                payment.setAmount(rs.getBigDecimal("Amount"));
                payment.setStatus(rs.getString("Status"));
                payment.setProofImagePath(rs.getString("ProofImagePath"));
                payment.setPaymentDate(rs.getTimestamp("PaymentDate"));
                payment.setUsername(rs.getString("Username"));
                list.add(payment);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updatePaymentStatus(int paymentId, String status) {
        String sql = "UPDATE Payment SET Status = ? WHERE PaymentID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, paymentId); return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}

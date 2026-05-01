package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

public class DashboardDAO {

    public int countCourses() {
        return count("SELECT COUNT(*) AS total FROM Course");
    }

    public int countUsers() {
        return count("SELECT COUNT(*) AS total FROM Users WHERE Role = 'user'");
    }

    public int countAdmins() {
        return count("SELECT COUNT(*) AS total FROM Users WHERE Role = 'admin'");
    }

    public int countOrders() {
        return count("SELECT COUNT(*) AS total FROM Orders");
    }

    public int countPayments() {
        return count("SELECT COUNT(*) AS total FROM Payment");
    }

    public int countEnrollmentsFromDate(LocalDate fromDate) {
        String sql = "SELECT COUNT(*) AS total FROM Enrollment WHERE EnrollDate >= ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(fromDate));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Integer> countEnrollmentsByMonth(LocalDate fromDate) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT FORMAT(EnrollDate, 'M/yyyy') AS MonthLabel, COUNT(*) AS total "
                + "FROM Enrollment WHERE EnrollDate >= ? GROUP BY FORMAT(EnrollDate, 'M/yyyy') ORDER BY MIN(EnrollDate)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(fromDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) map.put(rs.getString("MonthLabel"), rs.getInt("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return map;
    }

    private int count(String sql) {
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}

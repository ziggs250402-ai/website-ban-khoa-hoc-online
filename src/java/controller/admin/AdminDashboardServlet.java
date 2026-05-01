package controller.admin;

import dao.DashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import model.User;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        DashboardDAO dao = new DashboardDAO();
        LocalDate fromDate = LocalDate.of(2026, 4, 1);
        request.setAttribute("activePage", "dashboard");
        request.setAttribute("totalCourses", dao.countCourses());
        request.setAttribute("totalUsers", dao.countUsers());
        request.setAttribute("totalAdmins", dao.countAdmins());
        request.setAttribute("totalOrders", dao.countOrders());
        request.setAttribute("totalPayments", dao.countPayments());
        request.setAttribute("enrollmentsFromDate", dao.countEnrollmentsFromDate(fromDate));
        request.setAttribute("enrollmentByMonth", dao.countEnrollmentsByMonth(fromDate));
        request.setAttribute("fromDateLabel", fromDate.toString());
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}

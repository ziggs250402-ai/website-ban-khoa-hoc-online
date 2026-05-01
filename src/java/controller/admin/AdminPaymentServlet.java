package controller.admin;

import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "AdminPaymentServlet", urlPatterns = {"/admin/payments"})
public class AdminPaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        PaymentDAO paymentDAO = new PaymentDAO();
        request.setAttribute("pendingPayments", paymentDAO.getPendingPayments());
        request.setAttribute("allPayments", paymentDAO.getAllPayments());
        request.getRequestDispatcher("/admin/payments.jsp").forward(request, response);
    }
}

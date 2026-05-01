package controller.admin;

import dao.CartDAO;
import dao.EnrollmentDAO;
import dao.OrderDetailDAO;
import dao.OrdersDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.OrderDetail;
import model.Payment;
import model.User;

@WebServlet(name = "AdminPaymentApproveServlet", urlPatterns = {"/admin/payment-approve", "/admin/payment-reject"})
public class AdminPaymentApproveServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int paymentId = Integer.parseInt(request.getParameter("paymentId"));
            String action = request.getServletPath().contains("reject") ? "Rejected" : "Approved";
            PaymentDAO paymentDAO = new PaymentDAO();
            Payment payment = paymentDAO.getPaymentById(paymentId);
            if (payment == null) {
                response.sendRedirect(request.getContextPath() + "/admin/payments?notfound=1");
                return;
            }

            OrdersDAO ordersDAO = new OrdersDAO();
            OrderDetailDAO detailDAO = new OrderDetailDAO();
            EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
            CartDAO cartDAO = new CartDAO();

            paymentDAO.updatePaymentStatus(paymentId, action);
            ordersDAO.updateOrderStatus(payment.getOrderID(), "Approved".equals(action) ? "Completed" : "Cancelled");

            int userId = ordersDAO.getUserIdByOrderId(payment.getOrderID());
            if ("Approved".equals(action) && userId > 0) {
                List<OrderDetail> details = detailDAO.getOrderDetailsByOrderId(payment.getOrderID());
                for (OrderDetail detail : details) {
                    if (!enrollmentDAO.isEnrolled(userId, detail.getCourseID())) {
                        enrollmentDAO.addEnrollment(userId, detail.getCourseID());
                    }
                }
                cartDAO.clearCart(userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/payments");
    }
}

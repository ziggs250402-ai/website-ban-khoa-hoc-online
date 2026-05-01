package controller;

import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import model.Course;
import model.User;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?next=payment");
            return;
        }
        if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        List<Course> cartCourses = cartDAO.getCartCoursesByUserId(user.getUserID());
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Course course : cartCourses) {
            if (course.getPrice() != null) {
                totalAmount = totalAmount.add(course.getPrice());
            }
        }
        request.setAttribute("cartCourses", cartCourses);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("/payment.jsp").forward(request, response);
    }
}

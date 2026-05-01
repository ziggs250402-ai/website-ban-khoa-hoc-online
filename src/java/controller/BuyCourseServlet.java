package controller;

import dao.CartDAO;
import dao.EnrollmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "BuyCourseServlet", urlPatterns = {"/buy-course"})
public class BuyCourseServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        String courseIdParam = request.getParameter("courseId");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?next=buy-course&courseId=" + (courseIdParam == null ? "" : courseIdParam));
            return;
        }
        if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }

        if (courseIdParam != null && !courseIdParam.isBlank()) {
            try {
                int courseId = Integer.parseInt(courseIdParam);
                EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
                if (enrollmentDAO.isEnrolled(user.getUserID(), courseId)) {
                    request.getSession().setAttribute("cartWarning", "Bạn đã có khoá học này. Bạn có muốn mua tiếp không?");
                    response.sendRedirect(request.getContextPath() + "/cart?alreadyOwned=1");
                    return;
                }
                CartDAO cartDAO = new CartDAO();
                if (cartDAO.addCourseToCart(user.getUserID(), courseId)) {
                    response.sendRedirect(request.getContextPath() + "/cart?added=1");
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}

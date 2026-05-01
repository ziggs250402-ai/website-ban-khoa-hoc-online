package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String usernameOrEmail = request.getParameter("usernameOrEmail");
        String password = request.getParameter("password");

        if (usernameOrEmail == null || usernameOrEmail.isBlank() || password == null || password.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin đăng nhập.");
            request.setAttribute("usernameOrEmail", usernameOrEmail);
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.login(usernameOrEmail, password);

            if (user != null) {
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }
                HttpSession session = request.getSession(true);
                session.setMaxInactiveInterval(300);
                session.setAttribute("user", user);

                String next = request.getParameter("next");
                String courseId = request.getParameter("courseId");
                if ("admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else if ("cart".equalsIgnoreCase(next)) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                } else if ("my-courses".equalsIgnoreCase(next)) {
                    response.sendRedirect(request.getContextPath() + "/my-courses");
                } else if ("course-player".equalsIgnoreCase(next) && courseId != null && !courseId.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/course-player?courseId=" + courseId);
                } else if ("payment".equalsIgnoreCase(next)) {
                    response.sendRedirect(request.getContextPath() + "/payment");
                } else if ("profile".equalsIgnoreCase(next)) {
                    response.sendRedirect(request.getContextPath() + "/profile");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu.");
                request.setAttribute("usernameOrEmail", usernameOrEmail);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi đăng nhập: " + e.getMessage());
            request.setAttribute("usernameOrEmail", usernameOrEmail);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}

package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/profile-update"})
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String newPassword = request.getParameter("password");

        User user = new User();
        user.setUserID(currentUser.getUserID());
        user.setUsername(request.getParameter("username"));
        user.setPassword((newPassword == null || newPassword.isBlank()) ? currentUser.getPassword() : newPassword);
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setRole(currentUser.getRole());
        user.setCreatedDate(currentUser.getCreatedDate());

        boolean ok = new UserDAO().updateUser(user);
        if (!ok) {
            request.setAttribute("profileError", "Không thể cập nhật hồ sơ. Vui lòng thử lại.");
            request.setAttribute("profileUser", currentUser);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
            return;
        }

        session.setAttribute("user", user);
        response.sendRedirect(request.getContextPath() + "/profile?updated=1");
    }
}

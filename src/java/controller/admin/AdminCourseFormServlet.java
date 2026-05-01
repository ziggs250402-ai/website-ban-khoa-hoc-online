
package controller.admin;

import dao.CategoryDAO;
import dao.CourseDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Course;
import model.User;

@WebServlet(name = "AdminCourseFormServlet", urlPatterns = {"/admin/course-form"})
public class AdminCourseFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        try {
            request.setAttribute("categories", new CategoryDAO().getAllCategories());
            request.setAttribute("users", new UserDAO().getAllUsers());
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isBlank()) {
                Course course = new CourseDAO().getCourseById(Integer.parseInt(idParam));
                request.setAttribute("editCourse", course);
            }
        } catch (Exception e) {
            request.setAttribute("courseError", e.getMessage());
        }
        request.getRequestDispatcher("/admin/course-form.jsp").forward(request, response);
    }
}

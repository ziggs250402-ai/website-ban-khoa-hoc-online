package controller.admin;

import dao.CourseDAO;
import dao.LessonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Course;
import model.Lesson;
import model.User;

@WebServlet(name = "AdminCourseLessonsServlet", urlPatterns = {"/admin/course-lessons"})
public class AdminCourseLessonsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int courseId = parseInt(request.getParameter("courseId"));
        int editLessonId = parseInt(request.getParameter("editLessonId"));
        try {
            Course course = new CourseDAO().getCourseById(courseId);
            request.setAttribute("course", course);
            request.setAttribute("lessons", new LessonDAO().getLessonsByCourseId(courseId));
            if (editLessonId > 0) {
                request.setAttribute("editLesson", new LessonDAO().getLessonById(editLessonId));
            }
        } catch (Exception e) {
            request.setAttribute("lessonError", e.getMessage());
        }
        request.getRequestDispatcher("/admin/course-lessons.jsp").forward(request, response);
    }

    private int parseInt(String value) {
        try { return value == null || value.isBlank() ? 0 : Integer.parseInt(value); } catch (Exception e) { return 0; }
    }
}

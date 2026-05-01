package controller.admin;

import dao.LessonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Lesson;
import model.User;

@WebServlet(name = "AdminLessonServlet", urlPatterns = {"/admin/lesson-save", "/admin/lesson-delete"})
public class AdminLessonServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        int courseId = parseInt(request.getParameter("courseId"));
        if ("/admin/lesson-delete".equals(path)) {
            int lessonId = parseInt(request.getParameter("lessonId"));
            new LessonDAO().deleteLesson(lessonId);
            response.sendRedirect(request.getContextPath() + "/admin/course-lessons?courseId=" + courseId);
            return;
        }

        Lesson lesson = new Lesson();
        lesson.setLessonID(parseInt(request.getParameter("lessonId")));
        lesson.setCourseID(courseId);
        lesson.setTitle(request.getParameter("title"));
        lesson.setVideoURL(request.getParameter("videoURL"));
        lesson.setLessonOrder(parseInt(request.getParameter("duration")));

        LessonDAO dao = new LessonDAO();
        if (lesson.getLessonID() > 0) dao.updateLesson(lesson); else dao.createLesson(lesson);
        response.sendRedirect(request.getContextPath() + "/admin/course-lessons?courseId=" + courseId);
    }

    private int parseInt(String value) {
        try { return value == null || value.isBlank() ? 0 : Integer.parseInt(value); } catch (Exception e) { return 0; }
    }
}

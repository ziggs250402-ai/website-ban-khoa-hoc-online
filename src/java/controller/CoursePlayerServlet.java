package controller;

import dao.CourseDAO;
import dao.LessonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Course;
import model.Lesson;
import model.User;

@WebServlet(name = "CoursePlayerServlet", urlPatterns = {"/course-player"})
public class CoursePlayerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            String courseIdParam = request.getParameter("courseId");
            response.sendRedirect(request.getContextPath() + "/login.jsp?next=course-player&courseId=" + (courseIdParam == null ? "" : courseIdParam));
            return;
        }
        if ("admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }

        String courseIdParam = request.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/my-courses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdParam);
            CourseDAO courseDAO = new CourseDAO();
            Course course = courseDAO.getCourseById(courseId);
            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/my-courses?error=course-not-found");
                return;
            }

            if (!new dao.EnrollmentDAO().isEnrolled(user.getUserID(), courseId)) {
                response.sendRedirect(request.getContextPath() + "/my-courses?error=not-enrolled");
                return;
            }

            List<Lesson> lessons = new LessonDAO().getLessonsByCourseId(courseId);
            int selectedIndex = 0;
            String lessonIdParam = request.getParameter("lessonId");
            if (lessonIdParam != null && !lessonIdParam.isBlank()) {
                try {
                    int lessonId = Integer.parseInt(lessonIdParam);
                    for (int i = 0; i < lessons.size(); i++) {
                        if (lessons.get(i).getLessonID() == lessonId) {
                            selectedIndex = i;
                            break;
                        }
                    }
                } catch (NumberFormatException ignored) {
                    selectedIndex = 0;
                }
            }
            if (selectedIndex < 0 || selectedIndex >= lessons.size()) {
                selectedIndex = 0;
            }

            request.setAttribute("course", course);
            request.setAttribute("lessons", lessons);
            request.setAttribute("selectedLesson", lessons.isEmpty() ? null : lessons.get(selectedIndex));
            request.setAttribute("selectedIndex", selectedIndex);
            request.setAttribute("lessonCount", lessons.size());
            request.getRequestDispatcher("/course-player.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-courses");
        } catch (Exception e) {
            request.setAttribute("playerError", "Không thể mở khoá học. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/course-player.jsp").forward(request, response);
        }
    }
}

package controller;

import dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;
import model.Course;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            CourseDAO dao = new CourseDAO();
            List<Course> allCourses = dao.getFeaturedCourses();
            String q = request.getParameter("q");
            int page = parseInt(request.getParameter("page"), 1);
            int pageSize = 4;

            if (q != null && !q.isBlank()) {
                String query = q.trim().toLowerCase(Locale.ROOT);
                List<Course> filteredCourses = allCourses.stream()
                        .filter(c -> containsIgnoreCase(c.getTitle(), query)
                                || containsIgnoreCase(c.getDescription(), query)
                                || containsIgnoreCase(c.getInstructorName(), query)
                                || containsIgnoreCase(c.getLevel(), query)
                                || containsIgnoreCase(c.getCategoryName(), query)
                                || String.valueOf(c.getPrice()).contains(query))
                        .collect(Collectors.toList());

                int totalPages = Math.max(1, (int) Math.ceil(filteredCourses.size() / (double) pageSize));
                if (page < 1) page = 1;
                if (page > totalPages) page = totalPages;
                int fromIndex = Math.min((page - 1) * pageSize, filteredCourses.size());
                int toIndex = Math.min(fromIndex + pageSize, filteredCourses.size());

                request.setAttribute("searchQuery", q);
                request.setAttribute("searchCount", filteredCourses.size());
                request.setAttribute("featuredCourses", filteredCourses.subList(fromIndex, toIndex));
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
            } else {
                int totalPages = Math.max(1, (int) Math.ceil(allCourses.size() / (double) pageSize));
                if (page < 1) page = 1;
                if (page > totalPages) page = totalPages;
                int fromIndex = Math.min((page - 1) * pageSize, allCourses.size());
                int toIndex = Math.min(fromIndex + pageSize, allCourses.size());
                request.setAttribute("featuredCourses", allCourses.subList(fromIndex, toIndex));
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
            }
        } catch (Exception e) {
            request.setAttribute("homeError", e.getMessage());
        }
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return value == null || value.isBlank() ? defaultValue : Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private boolean containsIgnoreCase(String source, String query) {
        return source != null && source.toLowerCase(Locale.ROOT).contains(query);
    }
}

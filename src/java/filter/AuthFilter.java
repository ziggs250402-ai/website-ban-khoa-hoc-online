package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Set;
import model.User;

@WebFilter(urlPatterns = {
    "/cart",
    "/my-courses",
    "/course-player",
    "/buy-course",
    "/payment",
    "/profile",
    "/update-profile"
})
public class AuthFilter implements Filter {

    private static final Set<String> PUBLIC_NEXT_VALUES = Set.of(
            "home", "login", "register", "cart", "my-courses", "course-player", "buy-course", "payment", "profile"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        String uri = req.getRequestURI();
        if (uri.endsWith("/login.jsp") || uri.endsWith("/register.jsp") || uri.endsWith("/index.jsp")
                || uri.endsWith("/home") || uri.endsWith("/login") || uri.endsWith("/register") || uri.endsWith("/logout")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            String next = req.getServletPath().replaceFirst("^/", "");
            if (!PUBLIC_NEXT_VALUES.contains(next)) {
                next = "home";
            }
            String courseId = req.getParameter("courseId");
            StringBuilder redirect = new StringBuilder(req.getContextPath())
                    .append("/login.jsp?next=")
                    .append(next);
            if (courseId != null && !courseId.isBlank()) {
                redirect.append("&courseId=").append(courseId);
            }
            res.sendRedirect(redirect.toString());
            return;
        }

        if ("admin".equalsIgnoreCase(user.getRole())) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}

package controller.admin;

import dao.CategoryDAO;
import dao.CourseDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import model.Course;
import model.User;

@WebServlet(name = "AdminCourseServlet", urlPatterns = {"/admin/courses"})
@MultipartConfig
public class AdminCourseServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp"); // không phải admin thì về login
            return;
        }
        try {
            request.setAttribute("courses", new CourseDAO().getAllCourses()); // đẩy danh sách khóa học sang JSP
            request.setAttribute("users", new UserDAO().getAllUsers()); // đẩy user sang JSP
            request.setAttribute("categories", new CategoryDAO().getAllCategories()); // đẩy category sang JSP
        } catch (Exception e) {
            request.setAttribute("courseError", e.getMessage()); // báo lỗi ra JSP
        }
        request.getRequestDispatcher("/admin/course-list.jsp").forward(request, response); // chuyển sang trang danh sách
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp"); // không phải admin thì về login
            return;
        }
        String action = request.getParameter("action");
        String error = null;
        int courseId = parseInt(request.getParameter("courseID"));
        try {
            CourseDAO dao = new CourseDAO();

            if ("delete".equalsIgnoreCase(action)) {
                boolean deleted = dao.deleteCourse(courseId); // xoá khóa học
                if (!deleted) throw new Exception("Không thể xoá khoá học.");
                session.setAttribute("courseSuccess", "Đã xoá khoá học thành công.");
            } else {
                Course course = new Course();
                course.setCourseID(courseId); // lấy ID để update
                course.setTitle(request.getParameter("title")); // lấy title từ form
                course.setDescription(request.getParameter("description")); // lấy mô tả từ form
                course.setPrice(new BigDecimal(request.getParameter("price"))); // lấy giá từ form
                course.setLevel(request.getParameter("level")); // lấy level từ form
                Integer categoryId = parseNullableInt(request.getParameter("categoryID")); // lấy category
                Integer instructorId = parseNullableInt(request.getParameter("instructorID")); // lấy instructor

                Part imageFile = request.getPart("imageFile"); // lấy file ảnh upload
                String imageUrl = request.getParameter("imageURL"); // lấy ảnh cũ nếu có
                if (imageFile != null && imageFile.getSize() > 0) {
                    String fileName = Paths.get(imageFile.getSubmittedFileName()).getFileName().toString(); // lấy tên file
                    String uploadDir = getServletContext().getRealPath("/images"); // thư mục images
                    if (uploadDir == null) {
                        uploadDir = System.getProperty("java.io.tmpdir") + File.separator + "gymcode-images"; // fallback tạm
                    }
                    Files.createDirectories(Paths.get(uploadDir)); // tạo thư mục nếu chưa có
                    String storedName = System.currentTimeMillis() + "_" + fileName; // đổi tên file để tránh trùng
                    Path filePath = Paths.get(uploadDir, storedName); // tạo đường dẫn lưu file
                    imageFile.write(filePath.toString()); // ghi file xuống server
                    imageUrl = "/images/" + storedName; // lưu path vào DB
                }
                if (imageUrl == null || imageUrl.isBlank()) {
                    if ("update".equalsIgnoreCase(action) || course.getCourseID() > 0) {
                        Course old = dao.getCourseById(course.getCourseID()); // lấy ảnh cũ khi sửa
                        if (old != null) imageUrl = old.getImageURL(); // giữ ảnh cũ
                    }
                }
                course.setImageURL(imageUrl); // gán ảnh vào course

                if ("update".equalsIgnoreCase(action) || course.getCourseID() > 0) {
                    boolean updated = dao.updateCourse(course, categoryId, instructorId); // update DB
                    if (!updated) throw new Exception("Không thể cập nhật khoá học.");
                    session.setAttribute("courseSuccess", "Đã cập nhật khoá học thành công.");
                } else {
                    int newId = dao.createCourse(course, categoryId, instructorId); // insert DB
                    if (newId <= 0) throw new Exception("Không thể tạo khoá học mới.");
                    session.setAttribute("courseSuccess", "Đã tạo khoá học mới thành công và dữ liệu đã được cập nhật lên database.");
                }
            }
        } catch (Exception e) {
            error = e.getMessage(); // lấy lỗi để hiện ra JSP
        }

        if (error != null) {
            session.setAttribute("courseError", error); // lưu lỗi cho JSP
            request.setAttribute("courseError", error); // đẩy lỗi sang JSP
            try {
                request.setAttribute("courses", new CourseDAO().getAllCourses()); // đẩy danh sách khóa học
                request.setAttribute("users", new UserDAO().getAllUsers()); // đẩy danh sách user
                request.setAttribute("categories", new CategoryDAO().getAllCategories()); // đẩy danh sách category
            } catch (Exception ignored) {}
            request.getRequestDispatcher("/admin/course-list.jsp").forward(request, response); // quay về list
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/course-form" + (courseId > 0 ? "?id=" + courseId : "")); // ở lại màn form
    }

    private int parseInt(String value) { try { return value == null || value.isBlank() ? 0 : Integer.parseInt(value); } catch (Exception e) { return 0; } }
    private Integer parseNullableInt(String value) { try { return value == null || value.isBlank() ? null : Integer.valueOf(value); } catch (Exception e) { return null; } }
}

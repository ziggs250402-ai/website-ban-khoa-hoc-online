package controller;

import dao.CartDAO;
import dao.OrderDetailDAO;
import dao.OrdersDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.math.BigDecimal;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import model.Course;
import model.User;

@WebServlet(name = "PaymentSubmitServlet", urlPatterns = {"/payment-submit"})
@MultipartConfig
public class PaymentSubmitServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?next=payment");
            return;
        }

        Part proofImage = request.getPart("proofImage");
        if (proofImage == null || proofImage.getSize() == 0) {
            session.setAttribute("paymentMessage", "Vui lòng tải ảnh chuyển khoản trước khi gửi xác nhận.");
            response.sendRedirect(request.getContextPath() + "/payment");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        List<Course> cartCourses = cartDAO.getCartCoursesByUserId(user.getUserID());
        if (cartCourses.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?empty=1");
            return;
        }

        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Course course : cartCourses) {
            if (course.getPrice() != null) totalAmount = totalAmount.add(course.getPrice());
        }

        String fileName = Paths.get(proofImage.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/uploads/payments");
        if (uploadDir == null) {
            uploadDir = System.getProperty("java.io.tmpdir") + File.separator + "gymcode-payments";
        }
        Files.createDirectories(Paths.get(uploadDir));
        String storedName = System.currentTimeMillis() + "_" + fileName;
        Path filePath = Paths.get(uploadDir, storedName);
        proofImage.write(filePath.toString());
        String proofPath = request.getContextPath() + "/uploads/payments/" + storedName;

        OrdersDAO ordersDAO = new OrdersDAO();
        int orderId = ordersDAO.createOrder(user.getUserID(), totalAmount, "Pending");
        if (orderId > 0) {
            OrderDetailDAO detailDAO = new OrderDetailDAO();
            for (Course course : cartCourses) {
                detailDAO.addOrderDetail(orderId, course.getCourseID(), course.getPrice());
            }
            PaymentDAO paymentDAO = new PaymentDAO();
            paymentDAO.createPayment(orderId, totalAmount, "Pending", proofPath);
            cartDAO.clearCart(user.getUserID());
            session.setAttribute("paymentMessage", "Đã gửi xác nhận thanh toán. Vui lòng chờ admin duyệt.");
        } else {
            session.setAttribute("paymentMessage", "Không tạo được đơn thanh toán. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/my-courses");
    }
}

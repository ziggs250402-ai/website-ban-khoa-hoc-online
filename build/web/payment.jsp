<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Gymcode</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{
            --bg:#f5f7fb; --card:#ffffff; --text:#0f172a; --muted:#64748b; --primary:#e94560;
            --primary2:#f5a623; --border:rgba(15,23,42,.08); --shadow:0 10px 30px rgba(15,23,42,.08);
        }
        *{box-sizing:border-box}
        body{margin:0;font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        a{text-decoration:none}
        .wrap{max-width:1180px;margin:0 auto;padding:28px 20px 44px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:18px}
        .brand{font-family:'Sora',sans-serif;font-size:1.5rem;font-weight:700;color:var(--primary)}
        .brand span{color:var(--primary2)}
        .back{padding:12px 16px;border-radius:12px;background:#fff;border:1px solid var(--border);color:var(--text);font-weight:700;box-shadow:var(--shadow)}
        .panel{background:var(--card);border:1px solid var(--border);border-radius:18px;box-shadow:var(--shadow);padding:22px}
        .grid{display:grid;grid-template-columns:1.05fr .95fr;gap:18px}
        .box{background:#f8fafc;border:1px solid var(--border);border-radius:16px;padding:16px}
        .section-title{font-family:'Sora',sans-serif;font-size:1.05rem;margin:0 0 12px}
        .muted{color:var(--muted)}
        .field{margin-bottom:14px}
        label{display:block;font-weight:700;margin-bottom:8px}
        input[type="text"],input[type="email"],textarea{width:100%;padding:13px 14px;border:1px solid #dbe2ea;border-radius:12px;font:inherit;background:#fff}
        textarea{min-height:110px;resize:vertical}
        input[type="file"]{width:100%;padding:12px;background:#fff;border:1px dashed #cbd5e1;border-radius:12px}
        .btn{display:inline-flex;align-items:center;justify-content:center;width:100%;padding:14px 18px;border:0;border-radius:12px;background:var(--primary);color:#fff;font-weight:700;cursor:pointer}
        .btn:hover{background:#c73652}
        .bank{background:linear-gradient(135deg,#fff7f8,#fff9ee);border:1px solid #fde68a;border-radius:16px;padding:16px}
        .course-list{list-style:none;padding:0;margin:0}
        .course-list li{display:flex;justify-content:space-between;gap:12px;padding:10px 0;border-bottom:1px solid #e5e7eb}
        .course-list li:last-child{border-bottom:0}
        .note{font-size:.9rem;color:var(--muted);margin-top:6px}
        .small{font-size:.85rem;color:var(--muted)}
        .pill{display:inline-block;padding:6px 10px;border-radius:999px;background:#dbeafe;color:#1d4ed8;font-size:.82rem;font-weight:700;margin-bottom:10px}
        @media (max-width: 900px){.grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div class="brand">Gym<span>code</span></div>
        <a class="back" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
    </div>

    <div class="panel">
        <div class="grid">
            <form action="${pageContext.request.contextPath}/payment-submit" method="post" enctype="multipart/form-data">
                <div class="pill">Thanh toán chuyển khoản</div>
                <h1 style="margin:0 0 8px;font-family:'Sora',sans-serif;">Gửi ảnh xác nhận thanh toán</h1>
                <p class="muted" style="margin:0 0 18px;">Vui lòng chuyển khoản đúng số tiền bên phải và tải lên ảnh biên lai để admin xác nhận.</p>

                <div class="bank">
                    <h3 class="section-title">Thông tin chuyển khoản</h3>
                    <div><strong>Ngân hàng:</strong> Vietcombank</div>
                    <div><strong>Số tài khoản:</strong> 1234567890</div>
                    <div><strong>Chủ tài khoản:</strong> GYMCODE EDUCATION</div>
                    <div><strong>Nội dung:</strong> Thanh toan ${sessionScope.user.userID}</div>
                </div>

                <div style="height:16px"></div>

                <div class="field">
                    <label>Họ và tên</label>
                    <input type="text" value="${sessionScope.user.fullName}" readonly>
                </div>
                <div class="field">
                    <label>Email</label>
                    <input type="email" value="${sessionScope.user.email}" readonly>
                </div>
                <div class="field">
                    <label>Ảnh đã chuyển khoản</label>
                    <input type="file" name="proofImage" accept="image/*" required>
                    <div class="note">Bắt buộc tải ảnh biên lai hoặc ảnh chụp màn hình chuyển khoản.</div>
                </div>
                <div class="field">
                    <label>Ghi chú</label>
                    <textarea name="note" placeholder="Nhập ghi chú nếu cần"></textarea>
                </div>
                <button class="btn" type="submit">Gửi xác nhận thanh toán</button>
            </form>

            <div class="box">
                <h3 class="section-title">Tóm tắt đơn hàng</h3>
                <div class="field">
                    <label>Số khoá học</label>
                    <input type="text" value="${cartCourses != null ? cartCourses.size() : 0}" readonly>
                </div>
                <div class="field">
                    <label>Số tiền cần thanh toán</label>
                    <input type="text" value="<fmt:formatNumber value='${totalAmount}' type='currency' currencySymbol='₫' />" readonly>
                </div>
                <div class="field">
                    <label>Các khoá học trong đơn</label>
                    <ul class="course-list">
                        <c:forEach var="course" items="${cartCourses}">
                            <li>
                                <span>${course.title}</span>
                                <strong><fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₫" /></strong>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
                <div class="small">Sau khi gửi ảnh, đơn sẽ ở trạng thái chờ duyệt và giỏ hàng sẽ được reset.</div>
            </div>
        </div>
    </div>
</div>
</body>
</html>

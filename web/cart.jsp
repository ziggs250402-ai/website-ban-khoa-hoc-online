<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>Giỏ hàng - Gymcode</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f5f7fb; margin: 0; color: #1f2937; }
        .container { max-width: 1100px; margin: 0 auto; padding: 32px 20px 48px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .card { background: #fff; border-radius: 16px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08); padding: 24px; margin-bottom: 20px; }
        .grid { display: grid; grid-template-columns: 1.6fr 0.9fr; gap: 20px; }
        .course { display: flex; gap: 16px; padding: 16px 0; border-bottom: 1px solid #e5e7eb; align-items: flex-start; }
        .course:last-child { border-bottom: 0; }
        .thumb { width: 120px; height: 80px; border-radius: 12px; object-fit: cover; background: #e5e7eb; }
        .title { font-size: 18px; font-weight: 700; margin: 0 0 6px; }
        .meta { color: #6b7280; font-size: 14px; margin: 0 0 8px; }
        .price { font-size: 16px; font-weight: 700; color: #0f766e; }
        .summary-row { display: flex; justify-content: space-between; margin: 10px 0; }
        .btn { display: inline-block; background: #2563eb; color: white; text-decoration: none; padding: 12px 18px; border-radius: 12px; font-weight: 700; width: 100%; text-align: center; border: 0; cursor: pointer; }
        .btn-secondary { background: #e5e7eb; color: #111827; margin-top: 10px; }
        .btn-danger { background: #ef4444; color: #fff; padding: 10px 14px; border-radius: 10px; text-decoration: none; display: inline-block; }
        .btn-learn { background:#10b981; color:#fff; margin-top:10px; display:inline-block; width:auto; }
        .empty { text-align: center; padding: 40px 16px; color: #6b7280; }
        .badge { background: #dbeafe; color: #1d4ed8; padding: 6px 10px; border-radius: 999px; font-size: 13px; font-weight: 700; }
        .course-actions { margin-top: 10px; }
        .remove-form { margin: 0; }
        .warning { background:#fef3c7; color:#92400e; border:1px solid #f59e0b; padding:12px 14px; border-radius:12px; margin-bottom:18px; }
        @media (max-width: 900px) { .grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div>
            <h1 style="margin:0 0 6px;">Giỏ hàng</h1>
            <div class="badge">Xin chào, ${sessionScope.user.fullName}</div>
        </div>
        <a href="${pageContext.request.contextPath}/home">Về trang chủ</a>
    </div>

    <c:if test="${not empty sessionScope.cartWarning}">
        <div class="warning">${sessionScope.cartWarning}</div>
        <c:set var="_ignore" value="${sessionScope.remove('cartWarning')}" />
    </c:if>

    <c:choose>
        <c:when test="${not empty param.alreadyOwned}">
            <div class="warning">Bạn đã có khoá học này. Bạn có muốn mua tiếp không?</div>
        </c:when>
    </c:choose>

    <div class="grid">
        <div class="card">
            <h2 style="margin-top:0;">Khoá học đã thêm</h2>
            <c:choose>
                <c:when test="${empty cartCourses}">
                    <div class="empty">Giỏ hàng của bạn đang trống.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="course" items="${cartCourses}">
                        <div class="course">
                            <img class="thumb" src="${not empty course.imageURL ? course.imageURL : 'https://via.placeholder.com/240x160?text=Course'}" alt="${course.title}">
                            <div style="flex:1;">
                                <p class="title">${course.title}</p>
                                <p class="meta">${course.categoryName} • ${course.level} • ${course.instructorName}</p>
                                <p class="meta">${course.description}</p>
                                <div class="price"><fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₫" /></div>
                                <div class="course-actions">
                                    <form class="remove-form" method="post" action="${pageContext.request.contextPath}/cart" onsubmit="return confirm('Xoá khoá học này khỏi giỏ?');">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="courseId" value="${course.courseID}">
                                        <button type="submit" class="btn-danger">Xoá khỏi giỏ</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="card">
            <h2 style="margin-top:0;">Tóm tắt đơn hàng</h2>
            <div class="summary-row">
                <span>Số khoá học</span>
                <strong>${fn:length(cartCourses)}</strong>
            </div>
            <div class="summary-row">
                <span>Tổng tiền</span>
                <strong><fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₫" /></strong>
            </div>
            <p class="meta">Thanh toán sẽ chuyển sang trang payment để hoàn tất đơn hàng.</p>
            <a class="btn" href="${pageContext.request.contextPath}/payment?totalAmount=${totalAmount}">Thanh toán</a>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/my-courses">Xem khoá học của tôi</a>
        </div>
    </div>
</div>
</body>
</html>

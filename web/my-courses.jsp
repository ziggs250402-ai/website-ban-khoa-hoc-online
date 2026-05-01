<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?next=my-courses");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khoá học của tôi - Gymcode</title>
    <style>
        body{font-family:Arial,sans-serif;background:#f5f7fb;margin:0;color:#111827}
        .wrap{max-width:1100px;margin:0 auto;padding:32px 20px 48px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:20px}
        .btn{display:inline-block;padding:12px 16px;border-radius:12px;text-decoration:none;font-weight:700}
        .btn-home{background:#e5e7eb;color:#111827}
        .btn-cart{background:#2563eb;color:#fff}
        .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:16px}
        .card{background:#fff;border-radius:16px;box-shadow:0 10px 30px rgba(15,23,42,.08);overflow:hidden}
        .thumb{height:140px;background:linear-gradient(135deg,#eef2ff,#e0e7ff);display:flex;align-items:center;justify-content:center;font-size:2.4rem;overflow:hidden}
        .thumb img{width:100%;height:100%;object-fit:cover;display:block}
        .body{padding:16px}
        .meta{color:#6b7280;font-size:14px;margin:6px 0 10px}
        .price{font-weight:700;color:#0f766e}
        .empty{background:#fff;border-radius:16px;padding:24px;text-align:center;color:#6b7280}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div>
            <h1 style="margin:0 0 6px;">Khoá học của tôi</h1>
            <div>Xin chào, ${sessionScope.user.fullName}</div>
        </div>
        <div>
            <a class="btn btn-home" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
            <a class="btn btn-cart" href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
        </div>
    </div>

    <c:if test="${not empty myCoursesError}">
        <div class="empty">${myCoursesError}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty myCourses}">
            <div class="empty">Bạn chưa được kích hoạt khoá học nào.</div>
        </c:when>
        <c:otherwise>
            <div class="grid">
                <c:forEach var="course" items="${myCourses}">
                    <div class="card">
                        <div class="thumb">
                            <c:choose>
                                <c:when test="${not empty course.imageURL}">
                                    <img src="${course.imageURL}" alt="${course.title}">
                                </c:when>
                                <c:otherwise>
                                    🎓
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="body">
                            <h3 style="margin:0 0 6px;">${course.title}</h3>
                            <div class="meta">${course.categoryName} • ${course.level}</div>
                            <div class="meta">${course.instructorName}</div>
                            <div class="price"><fmt:formatNumber value="${course.price}" type="currency" currencySymbol="₫" /></div>
                            <div style="margin-top:12px;">
                                <a class="btn btn-cart" href="${pageContext.request.contextPath}/course-player?courseId=${course.courseID}">Bắt đầu học</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>

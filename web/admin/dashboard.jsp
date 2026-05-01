<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard quản trị - Gymcode</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--primary:#e94560;--primary2:#f5a623;--border:rgba(15,23,42,.08);--shadow:0 10px 30px rgba(15,23,42,.08)}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        a{text-decoration:none;color:inherit}
        .wrap{max-width:1280px;margin:0 auto;padding:24px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:16px;flex-wrap:wrap;margin-bottom:20px}
        .brand{font-family:'Sora',sans-serif;font-size:1.6rem;font-weight:700;color:var(--primary)}
        .brand span{color:var(--primary2)}
        .nav a{display:inline-block;margin-left:10px;padding:10px 14px;border-radius:10px;border:1px solid var(--border);background:#fff;box-shadow:var(--shadow)}
        .stats{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin:18px 0 24px}
        .stat{background:var(--card);border:1px solid var(--border);border-radius:18px;padding:20px;box-shadow:var(--shadow)}
        .stat .label{color:var(--muted);font-size:.9rem;margin-bottom:8px}
        .stat .value{font-family:'Sora',sans-serif;font-size:2rem;font-weight:700;color:var(--primary)}
        .section-title{font-family:'Sora',sans-serif;font-size:1.05rem;margin:24px 0 12px}
        .menu{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px}
        .menu a{display:block;background:#fff;border:1px solid var(--border);border-radius:14px;padding:16px;box-shadow:var(--shadow)}
        .menu a strong{display:block;margin-bottom:6px;color:var(--primary)}
        .card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:20px;box-shadow:var(--shadow);margin-top:20px}
        .month-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));gap:12px;margin-top:12px}
        .month-item{background:#f8fafc;border:1px solid var(--border);border-radius:14px;padding:14px}
        .month-item .month{font-weight:700;margin-bottom:6px}
        .month-item .count{font-family:'Sora',sans-serif;font-size:1.4rem;color:var(--primary)}
        @media (max-width:900px){.stats{grid-template-columns:1fr}.wrap{padding:16px}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <a class="brand" href="${pageContext.request.contextPath}/admin/dashboard">Gym<span>code</span> Admin</a>
        <div class="nav">
            <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </div>
    </div>

    <div class="stats">
        <div class="stat"><div class="label">Tổng số khoá học đang có</div><div class="value">${totalCourses}</div></div>
        <div class="stat"><div class="label">Tổng số tài khoản user</div><div class="value">${totalUsers}</div></div>
        <div class="stat"><div class="label">Tổng số tài khoản admin</div><div class="value">${totalAdmins}</div></div>
        <div class="stat"><div class="label">Tổng số đơn hàng</div><div class="value">${totalOrders}</div></div>
        <div class="stat"><div class="label">Tổng số thanh toán</div><div class="value">${totalPayments}</div></div>
        <div class="stat"><div class="label">Đăng ký từ ${fromDateLabel} đến hôm nay</div><div class="value">${enrollmentsFromDate}</div></div>
    </div>

    <div class="section-title">Menu quản trị</div>
    <div class="menu">
        <a href="${pageContext.request.contextPath}/admin/users"><strong>Tài khoản</strong></a>
        <a href="${pageContext.request.contextPath}/admin/courses"><strong>Khoá học</strong></a>
        <a href="${pageContext.request.contextPath}/admin/orders"><strong>Đơn Hàng</strong></a>
        <a href="${pageContext.request.contextPath}/admin/payments"><strong>Thanh Toán</strong></a>
    </div>

    <div class="card">
        <h3 style="font-family:'Sora',sans-serif;margin-bottom:12px;">Số khoá học đã đăng ký theo tháng</h3>
        <c:choose>
            <c:when test="${empty enrollmentByMonth}"><div class="month-item"><div class="month">Chưa có dữ liệu</div></div></c:when>
            <c:otherwise>
                <div class="month-grid">
                    <c:forEach items="${enrollmentByMonth}" var="entry">
                        <div class="month-item"><div class="month">${entry.key}</div><div class="count">${entry.value}</div></div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>

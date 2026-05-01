<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--primary:#e94560;--primary2:#f5a623;--border:rgba(15,23,42,.08);--shadow:0 10px 30px rgba(15,23,42,.08)}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        .wrap{max-width:1280px;margin:0 auto;padding:24px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:18px}
        .brand{font-family:'Sora',sans-serif;font-size:1.5rem;font-weight:700;color:var(--primary)}
        .brand span{color:var(--primary2)}
        .back{padding:10px 14px;border-radius:10px;background:#fff;border:1px solid var(--border);box-shadow:var(--shadow);text-decoration:none;color:#111827}
        .stats{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:18px}
        .stat{background:#fff;border:1px solid var(--border);border-radius:16px;padding:16px;box-shadow:var(--shadow)}
        .stat .label{color:var(--muted);font-size:.9rem}
        .stat .value{font-family:'Sora',sans-serif;font-size:1.6rem;font-weight:700;color:var(--primary);margin-top:6px}
        .card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:18px;box-shadow:var(--shadow);margin-bottom:16px}
        table{width:100%;border-collapse:collapse}
        th,td{padding:12px 10px;border-bottom:1px solid #e5e7eb;text-align:left;vertical-align:top}
        th{font-size:.9rem;color:var(--muted)}
        .status{display:inline-block;padding:6px 10px;border-radius:999px;font-size:.82rem;font-weight:700}
        .pending{background:#fef3c7;color:#92400e}.completed{background:#dcfce7;color:#166534}.cancelled{background:#fee2e2;color:#991b1b}
        @media (max-width:900px){.stats{grid-template-columns:1fr}.wrap{padding:16px}table{display:block;overflow-x:auto}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <a class="brand" href="${pageContext.request.contextPath}/admin/dashboard">Gym<span>code</span> Admin</a>
        <a class="back" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
    </div>

    <div class="stats">
        <div class="stat"><div class="label">Tổng đơn hàng</div><div class="value">${fn:length(orders)}</div></div>
        <div class="stat"><div class="label">Đơn chờ xử lý</div><div class="value">${pendingCount}</div></div>
        <div class="stat"><div class="label">Trạng thái hệ thống</div><div class="value" style="font-size:1rem;color:#16a34a;">Sẵn sàng</div></div>
    </div>

    <div class="card">
        <h2 style="font-family:'Sora',sans-serif;margin-bottom:12px;">Danh sách đơn hàng</h2>
        <table>
            <thead>
                <tr>
                    <th>OrderID</th><th>UserID</th><th>Ngày tạo</th><th>Tổng tiền</th><th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>${o.orderID}</td>
                        <td>${o.userID}</td>
                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${o.status eq 'Completed'}"><span class="status completed">${o.status}</span></c:when>
                                <c:when test="${o.status eq 'Cancelled'}"><span class="status cancelled">${o.status}</span></c:when>
                                <c:otherwise><span class="status pending">${o.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>

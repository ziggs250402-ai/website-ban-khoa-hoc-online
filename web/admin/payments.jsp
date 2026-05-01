<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt thanh toán - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--primary:#e94560;--primary2:#f5a623;--border:rgba(15,23,42,.08);--shadow:0 10px 30px rgba(15,23,42,.08)}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        .wrap{max-width:1280px;margin:0 auto;padding:24px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:18px}
        .brand{font-family:'Sora',sans-serif;font-size:1.5rem;font-weight:700;color:var(--primary)}
        .brand span{color:var(--primary2)}
        .back{padding:10px 14px;border-radius:10px;background:#fff;border:1px solid var(--border);box-shadow:var(--shadow)}
        .stats{display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:18px}
        .stat{background:#fff;border:1px solid var(--border);border-radius:16px;padding:16px;box-shadow:var(--shadow)}
        .stat .label{color:var(--muted);font-size:.9rem}
        .stat .value{font-family:'Sora',sans-serif;font-size:1.6rem;font-weight:700;color:var(--primary);margin-top:6px}
        .card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:18px;box-shadow:var(--shadow);margin-bottom:16px}
        table{width:100%;border-collapse:collapse}
        th,td{padding:12px 10px;border-bottom:1px solid #e5e7eb;text-align:left;vertical-align:top}
        th{font-size:.9rem;color:var(--muted)}
        .status{display:inline-block;padding:6px 10px;border-radius:999px;font-size:.82rem;font-weight:700}
        .pending{background:#fef3c7;color:#92400e}.approved{background:#dcfce7;color:#166534}.rejected{background:#fee2e2;color:#991b1b}
        .btn{display:inline-flex;align-items:center;justify-content:center;padding:10px 14px;border-radius:10px;border:0;cursor:pointer;font-weight:700;color:#fff}
        .btn-ok{background:#16a34a}.btn-bad{background:#dc2626}.btn-home{background:#e5e7eb;color:#111827}
        .proof{width:120px;height:80px;object-fit:cover;border-radius:10px;border:1px solid #e5e7eb;background:#f8fafc}
        .small{font-size:.85rem;color:var(--muted)}
        @media (max-width: 900px){.stats{grid-template-columns:1fr}.wrap{padding:16px}table{display:block;overflow-x:auto}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <a class="brand" href="${pageContext.request.contextPath}/admin/dashboard">Gym<span>code</span> Admin</a>
        <a class="back" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
    </div>

    <div class="stats">
        <div class="stat"><div class="label">Payment chờ duyệt</div><div class="value">${fn:length(pendingPayments)}</div></div>
        <div class="stat"><div class="label">Tất cả payment</div><div class="value">${fn:length(allPayments)}</div></div>
        <div class="stat"><div class="label">Trạng thái hệ thống</div><div class="value" style="font-size:1rem;color:#16a34a;">Sẵn sàng</div></div>
    </div>

    <div class="card">
        <h2 style="font-family:'Sora',sans-serif;margin-bottom:12px;">Thanh toán chờ duyệt</h2>
        <table>
            <thead>
                <tr>
                    <th>PaymentID</th><th>User</th><th>OrderID</th><th>Số tiền</th><th>Ngày gửi</th><th>Ảnh</th><th>Trạng thái</th><th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${pendingPayments}">
                    <tr>
                        <td>${p.paymentID}</td>
                        <td>${p.username}</td>
                        <td>${p.orderID}</td>
                        <td><fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="₫" /></td>
                        <td><fmt:formatDate value="${p.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty p.proofImagePath}">
                                    <a href="${p.proofImagePath}" target="_blank"><img class="proof" src="${p.proofImagePath}" alt="proof"></a>
                                </c:when>
                                <c:otherwise><span class="small">Không có ảnh</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><span class="status pending">${p.status}</span></td>
                        <td>
                            <div style="display:flex;gap:8px;flex-wrap:wrap;">
                                <form method="post" action="${pageContext.request.contextPath}/admin/payment-approve" style="margin:0;" onsubmit="return confirm('Xác nhận duyệt payment này?');">
                                    <input type="hidden" name="paymentId" value="${p.paymentID}">
                                    <button class="btn btn-ok" type="submit">Approved</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/payment-reject" style="margin:0;" onsubmit="return confirm('Từ chối payment này?');">
                                    <input type="hidden" name="paymentId" value="${p.paymentID}">
                                    <button class="btn btn-bad" type="submit">Reject</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="card">
        <h2 style="font-family:'Sora',sans-serif;margin-bottom:12px;">Tất cả thanh toán</h2>
        <table>
            <thead>
                <tr>
                    <th>PaymentID</th><th>User</th><th>OrderID</th><th>Số tiền</th><th>Ngày</th><th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${allPayments}">
                    <tr>
                        <td>${p.paymentID}</td>
                        <td>${p.username}</td>
                        <td>${p.orderID}</td>
                        <td><fmt:formatNumber value="${p.amount}" type="currency" currencySymbol="₫" /></td>
                        <td><fmt:formatDate value="${p.paymentDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td>
                            <c:choose>
                                <c:when test="${p.status eq 'Approved'}"><span class="status approved">${p.status}</span></c:when>
                                <c:when test="${p.status eq 'Rejected'}"><span class="status rejected">${p.status}</span></c:when>
                                <c:otherwise><span class="status pending">${p.status}</span></c:otherwise>
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

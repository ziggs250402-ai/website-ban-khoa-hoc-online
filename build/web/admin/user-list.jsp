<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--primary:#e94560;--primary2:#f5a623;--border:rgba(15,23,42,.08);--shadow:0 10px 30px rgba(15,23,42,.08)}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        .wrap{max-width:1280px;margin:0 auto;padding:24px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:18px}
        .brand{font-family:'Sora',sans-serif;font-size:1.5rem;font-weight:700;color:var(--primary)}
        .brand span{color:var(--primary2)}
        .back{padding:10px 14px;border-radius:10px;background:#fff;border:1px solid var(--border);box-shadow:var(--shadow);text-decoration:none;color:var(--text);font-weight:700}
        .card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:18px;box-shadow:var(--shadow);margin-bottom:16px}
        table{width:100%;border-collapse:collapse}
        th,td{padding:12px 10px;border-bottom:1px solid #e5e7eb;text-align:left;vertical-align:top}
        th{font-size:.9rem;color:var(--muted)}
        .status{display:inline-block;padding:6px 10px;border-radius:999px;font-size:.82rem;font-weight:700;background:#dbeafe;color:#1d4ed8}
        .btn{display:inline-flex;align-items:center;justify-content:center;padding:10px 14px;border-radius:10px;text-decoration:none;font-weight:700;border:0;cursor:pointer}
        .btn-add{background:var(--primary);color:#fff}
        .btn-edit{background:#2563eb;color:#fff}
        .btn-del{background:#dc2626;color:#fff}
        .btn-home{background:#e5e7eb;color:#111827}
        .actions{display:flex;gap:8px;flex-wrap:wrap}
        .empty{padding:18px;border:1px dashed var(--border);border-radius:14px;text-align:center;color:var(--muted);background:#fafafa}
        .muted{color:var(--muted)}
        @media (max-width:900px){.wrap{padding:16px}.card{padding:16px}table{display:block;overflow-x:auto}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <a class="brand" href="${pageContext.request.contextPath}/admin/dashboard">Gym<span>code</span> Admin</a>
        <a class="back" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
    </div>

    <div class="card" style="display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;">
        <div>
            <h1 style="font-family:'Sora',sans-serif;margin-bottom:4px;">Quản lý tài khoản</h1>
            <div class="muted">CRUD user và phân quyền</div>
        </div>
        <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/user-form">+ Thêm tài khoản</a>
    </div>

    <c:if test="${not empty param.error}">
        <div class="card"><span class="status">Không được chỉnh sửa hoặc xoá chính tài khoản admin đang đăng nhập.</span></div>
    </c:if>

    <div class="card">
        <table>
            <tr>
                <th>ID</th><th>Username</th><th>Full name</th><th>Email</th><th>Role</th><th>Ngày tạo</th><th>Actions</th>
            </tr>
            <c:forEach items="${users}" var="u">
                <tr>
                    <td>${u.userID}</td>
                    <td>${u.username}</td>
                    <td>${u.fullName}</td>
                    <td>${u.email}</td>
                    <td>${u.role}</td>
                    <td><fmt:formatDate value="${u.createdDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                    <td>
                        <c:choose>
                            <c:when test="${sessionScope.user.userID eq u.userID}">
                                <em class="muted">Admin hiện tại</em>
                            </c:when>
                            <c:otherwise>
                                <div class="actions">
                                    <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/user-form?id=${u.userID}">Sửa</a>
                                    <a class="btn btn-del" href="${pageContext.request.contextPath}/admin/user-delete?id=${u.userID}" onclick="return confirm('Xoá tài khoản này?')">Xoá</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    boolean editing = request.getAttribute("editUser") != null;
    String formAction = editing ? request.getContextPath() + "/admin/user-update" : request.getContextPath() + "/admin/user-create";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty editUser}">Sửa tài khoản</c:when><c:otherwise>Thêm tài khoản</c:otherwise></c:choose></title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--primary:#e94560;--primary2:#f5a623;--border:rgba(15,23,42,.08);--shadow:0 10px 30px rgba(15,23,42,.08)}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        .wrap{max-width:820px;margin:0 auto;padding:24px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:18px}
        .brand{font-family:'Sora',sans-serif;font-size:1.5rem;font-weight:700;color:var(--primary)}
        .brand span{color:var(--primary2)}
        .back{padding:10px 14px;border-radius:10px;background:#fff;border:1px solid var(--border);box-shadow:var(--shadow);text-decoration:none;color:var(--text);font-weight:700}
        .card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:22px;box-shadow:var(--shadow)}
        .title{font-family:'Sora',sans-serif;font-size:1.35rem;margin-bottom:14px}
        .field{margin-bottom:14px}
        label{display:block;font-weight:700;margin-bottom:8px}
        input,select{width:100%;padding:13px 14px;border:1px solid #dbe2ea;border-radius:12px;background:#fff;font:inherit}
        .btn{display:inline-flex;align-items:center;justify-content:center;padding:12px 16px;border:0;border-radius:12px;background:var(--primary);color:#fff;font-weight:700;cursor:pointer}
        .btn:hover{background:#c73652}
        .actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:12px}
        .btn-secondary{background:#e5e7eb;color:#111827}
        .muted{color:var(--muted)}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <a class="brand" href="${pageContext.request.contextPath}/admin/dashboard">Gym<span>code</span> Admin</a>
        <a class="back" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
    </div>

    <div class="card">
        <div class="title"><c:choose><c:when test="${not empty editUser}">Sửa tài khoản</c:when><c:otherwise>Thêm tài khoản</c:otherwise></c:choose></div>
        <form method="post" action="<%= formAction %>">
            <c:if test="${not empty editUser}">
                <input type="hidden" name="userID" value="${editUser.userID}">
            </c:if>
            <div class="field">
                <label>Username</label>
                <input type="text" name="username" value="${not empty editUser ? editUser.username : ''}" required>
            </div>
            <div class="field">
                <label>Password</label>
                <input type="text" name="password" value="${not empty editUser ? editUser.password : ''}" required>
            </div>
            <div class="field">
                <label>Full name</label>
                <input type="text" name="fullName" value="${not empty editUser ? editUser.fullName : ''}">
            </div>
            <div class="field">
                <label>Email</label>
                <input type="email" name="email" value="${not empty editUser ? editUser.email : ''}">
            </div>
            <div class="field">
                <label>Role</label>
                <select name="role">
                    <option value="user" <c:if test="${empty editUser or editUser.role eq 'user'}">selected</c:if>>user</option>
                    <option value="admin" <c:if test="${not empty editUser and editUser.role eq 'admin'}">selected</c:if>>admin</option>
                </select>
            </div>
            <div class="actions">
                <button type="submit" class="btn"><c:choose><c:when test="${not empty editUser}">Cập nhật</c:when><c:otherwise>Thêm mới</c:otherwise></c:choose></button>
                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users">Hủy</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

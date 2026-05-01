<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>Hồ sơ cá nhân - Gymcode</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        :root { --primary:#f8f9fb; --accent:#e94560; --accent2:#f5a623; --text:#1a1a2e; --muted:#6b7280; --border:rgba(0,0,0,0.08); --radius:14px; }
        body { font-family:'Inter',sans-serif; background:var(--primary); color:var(--text); min-height:100vh; }
        nav, footer { background:#fff; }
        nav { border-bottom:1px solid var(--border); padding:0 40px; display:flex; align-items:center; justify-content:space-between; height:64px; position:sticky; top:0; }
        .nav-logo { font-family:'Sora',sans-serif; font-weight:700; font-size:1.4rem; color:var(--accent); text-decoration:none; }
        .nav-logo span { color:var(--accent2); }
        .btn { padding:9px 18px; border-radius:10px; text-decoration:none; font-size:0.875rem; font-weight:600; border:1px solid #d1d5db; color:var(--text); background:#fff; }
        .container { max-width:980px; margin:0 auto; padding:40px 24px; }
        .card { background:#fff; border:1px solid var(--border); border-radius:var(--radius); padding:28px; box-shadow:0 1px 4px rgba(0,0,0,0.05); }
        .title { font-family:'Sora',sans-serif; font-size:1.6rem; margin-bottom:8px; }
        .sub { color:var(--muted); margin-bottom:24px; }
        .grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .item { padding:16px; border:1px solid var(--border); border-radius:12px; background:#fafafa; }
        .label { font-size:0.8rem; color:var(--muted); margin-bottom:6px; }
        .value { font-size:1rem; font-weight:700; }
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-top:24px; }
        .form-group label { display:block; margin-bottom:6px; font-size:0.875rem; font-weight:600; }
        .form-group input { width:100%; padding:12px 14px; border:1px solid #d1d5db; border-radius:10px; }
        .hint { font-size:0.82rem; color:var(--muted); margin-top:6px; }
        .actions { margin-top:20px; display:flex; gap:10px; }
        .btn-submit { background:var(--accent); color:#fff; border:none; }
        .btn-submit:hover { background:#c73652; }
        footer { text-align:center; padding:24px; color:var(--muted); font-size:0.8rem; border-top:1px solid var(--border); margin-top:40px; }
        @media (max-width:700px){ nav{padding:0 16px;} .grid,.form-grid{grid-template-columns:1fr;} }
    </style>
</head>
<body>
<nav>
    <div style="display:flex; align-items:center; gap:32px;">
        <a href="${pageContext.request.contextPath}/home" class="nav-logo">Gym<span>code</span></a>
        <a href="${pageContext.request.contextPath}/home" class="btn">Trang chủ</a>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/logout" class="btn">Đăng xuất</a>
    </div>
</nav>

<div class="container">
    <div class="card">
        <div class="title">Hồ sơ cá nhân</div>
        <div class="sub">Bạn có thể xem và cập nhật thông tin của chính mình</div>

        <c:if test="${not empty profileError}">
            <p style="color:#b91c1c; margin-bottom:16px;">${profileError}</p>
        </c:if>

        <div class="grid">
            <div class="item"><div class="label">Họ và tên</div><div class="value">${profileUser.fullName}</div></div>
            <div class="item"><div class="label">Username</div><div class="value">${profileUser.username}</div></div>
            <div class="item"><div class="label">Email</div><div class="value">${profileUser.email}</div></div>
            <div class="item"><div class="label">Vai trò</div><div class="value">${profileUser.role}</div></div>
        </div>

        <form class="form-grid" method="post" action="${pageContext.request.contextPath}/profile-update">
            <div class="form-group">
                <label for="fullName">Họ và tên</label>
                <input type="text" id="fullName" name="fullName" value="${profileUser.fullName}">
            </div>
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" value="${profileUser.username}" readonly>
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${profileUser.email}">
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu mới</label>
                <input type="password" id="password" name="password" placeholder="Nhập mật khẩu mới nếu muốn đổi">
                <div class="hint">Để trống nếu không muốn đổi mật khẩu.</div>
            </div>
            <div class="actions">
                <button type="submit" class="btn btn-submit">Cập nhật hồ sơ</button>
            </div>
        </form>
    </div>
</div>

<footer>&copy; 2026 Gymcode. Nền tảng học trực tuyến.</footer>
</body>
</html>

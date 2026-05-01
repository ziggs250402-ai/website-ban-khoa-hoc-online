<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Gymcode</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --primary: #f8f9fb;
            --accent: #e94560;
            --accent2: #f5a623;
            --surface: #ffffff;
            --card: #eef1f7;
            --text: #1a1a2e;
            --muted: #6b7280;
            --success-bg: #d4edda;
            --success-text: #155724;
            --error-bg: #f8d7da;
            --error-text: #721c24;
            --border: rgba(0,0,0,0.08);
            --radius: 12px;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--primary);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── NAVBAR ── */
        nav {
            background: #ffffff;
            border-bottom: 1px solid var(--border);
            padding: 0 40px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
        }
        .nav-logo {
            font-family: 'Sora', sans-serif;
            font-weight: 700;
            font-size: 1.4rem;
            color: var(--accent);
            text-decoration: none;
            letter-spacing: -0.5px;
        }
        .nav-logo span { color: var(--accent2); }
        .nav-actions { display: flex; gap: 12px; align-items: center; }
        .nav-user { font-size: 0.85rem; color: var(--muted); }
        .nav-user strong { color: var(--text); }
        .nav-link {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text);
            text-decoration: none;
            padding: 6px 12px;
            border-radius: 8px;
            transition: background 0.15s;
        }
        .nav-link:hover { background: var(--card); color: var(--accent); }

        /* ── BUTTONS ── */
        .btn {
            padding: 9px 20px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-primary   { background: var(--accent); color: #fff; }
        .btn-primary:hover   { background: #c73652; transform: translateY(-1px); }
        .btn-secondary { background: transparent; color: var(--text); border: 1px solid #d1d5db; }
        .btn-secondary:hover { background: var(--card); }

        /* ── AUTH LAYOUT ── */
        .auth-container {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 24px;
        }
        .auth-box {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            padding: 36px 36px 32px;
            width: 100%;
            max-width: 480px;
        }

        /* ── BRAND ── */
        .auth-brand { text-align: center; margin-bottom: 28px; }
        .auth-brand .icon { font-size: 2.2rem; display: block; margin-bottom: 8px; }
        .auth-brand h2 {
            font-family: 'Sora', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 4px;
        }
        .auth-brand p { font-size: 0.875rem; color: var(--muted); }

        /* ── MESSAGE ── */
        .message {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: var(--radius);
            font-size: 0.9rem;
        }
        .message.success { background: var(--success-bg); color: var(--success-text); }
        .message.error   { background: var(--error-bg);   color: var(--error-text); }

        /* ── FORM ── */
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text);
            margin-bottom: 6px;
        }
        .form-group label .required { color: var(--accent); margin-left: 2px; }
        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            color: var(--text);
            background: #fff;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control::placeholder { color: #9ca3af; }
        .form-control:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(233,69,96,0.1);
        }

        /* ── PASSWORD TOGGLE ── */
        .pw-wrap { position: relative; }
        .pw-wrap .form-control { padding-right: 44px; }
        .toggle-pw {
            position: absolute;
            right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            cursor: pointer; color: var(--muted);
            font-size: 1rem; padding: 0; line-height: 1;
        }
        .toggle-pw:hover { color: var(--accent); }

        /* ── SUBMIT ── */
        .btn-submit {
            width: 100%;
            padding: 11px;
            background: var(--accent);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
            margin-top: 6px;
        }
        .btn-submit:hover  { background: #c73652; transform: translateY(-1px); }
        .btn-submit:active { transform: translateY(0); }

        /* ── DIVIDER / FOOTER ── */
        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 22px 0 18px; color: var(--muted); font-size: 0.8rem;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px; background: var(--border);
        }
        .auth-footer { text-align: center; font-size: 0.875rem; color: var(--muted); }
        .auth-footer a { color: var(--accent); text-decoration: none; font-weight: 500; }
        .auth-footer a:hover { text-decoration: underline; }

        /* ── PAGE FOOTER ── */
        footer {
            text-align: center;
            padding: 24px;
            color: var(--muted);
            font-size: 0.8rem;
            border-top: 1px solid var(--border);
            background: #fff;
        }

        @media (max-width: 500px) {
            .auth-box { padding: 28px 20px 24px; }
            .form-row { grid-template-columns: 1fr; }
            nav { padding: 0 16px; }
        }
    </style>
</head>
<body>

    <!-- ── NAVBAR ── -->
    <nav>
        <div style="display:flex; align-items:center; gap:32px;">
            <a href="${pageContext.request.contextPath}/index.html" class="nav-logo">Gym<span>code</span></a>
            <a href="${pageContext.request.contextPath}/index.html"   class="nav-link">📚 Danh sách khoá học</a>
        </div>
        <div class="nav-actions">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="nav-user">Xin chào, <strong>${sessionScope.user.fullName}</strong></span>
                    <a href="${pageContext.request.contextPath}/profile.jsp" class="btn btn-secondary">Hồ sơ</a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login.jsp"    class="btn btn-secondary">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <!-- ── FORM ── -->
    <div class="auth-container">
        <div class="auth-box">

            <div class="auth-brand">
                <span class="icon">✨</span>
                <h2>Tạo tài khoản mới</h2>
                <p>Tham gia và bắt đầu học ngay hôm nay</p>
            </div>

            <c:if test="${not empty error}">
                <div class="message error">⚠️ ${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="message success">✅ ${success}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/register">

                <div class="form-group">
                    <label for="fullName">Họ và tên <span class="required">*</span></label>
                    <input type="text" id="fullName" name="fullName" class="form-control"
                           placeholder="Nguyễn Văn A"
                           value="${not empty fullName ? fullName : ''}"
                           maxlength="100" required autofocus>
                </div>

                <div class="form-group">
                    <label for="username">Username <span class="required">*</span></label>
                    <input type="text" id="username" name="username" class="form-control"
                           placeholder="nguyenvana"
                           value="${not empty username ? username : ''}"
                           maxlength="50" required>
                </div>

                <div class="form-group">
                    <label for="email">Email <span class="required">*</span></label>
                    <input type="email" id="email" name="email" class="form-control"
                           placeholder="your@email.com"
                           value="${not empty email ? email : ''}"
                           maxlength="100" required>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu <span class="required">*</span></label>
                    <div class="pw-wrap">
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Tối thiểu 8 ký tự" maxlength="128" required>
                        <button type="button" class="toggle-pw" onclick="togglePw('password', this)">👁</button>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu <span class="required">*</span></label>
                    <div class="pw-wrap">
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="Nhập lại mật khẩu" maxlength="128" required>
                        <button type="button" class="toggle-pw" onclick="togglePw('confirmPassword', this)">👁</button>
                    </div>
                </div>

                <button type="submit" class="btn-submit">Tạo tài khoản</button>
            </form>

            <div class="divider">hoặc</div>

            <div class="auth-footer">
                Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập ngay</a>
            </div>

        </div>
    </div>

    <footer>&copy; 2026 Gymcode. Nền tảng học trực tuyến.</footer>

    <script>
        function togglePw(inputId, btn) {
            var inp = document.getElementById(inputId);
            inp.type = inp.type === 'password' ? 'text' : 'password';
            btn.textContent = inp.type === 'password' ? '👁' : '🙈';
        }
    </script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khoá học</title>
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
        .btn{display:inline-flex;align-items:center;justify-content:center;padding:10px 14px;border-radius:10px;text-decoration:none;font-weight:700;border:0;cursor:pointer}
        .btn-add{background:var(--primary);color:#fff}
        .btn-edit{background:#2563eb;color:#fff}
        .btn-del{background:#dc2626;color:#fff}
        .btn-lessons{background:#16a34a;color:#fff}
        .btn-home{background:#e5e7eb;color:#111827}
        .actions{display:flex;gap:8px;flex-wrap:wrap}
        .title{font-family:'Sora',sans-serif;font-size:1.35rem;margin-bottom:4px}
        .muted{color:var(--muted)}
        .field{margin-bottom:14px}
        label{display:block;font-weight:700;margin-bottom:8px}
        input,textarea{width:100%;padding:13px 14px;border:1px solid #dbe2ea;border-radius:12px;background:#fff;font:inherit}
        textarea{min-height:110px;resize:vertical}
        .form-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:10px}
        @media (max-width:900px){.wrap{padding:16px}table{display:block;overflow-x:auto}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <a class="brand" href="${pageContext.request.contextPath}/admin/dasboard">Gym<span>code</span> Admin</a>
        <a class="back" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
        <a class="back" href="${pageContext.request.contextPath}/admin/courses">Về danh sách khoá học</a>
    </div>

    <div class="card" style="display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;">
        <div>
            <div class="title">Quản lý khoá học</div>
            <div class="muted">CRUD khoá học và vào quản lý lesson</div>
        </div>
        <a class="btn btn-add" href="${pageContext.request.contextPath}/admin/course-form">+ Thêm khoá học</a>
    </div>

    <div class="card">
        <table>
            <tr><th>ID</th><th>Title</th><th>Price</th><th>Level</th><th>Created</th><th>Actions</th></tr>
            <c:forEach items="${courses}" var="course">
                <tr>
                    <td>${course.courseID}</td>
                    <td>${course.title}</td>
                    <td>${course.price}</td>
                    <td>${course.level}</td>
                    <td><c:if test="${not empty course.createdDate}">${course.createdDate}</c:if></td>
                    <td>
                        <div class="actions">
                            <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/course-form?id=${course.courseID}">Sửa</a>
                            <form method="post" action="${pageContext.request.contextPath}/admin/courses" style="display:inline;" onsubmit="return confirm('Xoá khoá học này?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="courseID" value="${course.courseID}">
                                <button class="btn btn-del" type="submit">Xoá</button>
                            </form>
                            <a class="btn btn-lessons" href="${pageContext.request.contextPath}/admin/course-lessons?courseId=${course.courseID}">Lesson</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
</div>
</body>
</html>

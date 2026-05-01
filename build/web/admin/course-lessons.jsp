<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý lesson</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--primary:#e94560;--primary2:#f5a623;--border:rgba(15,23,42,.08);--shadow:0 10px 30px rgba(15,23,42,.08)}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        .wrap{max-width:1280px;margin:0 auto;padding:24px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:18px}
        .brand{font-family:'Sora',sans-serif;font-size:1.5rem;font-weight:700;color:var(--primary)}
        .back{padding:10px 14px;border-radius:10px;background:#fff;border:1px solid var(--border);box-shadow:var(--shadow);text-decoration:none;color:var(--text);font-weight:700}
        .card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:18px;box-shadow:var(--shadow);margin-bottom:16px}
        table{width:100%;border-collapse:collapse}
        th,td{padding:12px 10px;border-bottom:1px solid #e5e7eb;text-align:left;vertical-align:top}
        th{font-size:.9rem;color:var(--muted)}
        .btn{display:inline-flex;align-items:center;justify-content:center;padding:10px 14px;border-radius:10px;text-decoration:none;font-weight:700;border:0;cursor:pointer}
        .btn-add{background:var(--primary);color:#fff}
        .btn-edit{background:#2563eb;color:#fff}
        .btn-del{background:#dc2626;color:#fff}
        .btn-home{background:#e5e7eb;color:#111827}
        .actions{display:flex;gap:8px;flex-wrap:wrap}
        .grid{display:grid;grid-template-columns:repeat(2,1fr);gap:14px}
        label{display:block;font-weight:700;margin-bottom:8px}
        input{width:100%;padding:13px 14px;border:1px solid #dbe2ea;border-radius:12px;background:#fff;font:inherit}
        .muted{color:var(--muted)}
        @media (max-width:900px){.wrap{padding:16px}.grid{grid-template-columns:1fr}table{display:block;overflow-x:auto}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <a class="brand" href="${pageContext.request.contextPath}/admin/dashboard">Gym<span>code</span> Admin</a>
         <a class="back" href="${pageContext.request.contextPath}/admin/courses">Về danh sách khoá học</a>
        <a class="back" href="${pageContext.request.contextPath}/admin/dashboard">Về dashboard</a>
    </div>

    <div class="card">
        <h2 style="font-family:'Sora',sans-serif;margin-bottom:6px;">Lesson của khoá học: ${course.title}</h2>
        <div class="muted">Thêm, sửa, xoá video trong cùng khoá học</div>
    </div>

    <c:if test="${not empty lessonError}">
        <div class="card"><div class="muted">${lessonError}</div></div>
    </c:if>

    <div class="card">
        <h3 style="font-family:'Sora',sans-serif;margin-bottom:12px;">Danh sách lesson</h3>
        <c:choose>
            <c:when test="${empty lessons}">
                <div class="muted">Khoá học này chưa có video nào.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <tr><th>STT</th><th>Lesson</th><th>VideoURL</th><th>Actions</th></tr>
                    <c:forEach items="${lessons}" var="l" varStatus="s">
                        <tr>
                            <td>${l.lessonOrder > 0 ? l.lessonOrder : s.index + 1}</td>
                            <td>${l.title}</td>
                            <td>
                                <div style="display:flex;flex-direction:column;gap:8px;">
                                    <div style="word-break:break-all;">${l.videoURL}</div>
                                    <c:if test="${not empty l.videoURL}">
                                        <a href="${l.videoURL}" target="_blank" class="btn btn-home" style="width:max-content;">Xem video</a>
                                    </c:if>
                                </div>
                            </td>
                            <td>
                                <div class="actions">
                                    <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/course-lessons?courseId=${course.courseID}&editLessonId=${l.lessonID}">Sửa</a>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/lesson-delete" style="display:inline;" onsubmit="return confirm('Xoá lesson này?');">
                                        <input type="hidden" name="courseId" value="${course.courseID}">
                                        <input type="hidden" name="lessonId" value="${l.lessonID}">
                                        <button class="btn btn-del" type="submit">Xoá</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card">
        <h3 style="font-family:'Sora',sans-serif;margin-bottom:12px;">Thêm / sửa lesson</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/lesson-save">
            <input type="hidden" name="courseId" value="${course.courseID}">
            <input type="hidden" name="lessonId" value="${not empty editLesson ? editLesson.lessonID : 0}">
            <div class="grid">
                <div><label>STT video</label><input name="lessonOrder" type="number" min="1" value="${not empty editLesson ? editLesson.lessonOrder : ''}" required></div>
                <div><label>Title</label><input name="title" value="${not empty editLesson ? editLesson.title : ''}" required></div>
                <div><label>Video URL</label><input name="videoURL" value="${not empty editLesson ? editLesson.videoURL : ''}" required></div>
            </div>
            <div style="margin-top:12px;display:flex;gap:10px;flex-wrap:wrap;">
                <button class="btn btn-add" type="submit"><c:choose><c:when test="${not empty editLesson}">Cập nhật lesson</c:when><c:otherwise>Thêm lesson</c:otherwise></c:choose></button>
                <a class="btn btn-home" href="${pageContext.request.contextPath}/admin/course-lessons?courseId=${course.courseID}">Làm mới</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>

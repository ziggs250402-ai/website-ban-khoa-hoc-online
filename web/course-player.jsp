<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    <title>Học khoá học - Gymcode</title>
    <style>
        body{font-family:Arial,sans-serif;background:#f5f7fb;margin:0;color:#111827}
        .wrap{max-width:1200px;margin:0 auto;padding:28px 20px 44px}
        .top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;margin-bottom:20px}
        .btn{display:inline-block;padding:12px 16px;border-radius:12px;text-decoration:none;font-weight:700}
        .btn-home{background:#e5e7eb;color:#111827}
        .btn-back{background:#2563eb;color:#fff}
        .grid{display:grid;grid-template-columns:320px 1fr;gap:18px}
        .card{background:#fff;border-radius:16px;box-shadow:0 10px 30px rgba(15,23,42,.08);padding:18px}
        .lesson{padding:12px 0;border-bottom:1px solid #e5e7eb}
        .lesson:last-child{border-bottom:0}
        .lesson a{text-decoration:none;color:#111827;font-weight:700}
        .lesson a.active{color:#2563eb}
        .player{aspect-ratio:16/9;background:#000;border-radius:16px;overflow:hidden}
        iframe, video{width:100%;height:100%;border:0}
        .muted{color:#6b7280}
        .nav-lesson{display:flex;justify-content:space-between;gap:12px;margin-top:16px;flex-wrap:wrap}
        .nav-lesson .btn{border:0;cursor:pointer}
        .btn-prev{background:#e5e7eb;color:#111827}
        .btn-next{background:#2563eb;color:#fff}
        @media (max-width: 900px){.grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div>
            <h1 style="margin:0 0 6px;">${course.title}</h1>
            <div class="muted">${course.categoryName} • ${course.level} • ${course.instructorName}</div>
        </div>
        <div>
            <a class="btn btn-back" href="${pageContext.request.contextPath}/my-courses">Back về khoá học của tôi</a>
            <a class="btn btn-home" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
        </div>
    </div>

    <c:if test="${not empty playerError}">
        <div class="card">${playerError}</div>
    </c:if>

    <c:if test="${empty course}">
        <div class="card">Không tìm thấy khoá học để hiển thị.</div>
    </c:if>

    <c:if test="${not empty course}">
        <div class="grid">
            <div class="card">
                <h3 style="margin-top:0;">Danh sách bài học</h3>
                <c:choose>
                    <c:when test="${empty lessons}">
                        <div class="muted">Khoá học này chưa có lesson.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="lesson" items="${lessons}" varStatus="status">
                            <div class="lesson">
                                <a class="${status.index == selectedIndex ? 'active' : ''}" href="${pageContext.request.contextPath}/course-player?courseId=${course.courseID}&lessonId=${lesson.lessonID}">Video ${status.index + 1} - ${empty lesson.title ? 'Bài học' : lesson.title}</a>
                                <div class="muted">${lesson.lessonOrder} phút</div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card">
                <h3 style="margin-top:0;">Video bài học</h3>
                <c:choose>
                    <c:when test="${not empty selectedLesson}">
                        <div class="player">
                            <c:choose>
                                <c:when test="${not empty selectedLesson.videoURL and (fn:contains(selectedLesson.videoURL, 'youtube.com') or fn:contains(selectedLesson.videoURL, 'youtu.be'))}">
                                    <iframe src="${fn:contains(selectedLesson.videoURL, 'watch?v=') ? 'https://www.youtube.com/embed/'.concat(fn:substringAfter(selectedLesson.videoURL, 'watch?v=')) : (fn:contains(selectedLesson.videoURL, 'youtu.be/') ? 'https://www.youtube.com/embed/'.concat(fn:substringAfter(selectedLesson.videoURL, 'youtu.be/')) : selectedLesson.videoURL)}" allowfullscreen></iframe>
                                </c:when>
                                <c:when test="${not empty selectedLesson.videoURL}">
                                    <video controls>
                                        <source src="${fn:startsWith(selectedLesson.videoURL, '/') ? pageContext.request.contextPath.concat(selectedLesson.videoURL) : selectedLesson.videoURL}">
                                    </video>
                                </c:when>
                                <c:otherwise>
                                    <div style="color:#fff;display:flex;align-items:center;justify-content:center;height:100%;">Chưa có link video</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <h4 style="margin:16px 0 6px;">${empty selectedLesson.title ? 'Bài học' : selectedLesson.title}</h4>
                        <div class="muted">${selectedLesson.duration} phút</div>
                        <c:if test="${not empty selectedLesson.videoURL}">
                            <div style="margin-top:10px;">
                                <a class="btn btn-home" href="${selectedLesson.videoURL}" target="_blank" rel="noopener noreferrer">Mở video trực tiếp</a>
                            </div>
                        </c:if>
                        <div class="nav-lesson">
                            <c:if test="${selectedIndex > 0}">
                                <a class="btn btn-prev" href="${pageContext.request.contextPath}/course-player?courseId=${course.courseID}&lessonId=${lessons[selectedIndex - 1].lessonID}">Back</a>
                            </c:if>
                            <c:if test="${selectedIndex < lessonCount - 1}">
                                <a class="btn btn-next" href="${pageContext.request.contextPath}/course-player?courseId=${course.courseID}&lessonId=${lessons[selectedIndex + 1].lessonID}">Next</a>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="muted">Chưa chọn bài học nào.</div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>

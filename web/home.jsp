<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gymcode - Học Trực Tuyến</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --primary: #f8f9fb;
            --accent: #e94560;
            --accent2: #f5a623;
            --text: #1a1a2e;
            --muted: #6b7280;
            --border: rgba(0,0,0,0.08);
            --radius: 14px;
            --card: #ffffff;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: var(--primary);
            color: var(--text);
            min-height: 100vh;
        }
        a { color: inherit; text-decoration: none; }
        nav {
            background: #fff;
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
        }
        .nav-logo span { color: var(--accent2); }
        .nav-actions { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; }
        .btn {
            padding: 10px 18px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: 1px solid transparent;
            cursor: pointer;
        }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: #c73652; }
        .btn-secondary { background: #fff; color: var(--text); border-color: #d1d5db; }
        .btn-secondary:hover { background: #f3f4f6; }
        .hero {
            background: linear-gradient(135deg, #1a1a2e 0%, #111827 100%);
            padding: 84px 24px 72px;
            text-align: center;
        }
        .hero h1 {
            font-family: 'Sora', sans-serif;
            font-size: clamp(2rem, 4vw, 3.2rem);
            font-weight: 700;
            color: #fff;
            line-height: 1.15;
            margin-bottom: 16px;
        }
        .hero h1 span { color: var(--accent2); }
        .hero p {
            color: rgba(255,255,255,0.72);
            font-size: 1rem;
            max-width: 700px;
            margin: 0 auto 28px;
            line-height: 1.7;
        }
        .hero-actions { display: flex; justify-content: center; gap: 14px; flex-wrap: wrap; }
        .btn-hero {
            padding: 14px 28px;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-hero.primary { background: var(--accent); color: #fff; }
        .btn-hero.primary:hover { background: #c73652; }
        .btn-hero.outline { background: transparent; color: #fff; border: 2px solid rgba(255,255,255,0.22); }
        .btn-hero.outline:hover { border-color: #fff; background: rgba(255,255,255,0.08); }
        .container { max-width: 1220px; margin: 0 auto; padding: 38px 24px 50px; }
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 34px;
        }
        .stat-item {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 22px;
            text-align: center;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        }
        .stat-item .num {
            display: block;
            font-family: 'Sora', sans-serif;
            font-size: 1.7rem;
            font-weight: 700;
            color: var(--accent);
            margin-bottom: 6px;
        }
        .stat-item .lbl { color: var(--muted); font-size: 0.85rem; }
        .section-label {
            font-family: 'Sora', sans-serif;
            font-size: 1rem;
            font-weight: 700;
            color: #d97706;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin: 24px 0 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .section-label::after { content: ''; flex: 1; height: 1px; background: var(--border); }
        .course-search-wrap { display: flex; justify-content: center; margin-bottom: 14px; }
        .course-search {
            width: 100%;
            max-width: 780px;
            padding: 14px 16px;
            border: 1px solid var(--border);
            border-radius: 12px;
            background: #fff;
            font-size: 0.95rem;
            outline: none;
        }
        .course-filter-hint { text-align: center; color: var(--muted); font-size: 0.85rem; margin-bottom: 18px; }
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .home-pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            align-items: center;
            margin-top: 12px;
            flex-wrap: wrap;
        }
        .course-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
            color: var(--text);
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            transition: transform 0.18s, box-shadow 0.18s;
        }
        .course-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.08); }
        .course-thumb {
            height: 210px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.7rem;
            overflow: hidden;
            background: linear-gradient(135deg,#fff5f7,#ffe4ea);
        }
        .course-thumb img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            display: block;
        }
        .course-body { padding: 16px; background: #fff; }
        .course-cat {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--accent);
            background: rgba(233,69,96,0.08);
            padding: 3px 10px;
            border-radius: 999px;
            display: inline-block;
            margin-bottom: 8px;
        }
        .course-title { font-family: 'Sora', sans-serif; font-size: 0.95rem; font-weight: 700; margin-bottom: 6px; line-height: 1.4; }
        .course-meta { font-size: 0.82rem; color: var(--muted); margin-bottom: 12px; }
        .course-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 1px solid var(--border);
        }
        .price { font-weight: 800; color: var(--accent2); font-size: 0.95rem; }
        .price.free { color: #16a34a; }
        .empty {
            display: none;
            text-align: center;
            padding: 22px;
            border: 1px dashed var(--border);
            border-radius: var(--radius);
            color: var(--muted);
            background: #fff;
        }
        @media (max-width: 900px) { .stats-row { grid-template-columns: repeat(2, 1fr); } .course-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
        @media (max-width: 768px) {
            nav { padding: 0 16px; }
            .container { padding: 24px 16px 40px; }
            .hero { padding: 64px 16px 54px; }
            .course-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<nav>
    <a href="${pageContext.request.contextPath}/home" class="nav-logo">Gym<span>code</span></a>
    <div class="nav-actions">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <span>Xin chào, ${sessionScope.user.fullName}</span>
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">Hồ sơ</a>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-secondary">Giỏ hàng</a>
                <a href="${pageContext.request.contextPath}/my-courses" class="btn btn-secondary">Khoá học của tôi</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-secondary">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-secondary">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<section class="hero">
    <h1>Học kỹ năng mới,<br><span>thăng tiến sự nghiệp</span></h1>
    <p>Khám phá các khoá học thực chiến, cập nhật liên tục theo nhu cầu thị trường.</p>
    <div class="hero-actions">
        <a href="#featured-courses" class="btn-hero primary">Khám phá khoá học →</a>
    </div>
</section>

<div class="container" id="featured-courses">
    <div class="stats-row">
        <div class="stat-item"><span class="num">500+</span><span class="lbl">Khoá học</span></div>
        <div class="stat-item"><span class="num">20K+</span><span class="lbl">Học viên</span></div>
        <div class="stat-item"><span class="num">150+</span><span class="lbl">Giảng viên</span></div>
        <div class="stat-item"><span class="num">98%</span><span class="lbl">Hài lòng</span></div>
    </div>

    <div class="section-label">🔥 Khoá học nổi bật</div>
    <form class="course-search-wrap" method="get" action="${pageContext.request.contextPath}/home">
        <input id="courseSearch" name="q" class="course-search" type="search" value="${searchQuery}" placeholder="Tìm theo tên khoá học, giáo viên, giá, danh mục, cấp độ...">
    </form>
    <div class="course-filter-hint">Bạn có thể tìm theo tên khoá học, tên giáo viên, giá, cấp độ hoặc danh mục.</div>

    <c:if test="${not empty searchQuery}">
        <div class="section-label" style="margin-top:0;">Kết quả tìm kiếm: ${searchCount} khoá học</div>
    </c:if>

    <c:if test="${empty featuredCourses}">
        <div class="empty" style="display:block;">Không tìm thấy khoá học phù hợp.</div>
    </c:if>

    <div class="course-grid" id="featuredCourses">
        <c:forEach items="${featuredCourses}" var="course">
            <div class="course-card">
                <div class="course-thumb">
                    <c:choose>
                        <c:when test="${not empty course.imageURL}">
                            <img src="${fn:startsWith(course.imageURL, 'http') ? course.imageURL : pageContext.request.contextPath.concat(course.imageURL)}" alt="${course.title}">
                        </c:when>
                        <c:otherwise>
                            <div style="width:100%;height:100%;display:flex;align-items:center;justify-content:center;font-size:2.7rem;">🎓</div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="course-body">
                    <span class="course-cat">${course.categoryName}</span>
                    <div class="course-title">${course.title}</div>
                    <div class="course-meta">👨‍🏫 ${course.instructorName} &nbsp;·&nbsp; ${course.level}</div>
                    <div class="course-footer">
                        <span class="price"><fmt:formatNumber value="${course.price}" type="number" groupingUsed="true"/>đ</span>
                        <a href="${pageContext.request.contextPath}/buy-course?courseId=${course.courseID}" class="btn btn-primary">Mua khoá học</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="home-pagination">
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/home?page=${currentPage > 1 ? currentPage - 1 : 1}${not empty searchQuery ? '&amp;q='.concat(searchQuery) : ''}">Back</a>
            <c:forEach begin="1" end="${totalPages}" var="p">
                <a class="btn ${p == currentPage ? 'btn-primary' : 'btn-secondary'}" href="${pageContext.request.contextPath}/home?page=${p}${not empty searchQuery ? '&amp;q='.concat(searchQuery) : ''}">${p}</a>
            </c:forEach>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/home?page=${currentPage < totalPages ? currentPage + 1 : totalPages}${not empty searchQuery ? '&amp;q='.concat(searchQuery) : ''}">Next</a>
        </div>
    </c:if>
</div>

<script>
    const courseSearch = document.getElementById('courseSearch');
    if (courseSearch) {
        courseSearch.addEventListener('keydown', (event) => {
            if (event.key === 'Enter') {
                event.preventDefault();
                courseSearch.form?.submit();
            }
        });
    }
</script>
</body>
</html>

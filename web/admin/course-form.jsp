<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty editCourse}">Sửa khoá học</c:when><c:otherwise>Thêm khoá học</c:otherwise></c:choose></title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@400;600;700&family=Inter:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root{--bg:#f5f7fb;--card:#fff;--text:#0f172a;--muted:#64748b;--primary:#e94560;--primary2:#f5a623;--border:rgba(15,23,42,.08);--shadow:0 10px 30px rgba(15,23,42,.08)}
        *{box-sizing:border-box;margin:0;padding:0}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text)}
        .wrap{max-width:1100px;margin:0 auto;padding:24px}
        .card{background:#fff;border:1px solid var(--border);border-radius:18px;padding:18px;box-shadow:var(--shadow);margin-bottom:16px}
        .title{font-family:'Sora',sans-serif;font-size:1.4rem;font-weight:700;margin-bottom:4px;color:var(--primary)}
        .muted{color:var(--muted)}
        .grid{display:grid;grid-template-columns:repeat(2,1fr);gap:14px}
        label{display:block;font-weight:700;margin-bottom:8px}
        input,textarea,select{width:100%;padding:13px 14px;border:1px solid #dbe2ea;border-radius:12px;background:#fff;font:inherit}
        textarea{min-height:110px;resize:vertical}
        .actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:14px}
        .btn{display:inline-flex;align-items:center;justify-content:center;padding:10px 14px;border-radius:10px;text-decoration:none;font-weight:700;border:0;cursor:pointer}
        .btn-add{background:var(--primary);color:#fff}
        .btn-home{background:#e5e7eb;color:#111827}
        .alert{padding:12px 14px;border-radius:12px;margin-top:12px;font-weight:600}
        .alert-error{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}
        .alert-success{background:#dcfce7;color:#166534;border:1px solid #bbf7d0}
        .preview-wrap{margin-top:10px;border:1px dashed #dbe2ea;border-radius:12px;padding:12px;background:#fafafa;display:flex;align-items:center;justify-content:center;min-height:220px;overflow:hidden}
        .preview-wrap img{max-width:100%;max-height:200px;object-fit:cover;border-radius:10px;display:block}
        @media (max-width:900px){.grid{grid-template-columns:1fr}.wrap{padding:16px}}
    </style>
</head>
<body>
<div class="wrap">
    <div class="card">
        <div class="title"><c:choose><c:when test="${not empty editCourse}">Sửa khoá học</c:when><c:otherwise>Thêm khoá học</c:otherwise></c:choose></div>
        <div class="muted">Chọn Category và Instructor từ danh sách để tránh nhập sai ID.</div>
        <c:if test="${not empty sessionScope.courseError}">
            <div class="alert alert-error">${sessionScope.courseError}</div>
            <c:remove var="courseError" scope="session" />
        </c:if>
        <c:if test="${not empty sessionScope.courseSuccess}">
            <div class="alert alert-success">${sessionScope.courseSuccess}</div>
            <c:remove var="courseSuccess" scope="session" />
        </c:if>
    </div>

    <div class="card">
        <form method="post" action="${pageContext.request.contextPath}/admin/courses" enctype="multipart/form-data">
            <input type="hidden" name="courseID" value="${not empty editCourse ? editCourse.courseID : 0}">
            <input type="hidden" name="action" value="${not empty editCourse ? 'update' : 'create'}">
            <div class="grid">
                <div><label>Title</label><input name="title" value="${not empty editCourse ? editCourse.title : ''}" required></div>
                <div><label>Price (VND)</label><input name="price" type="number" min="0" max="999999999" step="1000" value="${not empty editCourse ? editCourse.price : ''}" required></div>
                <div><label>Description</label><textarea name="description">${not empty editCourse ? editCourse.description : ''}</textarea></div>
                <div>
                    <label>Level</label>
                    <select name="level">
                        <option value="">-- Chọn level --</option>
                        <option value="Beginner" ${editCourse.level == 'Beginner' ? 'selected' : ''}>Beginner</option>
                        <option value="Intermediate" ${editCourse.level == 'Intermediate' ? 'selected' : ''}>Intermediate</option>
                        <option value="Advanced" ${editCourse.level == 'Advanced' ? 'selected' : ''}>Advanced</option>
                    </select>
                </div>
                <div>
                    <label>Image upload</label>
                    <input type="file" name="imageFile" accept="image/*" id="imageFile">
                    <div class="muted" style="margin-top:6px;font-size:.9rem;">Nếu không chọn file mới, ảnh cũ sẽ được giữ nguyên khi sửa.</div>
                    <div class="preview-wrap">
                        <c:choose>
                            <c:when test="${not empty editCourse and not empty editCourse.imageURL}">
                                <img id="imagePreview" src="${pageContext.request.contextPath}${editCourse.imageURL}" alt="Preview" onerror="this.style.display='none'; document.getElementById('previewPlaceholder').style.display='block';">
                                <span id="previewPlaceholder" class="muted" style="display:none;">Ảnh không tải được, hãy chọn ảnh khác</span>
                            </c:when>
                            <c:otherwise>
                                <img id="imagePreview" style="display:none;" alt="Preview">
                                <span id="previewPlaceholder" class="muted">Chưa có ảnh xem trước</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div>
                    <label>Category</label>
                    <select name="categoryID" required>
                        <option value="">-- Chọn Category --</option>
                        <c:forEach items="${categories}" var="category">
                            <option value="${category.categoryID}" ${not empty editCourse and editCourse.categoryID == category.categoryID ? 'selected' : ''}>
                                ${category.categoryName} (ID: ${category.categoryID})
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label>Instructor</label>
                    <select name="instructorID" required>
                        <option value="">-- Chọn Instructor --</option>
                        <c:forEach items="${users}" var="user">
                            <option value="${user.userID}" ${not empty editCourse and editCourse.instructorID == user.userID ? 'selected' : ''}>
                                ${user.fullName} - ${user.username} (ID: ${user.userID})
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="actions">
                <button type="submit" class="btn btn-add"><c:choose><c:when test="${not empty editCourse}">Cập nhật</c:when><c:otherwise>Lưu khoá học</c:otherwise></c:choose></button>
                <a class="btn btn-home" href="${pageContext.request.contextPath}/admin/courses">Về danh sách khoá học</a>
            </div>
        </form>
    </div>
</div>
<script>
    const fileInput = document.getElementById('imageFile');
    const preview = document.getElementById('imagePreview');
    const placeholder = document.getElementById('previewPlaceholder');
    if (fileInput && preview) {
        fileInput.addEventListener('change', function () {
            const file = this.files && this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    if (placeholder) placeholder.style.display = 'none';
                };
                reader.readAsDataURL(file);
            }
        });
    }
</script>
</body>
</html>
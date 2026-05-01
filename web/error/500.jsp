<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Lỗi hệ thống</title>
    <style>
        body{font-family:Arial,sans-serif;background:#f5f7fb;margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;color:#111827}
        .box{background:#fff;border-radius:18px;padding:32px 28px;max-width:520px;width:calc(100% - 32px);box-shadow:0 10px 30px rgba(15,23,42,.08);text-align:center}
        .code{font-size:72px;font-weight:800;color:#ef4444;line-height:1}
        .title{font-size:28px;font-weight:800;margin:12px 0}
        .desc{color:#6b7280;margin-bottom:20px}
        .btn{display:inline-block;padding:12px 16px;border-radius:12px;text-decoration:none;font-weight:700;margin:6px}
        .btn-primary{background:#2563eb;color:#fff}
        .btn-secondary{background:#e5e7eb;color:#111827}
    </style>
</head>
<body>
<div class="box">
    <div class="code">500</div>
    <div class="title">Lỗi hệ thống</div>
    <div class="desc">Đã xảy ra lỗi ở máy chủ. Vui lòng thử lại sau.</div>
    <a class="btn btn-secondary" href="javascript:history.back()">Quay lại</a>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
</div>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error 403 - FPT Lost & Found</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">
</head>
<body>
<div class="error-page">
    <div>
        <div class="error-code">403</div>
        <div class="error-title">Access Denied</div>
        <p class="error-desc">You don't have permission to view this page.</p>
        <a href="javascript:history.back()" class="btn btn-outline-secondary me-2">Go Back</a>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Home</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
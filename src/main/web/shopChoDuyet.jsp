<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Shop đang chờ duyệt</title>
    <style>
        body { margin: 0; min-height: 100vh; display: grid; place-items: center; font-family: Arial, sans-serif; background: #fffbeb; color: #78350f; }
        .card { width: min(620px, calc(100% - 32px)); padding: 36px; border-radius: 22px; background: #fff7ed; border: 1px solid #fed7aa; box-shadow: 0 18px 45px rgba(120, 53, 15, 0.14); text-align: center; }
        h1 { margin-top: 0; }
        p { line-height: 1.7; }
        a { display: inline-block; margin-top: 12px; color: #9a3412; font-weight: 700; }
    </style>
</head>
<body>
<main class="card">
    <h1>Đang chờ duyệt thông tin</h1>
    <p>Shop <strong>${shop.shopName}</strong> đã được gửi lên hệ thống. Vui lòng chờ SuperAdmin kiểm tra và duyệt.</p>
    <a href="${pageContext.request.contextPath}/dangnhap">Quay lại đăng nhập</a>
</main>
</body>
</html>

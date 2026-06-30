<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang quản lý shop</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #f8fafc; color: #0f172a; }
        .hero { padding: 36px 48px; background: linear-gradient(135deg, #0f766e, #172554); color: white; }
        .hero h1 { margin: 0 0 8px; }
        .content { max-width: 980px; margin: 28px auto; padding: 0 18px; }
        .card { background: white; border-radius: 18px; padding: 26px; box-shadow: 0 14px 36px rgba(15, 23, 42, 0.1); }
        .actions { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 22px; }
        .btn { padding: 11px 16px; border-radius: 999px; background: #0f766e; color: white; text-decoration: none; font-weight: 800; }
        .btn.secondary { background: #334155; }
        dl { display: grid; grid-template-columns: 160px 1fr; gap: 10px; }
        dt { font-weight: 800; color: #475569; }
        dd { margin: 0; }
    </style>
</head>
<body>
<header class="hero">
    <h1>Trang quản lý shop</h1>
    <p>Shop của bạn đã được duyệt.</p>
</header>

<main class="content">
    <section class="card">
        <h2>${shop.shopName}</h2>
        <dl>
            <dt>Trạng thái</dt>
            <dd>${shop.status}</dd>
            <dt>Số điện thoại</dt>
            <dd>${shop.shopPhone}</dd>
            <dt>Địa chỉ</dt>
            <dd>${shop.shopAddress}</dd>
            <dt>Mô tả</dt>
            <dd>${shop.shopDescription}</dd>
        </dl>

        <div class="actions">
            <a class="btn" href="${pageContext.request.contextPath}/shops">Vào quản lý cửa hàng</a>
            <a class="btn secondary" href="${pageContext.request.contextPath}/shops?action=edit&id=${shop.iD}">Cập nhật thông tin shop</a>
        </div>
    </section>
</main>
</body>
</html>

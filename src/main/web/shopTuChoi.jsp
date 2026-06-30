<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Shop bị từ chối</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: #fef2f2; color: #7f1d1d; }
        .wrap { max-width: 760px; margin: 44px auto; padding: 0 18px; }
        .card { background: #fff; border: 1px solid #fecaca; border-radius: 18px; padding: 32px; box-shadow: 0 18px 45px rgba(127, 29, 29, 0.12); }
        .reason { padding: 14px; border-radius: 12px; background: #fee2e2; }
        label { display: block; margin-top: 16px; font-weight: 700; }
        input, textarea { width: 100%; box-sizing: border-box; margin-top: 7px; padding: 12px; border: 1px solid #cbd5e1; border-radius: 10px; }
        textarea { min-height: 100px; resize: vertical; }
        button { margin-top: 22px; padding: 12px 18px; border: 0; border-radius: 999px; background: #b91c1c; color: white; font-weight: 800; cursor: pointer; }
    </style>
</head>
<body>
<main class="wrap">
    <section class="card">
        <h1>Thông tin shop bị từ chối</h1>
        <p class="reason"><strong>Lý do:</strong> ${shop.rejectionReason}</p>
        <p>Chỉnh lại thông tin bên dưới và gửi lại yêu cầu duyệt.</p>

        <form action="${pageContext.request.contextPath}/shop" method="post" accept-charset="UTF-8">
            <label for="shopName">Tên shop</label>
            <input id="shopName" type="text" name="shopName" value="${shop.shopName}" required>

            <label for="shopDescription">Mô tả shop</label>
            <textarea id="shopDescription" name="shopDescription">${shop.shopDescription}</textarea>

            <label for="shopAddress">Địa chỉ</label>
            <input id="shopAddress" type="text" name="shopAddress" value="${shop.shopAddress}" required>

            <label for="shopPhone">Số điện thoại shop</label>
            <input id="shopPhone" type="text" name="shopPhone" value="${shop.shopPhone}" required>

            <label for="shopLogo">Logo URL</label>
            <input id="shopLogo" type="text" name="shopLogo" value="${shop.shopLogo}">

            <button type="submit">Gửi lại yêu cầu</button>
        </form>
    </section>
</main>
</body>
</html>

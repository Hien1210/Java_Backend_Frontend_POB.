<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán thất bại</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #333;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,.1);
            padding: 36px 32px;
            max-width: 480px;
            text-align: center;
        }
        .icon { font-size: 48px; margin-bottom: 12px; }
        h1 { font-size: 20px; color: #c0392b; margin-bottom: 10px; }
        p.msg { font-size: 14px; color: #555; margin-bottom: 24px; line-height: 1.5; }
        .btn {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            margin: 0 6px;
        }
        .btn-primary { background: #27ae60; color: #fff; }
        .btn-secondary { background: #eee; color: #333; }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon">❌</div>
        <h1>Thanh toán không thành công</h1>
        <p class="msg">
            <c:out value="${not empty loi ? loi : 'Giao dich PayOS da bi huy hoac khong thanh cong. Vui long thu lai.'}"/>
        </p>
        <c:if test="${not empty order}">
            <p class="msg">Mã đơn hàng: #${order.id}</p>
        </c:if>
        <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary">🛒 Về giỏ hàng</a>
    </div>
</body>
</html>

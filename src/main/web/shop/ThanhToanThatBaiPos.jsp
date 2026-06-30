<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SHOP (roleId = 2) --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

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
        p.msg { font-size: 14px; color: #555; margin-bottom: 16px; line-height: 1.5; }
        .btn {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }
        .btn-primary { background: #27ae60; color: #fff; }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon">❌</div>
        <h1>Thanh toán PayOS thất bại</h1>
        <p class="msg">
            <c:out value="${not empty loi ? loi : 'Giao dich PayOS da bi huy hoac khong thanh cong.'}"/>
        </p>
        <c:if test="${not empty order}">
            <p class="msg">Mã đơn hàng: #${order.id} — Hóa đơn này sẽ <strong>không được lưu</strong> sau khi bạn xác nhận.</p>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/shop/pos">
            <input type="hidden" name="action" value="discardOrder">
            <input type="hidden" name="id" value="${order.id}">
            <button type="submit" class="btn btn-primary">✅ Xác nhận</button>
        </form>
    </div>
</body>
</html>

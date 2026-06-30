<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #333;
        }

        nav {
            background: #2c3e50;
            padding: 0 32px;
            display: flex;
            align-items: center;
            height: 56px;
            gap: 8px;
        }
        nav a {
            color: #ecf0f1;
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 4px;
            font-size: 14px;
        }
        nav a:hover, nav a.active { background: #3d5a73; }

        .container {
            max-width: 760px;
            margin: 32px auto;
            padding: 0 16px;
        }

        .page-header h1 { font-size: 22px; font-weight: 600; color: #2c3e50; margin-bottom: 20px; }

        .card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
            padding: 20px 24px;
            margin-bottom: 20px;
        }
        .card h2 { font-size: 16px; color: #2c3e50; margin-bottom: 14px; }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 8px; text-align: left; font-size: 14px; border-bottom: 1px solid #eee; }
        thead th { color: #888; font-weight: 600; font-size: 13px; }
        td.num, th.num { text-align: right; }

        .shop-group { margin-bottom: 12px; }
        .shop-group .shop-name { font-weight: 600; color: #2980b9; margin: 12px 0 4px; }

        .totals { margin-top: 12px; text-align: right; font-size: 14px; }
        .totals .line { margin-bottom: 6px; }
        .totals .grand { font-size: 18px; font-weight: 700; color: #2c3e50; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; font-size: 13px; color: #555; margin-bottom: 4px; }
        .form-group input, .form-group select {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            border: none;
        }
        .btn-primary { background: #27ae60; color: #fff; width: 100%; font-size: 16px; padding: 12px; }
        .btn-primary:hover { opacity: .9; }

        .alert { padding: 12px 16px; border-radius: 5px; margin-bottom: 16px; font-size: 14px; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

<nav>
    <a href="${pageContext.request.contextPath}/trangchu.jsp">🏠 Trang chủ</a>
    <a href="${pageContext.request.contextPath}/cart">🛒 Giỏ hàng</a>
    <a href="${pageContext.request.contextPath}/checkout" class="active">💳 Thanh toán</a>
</nav>

<div class="container">
    <div class="page-header">
        <h1>💳 Xác nhận hóa đơn thanh toán</h1>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">❌ ${error}</div>
    </c:if>

    <div class="card">
        <h2>Chi tiết hóa đơn (Giỏ hàng #${cart.id})</h2>
        <table>
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Size</th>
                    <th class="num">SL</th>
                    <th class="num">Đơn giá</th>
                    <th class="num">Thành tiền</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${lines}" var="line" varStatus="s">
                    <c:if test="${s.first or line.shopName ne lines[s.index - 1].shopName}">
                        <tr><td colspan="5" class="shop-name">🏪 ${line.shopName}</td></tr>
                    </c:if>
                    <tr>
                        <td>${line.productName}</td>
                        <td>${line.sizeName}</td>
                        <td class="num">${line.quantity}</td>
                        <td class="num"><fmt:formatNumber value="${line.unitPrice}" type="number"/> đ</td>
                        <td class="num"><fmt:formatNumber value="${line.lineTotal}" type="number"/> đ</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="totals">
            <div class="line">Tạm tính: <fmt:formatNumber value="${subtotal}" type="number"/> đ</div>
            <div class="grand">Tổng cộng (chưa gồm phí giao hàng nhập bên dưới)</div>
        </div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/checkout">
        <input type="hidden" name="cartId" value="${cart.id}">

        <div class="card">
            <h2>Thông tin nhận hàng</h2>

            <div class="form-group">
                <label>Tên người nhận</label>
                <input type="text" name="receiverName" value="${param.receiverName}" required>
            </div>
            <div class="form-group">
                <label>Số điện thoại</label>
                <input type="text" name="receiverPhone" value="${param.receiverPhone}" required>
            </div>
            <div class="form-group">
                <label>Địa chỉ giao hàng</label>
                <input type="text" name="shippingAddress" value="${param.shippingAddress}" required>
            </div>
            <div class="form-group">
                <label>Phương thức thanh toán</label>
                <select name="paymentMethod" required>
                    <option value="COD" ${param.paymentMethod eq 'COD' ? 'selected' : ''}>Thanh toán khi nhận hàng (COD)</option>
                    <option value="PAYOS" ${param.paymentMethod eq 'PAYOS' ? 'selected' : ''}>Thanh toán online qua PayOS (QR Code)</option>
                </select>
            </div>
            <div class="form-group">
                <label>Phí giao hàng (đ) — áp dụng cho mỗi shop trong đơn</label>
                <input type="number" step="1000" min="0" name="deliveryFee" value="${param.deliveryFee != null ? param.deliveryFee : 0}">
            </div>
        </div>

        <button type="submit" class="btn btn-primary">✅ Xác nhận thanh toán</button>
    </form>
</div>

</body>
</html>

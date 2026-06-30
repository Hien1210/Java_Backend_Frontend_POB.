<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn</title>
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
        nav a { color: #ecf0f1; text-decoration: none; padding: 8px 14px; border-radius: 4px; font-size: 14px; }
        nav a:hover { background: #3d5a73; }

        .container { max-width: 720px; margin: 32px auto; padding: 0 16px; }

        .alert-success {
            background: #d4edda; color: #155724; border: 1px solid #c3e6cb;
            padding: 12px 16px; border-radius: 5px; margin-bottom: 20px; font-size: 14px;
        }

        .bill {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
            padding: 28px 32px;
            margin-bottom: 24px;
        }
        .bill-header { text-align: center; margin-bottom: 18px; border-bottom: 2px dashed #ddd; padding-bottom: 14px; }
        .bill-header h2 { color: #2c3e50; font-size: 20px; }
        .bill-header .order-id { color: #888; font-size: 13px; margin-top: 4px; }

        .info-row { display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 6px; }
        .info-row span:first-child { color: #888; }

        table { width: 100%; border-collapse: collapse; margin: 16px 0; }
        th, td { padding: 8px; text-align: left; font-size: 14px; border-bottom: 1px solid #eee; }
        th.num, td.num { text-align: right; }

        .totals { text-align: right; font-size: 14px; }
        .totals .line { margin-bottom: 6px; }
        .totals .grand { font-size: 18px; font-weight: 700; color: #c0392b; margin-top: 6px; }

        .status-badge {
            display: inline-block; padding: 3px 10px; border-radius: 12px;
            font-size: 12px; font-weight: 600; background: #fff3cd; color: #856404;
        }

        .actions { text-align: center; margin-top: 12px; }
        .btn {
            display: inline-block; padding: 10px 22px; border-radius: 5px;
            text-decoration: none; font-size: 14px; cursor: pointer; border: none;
        }
        .btn-primary { background: #2980b9; color: #fff; }

        @media print {
            nav, .actions { display: none; }
        }
    </style>
</head>
<body>

<nav>
    <a href="${pageContext.request.contextPath}/trangchu.jsp">🏠 Trang chủ</a>
    <a href="${pageContext.request.contextPath}/cart">🛒 Giỏ hàng</a>
    <a href="${pageContext.request.contextPath}/orders">📋 Đơn hàng</a>
</nav>

<div class="container">
    <div class="alert-success">✅ Thanh toán thành công! Dưới đây là hóa đơn của bạn.</div>

    <c:forEach items="${bills}" var="bill">
        <div class="bill">
            <div class="bill-header">
                <h2>🧾 HÓA ĐƠN THANH TOÁN</h2>
                <div class="order-id">Mã đơn hàng: #${bill.order.id} — ${bill.shopName}</div>
            </div>

            <div class="info-row"><span>Người nhận</span><span>${bill.order.receiverName}</span></div>
            <div class="info-row"><span>Số điện thoại</span><span>${bill.order.receiverPhone}</span></div>
            <div class="info-row"><span>Địa chỉ giao hàng</span><span>${bill.order.shippingAddress}</span></div>
            <div class="info-row"><span>Phương thức thanh toán</span><span>${bill.order.paymentMethod}</span></div>
            <div class="info-row"><span>Trạng thái</span><span class="status-badge">${bill.order.staTus}</span></div>
            <div class="info-row"><span>Thời gian tạo</span><span>${bill.order.createdAt}</span></div>

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
                    <c:forEach items="${bill.lines}" var="line">
                        <tr>
                            <td>${line.productName}</td>
                            <td>${line.sizeName}</td>
                            <td class="num">${line.quantity}</td>
                            <td class="num"><fmt:formatNumber value="${line.price}" type="number"/> đ</td>
                            <td class="num"><fmt:formatNumber value="${line.lineTotal}" type="number"/> đ</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="totals">
                <div class="line">Tạm tính: <fmt:formatNumber value="${bill.subtotal}" type="number"/> đ</div>
                <div class="line">Phí giao hàng: <fmt:formatNumber value="${bill.order.deliveryFee}" type="number"/> đ</div>
                <div class="grand">Tổng thanh toán: <fmt:formatNumber value="${bill.order.totalPrice}" type="number"/> đ</div>
            </div>
        </div>
    </c:forEach>

    <div class="actions">
        <a href="#" class="btn btn-primary" onclick="window.print(); return false;">🖨️ In hóa đơn</a>
    </div>
</div>

</body>
</html>

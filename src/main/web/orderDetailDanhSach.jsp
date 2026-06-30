<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quan ly chi tiet don hang</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f4f6; margin: 0; color: #111827; }
        nav { background: #111827; padding: 14px 28px; display: flex; gap: 10px; }
        nav a { color: #e5e7eb; text-decoration: none; padding: 8px 12px; border-radius: 6px; }
        nav a:hover, nav a.active { background: #374151; }
        .container { max-width: 960px; margin: 32px auto; padding: 0 16px; }
        .header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 18px; }
        .btn { display: inline-block; padding: 8px 14px; border-radius: 6px; text-decoration: none; font-size: 14px; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-warning { background: #f59e0b; color: #111827; }
        .btn-danger { background: #dc2626; color: #fff; }
        .alert { padding: 12px 14px; border-radius: 6px; margin-bottom: 14px; }
        .ok { background: #dcfce7; color: #166534; }
        .err { background: #fee2e2; color: #991b1b; }
        table { width: 100%; border-collapse: collapse; background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,.08); border-radius: 8px; overflow: hidden; }
        th, td { padding: 12px 14px; border-bottom: 1px solid #e5e7eb; text-align: left; }
        th { background: #111827; color: #fff; font-size: 12px; text-transform: uppercase; }
        .actions { display: flex; gap: 8px; }
        .empty { background: #fff; padding: 40px; border-radius: 8px; text-align: center; color: #6b7280; }
    </style>
</head>
<body>
<nav>
    <a href="${pageContext.request.contextPath}/orders">Don hang</a>
    <a href="${pageContext.request.contextPath}/order-details" class="active">Chi tiet don hang</a>
    <a href="${pageContext.request.contextPath}/cart-items">Chi tiet gio hang</a>
</nav>

<div class="container">
    <div class="header">
        <h1>Chi tiet don hang</h1>
        <a href="${pageContext.request.contextPath}/order-details?action=new" class="btn btn-primary">+ Them moi</a>
    </div>

    <c:if test="${param.success eq 'created'}"><div class="alert ok">Tao chi tiet don hang thanh cong.</div></c:if>
    <c:if test="${param.success eq 'updated'}"><div class="alert ok">Cap nhat chi tiet don hang thanh cong.</div></c:if>
    <c:if test="${param.success eq 'deleted'}"><div class="alert ok">Xoa chi tiet don hang thanh cong.</div></c:if>
    <c:if test="${param.error eq 'not_found'}"><div class="alert err">Khong tim thay chi tiet don hang.</div></c:if>

    <c:choose>
        <c:when test="${empty orderDetailList}">
            <div class="empty">Chua co chi tiet don hang nao.</div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Order ID</th>
                    <th>Product ID</th>
                    <th>Product Size ID</th>
                    <th>So luong</th>
                    <th>Gia</th>
                    <th>Thao tac</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="detail" items="${orderDetailList}">
                    <tr>
                        <td>#${detail.id}</td>
                        <td>${detail.orderId}</td>
                        <td>${detail.productId}</td>
                        <td>${detail.productSizeId}</td>
                        <td>${detail.quantity}</td>
                        <td>${detail.price}</td>
                        <td>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/order-details?action=edit&id=${detail.id}" class="btn btn-warning">Sua</a>
                                <a href="${pageContext.request.contextPath}/order-details?action=delete&id=${detail.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('Xoa chi tiet don hang #${detail.id}?')">Xoa</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>

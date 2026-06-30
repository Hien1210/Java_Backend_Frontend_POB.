<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quan ly don hang</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f3f4f6; color: #1f2937; }
        nav { background: #111827; height: 56px; display: flex; align-items: center; gap: 8px; padding: 0 28px; }
        nav a { color: #e5e7eb; text-decoration: none; padding: 8px 12px; border-radius: 6px; font-size: 14px; }
        nav a:hover, nav a.active { background: #374151; }
        .container { max-width: 1180px; margin: 32px auto; padding: 0 16px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; gap: 12px; }
        h1 { font-size: 24px; }
        .btn { display: inline-block; padding: 8px 14px; border-radius: 6px; text-decoration: none; border: 0; cursor: pointer; font-size: 13px; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-warning { background: #f59e0b; color: #111827; }
        .btn-danger { background: #dc2626; color: #fff; }
        .alert { padding: 12px 14px; border-radius: 6px; margin-bottom: 14px; font-size: 14px; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 1px 4px rgba(0,0,0,.08); }
        th, td { padding: 12px 14px; text-align: left; border-bottom: 1px solid #e5e7eb; font-size: 14px; vertical-align: top; }
        th { background: #111827; color: #fff; font-size: 12px; text-transform: uppercase; }
        tr:hover td { background: #f9fafb; }
        .actions { display: flex; gap: 8px; flex-wrap: wrap; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 999px; background: #e0f2fe; color: #075985; font-size: 12px; font-weight: 700; }
        .empty { background: #fff; padding: 44px; border-radius: 8px; text-align: center; color: #6b7280; }
    </style>
</head>
<body>
<nav>
    <a href="${pageContext.request.contextPath}/">Trang chu</a>
    <a href="${pageContext.request.contextPath}/cart">Gio hang</a>
    <a href="${pageContext.request.contextPath}/orders" class="active">Don hang</a>
</nav>

<div class="container">
    <div class="page-header">
        <h1>Quan ly don hang</h1>
        <a href="${pageContext.request.contextPath}/orders?action=new" class="btn btn-primary">+ Them don hang</a>
    </div>

    <c:if test="${param.success eq 'created'}">
        <div class="alert alert-success">Tao don hang thanh cong.</div>
    </c:if>
    <c:if test="${param.success eq 'updated'}">
        <div class="alert alert-success">Cap nhat don hang thanh cong.</div>
    </c:if>
    <c:if test="${param.success eq 'deleted'}">
        <div class="alert alert-success">Xoa don hang thanh cong.</div>
    </c:if>
    <c:if test="${param.error eq 'not_found'}">
        <div class="alert alert-error">Khong tim thay don hang.</div>
    </c:if>

    <c:choose>
        <c:when test="${empty orderList}">
            <div class="empty">
                Chua co don hang nao. <a href="${pageContext.request.contextPath}/orders?action=new">Them don hang moi</a>.
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Shop</th>
                    <th>Shipper</th>
                    <th>Nguoi nhan</th>
                    <th>Dia chi</th>
                    <th>Tong tien</th>
                    <th>Thanh toan</th>
                    <th>Trang thai</th>
                    <th>Thao tac</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="order" items="${orderList}">
                    <tr>
                        <td>#${order.id}</td>
                        <td>${order.userId}</td>
                        <td>${order.shopId}</td>
                        <td>${order.shipperId == 0 ? '-' : order.shipperId}</td>
                        <td>
                            <strong><c:out value="${order.receiverName}"/></strong><br>
                            <c:out value="${order.receiverPhone}"/>
                        </td>
                        <td><c:out value="${order.shippingAddress}"/></td>
                        <td>
                            <strong>${order.totalPrice}</strong><br>
                            Phi ship: ${order.deliveryFee}
                        </td>
                        <td><c:out value="${order.paymentMethod}"/></td>
                        <td><span class="badge"><c:out value="${order.staTus}"/></span></td>
                        <td>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/orders?action=edit&id=${order.id}" class="btn btn-warning">Sua</a>
                                <a href="${pageContext.request.contextPath}/orders?action=delete&id=${order.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('Xoa don hang #${order.id}?')">Xoa</a>
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

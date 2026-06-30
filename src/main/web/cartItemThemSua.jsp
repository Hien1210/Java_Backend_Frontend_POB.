<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${empty cartItem || cartItem.id == 0 ? 'Them chi tiet gio hang' : 'Sua chi tiet gio hang'}</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f3f4f6; margin: 0; color: #111827; }
        nav { background: #111827; padding: 14px 28px; display: flex; gap: 10px; }
        nav a { color: #e5e7eb; text-decoration: none; padding: 8px 12px; border-radius: 6px; }
        nav a:hover, nav a.active { background: #374151; }
        .container { max-width: 560px; margin: 32px auto; padding: 0 16px; }
        .card { background: #fff; padding: 26px; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,.08); }
        h1 { font-size: 22px; margin-top: 0; }
        .group { margin-bottom: 16px; }
        label { display: block; font-weight: 700; margin-bottom: 6px; }
        input { width: 100%; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 6px; }
        .alert { background: #fee2e2; color: #991b1b; padding: 10px 12px; border-radius: 6px; margin-bottom: 14px; }
        .actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn { padding: 10px 16px; border-radius: 6px; border: 0; text-decoration: none; cursor: pointer; font-weight: 700; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-secondary { background: #e5e7eb; color: #111827; }
    </style>
</head>
<body>
<nav>
    <a href="${pageContext.request.contextPath}/cart">Gio hang</a>
    <a href="${pageContext.request.contextPath}/cart-items" class="active">Chi tiet gio hang</a>
    <a href="${pageContext.request.contextPath}/orders">Don hang</a>
</nav>

<div class="container">
    <div class="card">
        <h1>
            <c:choose>
                <c:when test="${empty cartItem || cartItem.id == 0}">Them chi tiet gio hang</c:when>
                <c:otherwise>Sua chi tiet gio hang #${cartItem.id}</c:otherwise>
            </c:choose>
        </h1>

        <c:if test="${not empty error}">
            <div class="alert"><c:out value="${error}"/></div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/cart-items">
            <input type="hidden" name="action" value="${empty cartItem || cartItem.id == 0 ? 'create' : 'update'}">
            <c:if test="${not empty cartItem && cartItem.id > 0}">
                <input type="hidden" name="id" value="${cartItem.id}">
            </c:if>

            <div class="group">
                <label for="cartId">Cart ID *</label>
                <input type="number" id="cartId" name="cartId" min="1" value="${cartItem.cartId}" required>
            </div>
            <div class="group">
                <label for="productId">Product ID *</label>
                <input type="number" id="productId" name="productId" min="1" value="${cartItem.productId}" required>
            </div>
            <div class="group">
                <label for="productSizeId">Product Size ID *</label>
                <input type="number" id="productSizeId" name="productSizeId" min="1" value="${cartItem.productSizeId}" required>
            </div>
            <div class="group">
                <label for="quantity">So luong *</label>
                <input type="number" id="quantity" name="quantity" min="1" value="${cartItem.quantity}" required>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/cart-items" class="btn btn-secondary">Quay lai</a>
                <button type="submit" class="btn btn-primary">${empty cartItem || cartItem.id == 0 ? 'Them moi' : 'Cap nhat'}</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>

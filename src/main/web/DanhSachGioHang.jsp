<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Giỏ hàng</title>
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
            transition: background .2s;
        }
        nav a:hover, nav a.active { background: #3d5a73; }

        .container {
            max-width: 960px;
            margin: 32px auto;
            padding: 0 16px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .page-header h1 { font-size: 22px; font-weight: 600; color: #2c3e50; }

        .btn {
            display: inline-block;
            padding: 8px 18px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            border: none;
            transition: opacity .2s;
        }
        .btn:hover { opacity: .85; }
        .btn-primary { background: #2980b9; color: #fff; }
        .btn-success { background: #27ae60; color: #fff; }
        .btn-warning { background: #e67e22; color: #fff; }
        .btn-danger  { background: #e74c3c; color: #fff; }

        .alert {
            padding: 12px 16px;
            border-radius: 5px;
            margin-bottom: 16px;
            font-size: 14px;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error   { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
        }
        thead { background: #2c3e50; color: #fff; }
        th, td {
            padding: 12px 16px;
            text-align: left;
            font-size: 14px;
        }
        tbody tr:nth-child(even) { background: #f8f9fa; }
        tbody tr:hover { background: #eaf4fb; }

        .actions { display: flex; gap: 8px; }

        .empty {
            text-align: center;
            padding: 48px;
            color: #888;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,.08);
        }
    </style>
</head>
<body>

<nav>
    <a href="${pageContext.request.contextPath}/trangchu.jsp">🏠 Trang chủ</a>
    <a href="${pageContext.request.contextPath}/cart" class="active">🛒 Giỏ hàng</a>
    <%-- Thêm các link menu khác ở đây --%>
</nav>

<div class="container">
    <div class="page-header">
        <h1>🛒 Quản lý Giỏ hàng</h1>
        <a href="${pageContext.request.contextPath}/cart?action=new" class="btn btn-primary">+ Thêm mới</a>
    </div>

    <%-- Thông báo --%>
    <c:if test="${param.success eq 'created'}">
        <div class="alert alert-success">✅ Thêm giỏ hàng thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'updated'}">
        <div class="alert alert-success">✅ Cập nhật giỏ hàng thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'deleted'}">
        <div class="alert alert-success">✅ Xóa giỏ hàng thành công!</div>
    </c:if>
    <c:if test="${param.error eq 'not_found'}">
        <div class="alert alert-error">❌ Không tìm thấy giỏ hàng!</div>
    </c:if>
    <c:if test="${param.error eq 'empty_cart'}">
        <div class="alert alert-error">❌ Giỏ hàng trống hoặc sản phẩm không còn hợp lệ, không thể thanh toán!</div>
    </c:if>

    <%-- Bảng danh sách --%>
    <c:choose>
        <c:when test="${empty cartList}">
            <div class="empty">
                <p style="font-size:40px;margin-bottom:12px">🛒</p>
                <p>Chưa có giỏ hàng nào. <a href="${pageContext.request.contextPath}/cart?action=new">Thêm mới ngay!</a></p>
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>ID</th>
                        <th>User ID</th>
                        <th>Ngày tạo</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${cartList}" var="cart" varStatus="s">
                        <tr>
                            <td>${s.index + 1}</td>
                            <td>${cart.id}</td>
                            <td>${cart.userId}</td>
                            <td>${cart.createdAt}</td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/checkout?cartId=${cart.id}"
                                   class="btn btn-success">💳 Thanh toán</a>
                                <a href="${pageContext.request.contextPath}/cart?action=edit&id=${cart.id}"
                                   class="btn btn-warning">✏️ Sửa</a>
                                <a href="${pageContext.request.contextPath}/cart?action=delete&id=${cart.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('Xóa giỏ hàng ID ${cart.id}?')">🗑️ Xóa</a>
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

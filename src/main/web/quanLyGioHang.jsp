<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #333;
        }

        /* ===== NAVBAR ===== */
        nav {
            background: #2c3e50;
            padding: 0 32px;
            display: flex;
            align-items: center;
            height: 56px;
            gap: 4px;
        }
        .nav-brand {
            font-size: 16px;
            font-weight: 700;
            color: #fff;
            margin-right: 16px;
            letter-spacing: .5px;
        }
        nav a {
            color: #bdc3c7;
            text-decoration: none;
            padding: 8px 14px;
            border-radius: 4px;
            font-size: 14px;
            transition: background .2s, color .2s;
        }
        nav a:hover  { background: #3d5a73; color: #fff; }
        nav a.active { background: #2980b9; color: #fff; }

        /* ===== CONTENT ===== */
        .container {
            max-width: 880px;
            margin: 48px auto;
            padding: 0 16px;
            text-align: center;
        }

        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 8px 14px; border-radius: 6px; background: rgba(239, 68, 68, 0.1); color: #ef4444; text-decoration: none; font-size: 13px; font-weight: 600; transition: all 0.2s ease; border: 1px solid transparent; }
        .btn-logout:hover { background: #ef4444; color: white; border-color: #ef4444; }

        .hero {
            background: #fff;
            border-radius: 12px;
            padding: 48px 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,.08);
        }
        .hero h1 { font-size: 28px; color: #2c3e50; margin-bottom: 12px; }
        .hero p  { color: #7f8c8d; font-size: 15px; margin-bottom: 32px; }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 16px;
            margin-top: 32px;
        }
        .card {
            background: #f8f9fa;
            border: 1px solid #e8eaed;
            border-radius: 8px;
            padding: 24px 16px;
            text-decoration: none;
            color: #2c3e50;
            transition: box-shadow .2s, transform .15s;
            display: block;
        }
        .card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,.12);
            transform: translateY(-2px);
        }
        .card .icon { font-size: 32px; margin-bottom: 10px; }
        .card .label { font-size: 14px; font-weight: 600; }
    </style>
</head>
<body>

<nav>
    <span class="nav-brand">🛍️ MyShop</span>
    <a href="${pageContext.request.contextPath}/" class="active">Trang chủ</a>
    <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
    <%-- Thêm các mục menu khác tại đây --%>
    <%-- <a href="${pageContext.request.contextPath}/product">Sản phẩm</a> --%>
    <%-- <a href="${pageContext.request.contextPath}/user">Người dùng</a>   --%>
    <%-- <a href="${pageContext.request.contextPath}/order">Đơn hàng</a>    --%>
</nav>

<div class="container">
    <div class="hero">
        <h1>👋 Chào mừng đến FOOD MANAGE</h1>
        <p>Chọn một chức năng để bắt đầu quản lý.</p>

        <div class="cards">
            <a href="${pageContext.request.contextPath}/cart" class="card">
                <div class="icon">🛒</div>
                <div class="label">Giỏ hàng</div>
            </a>
            <%-- Thêm card cho các module khác --%>
            <%--
            <a href="${pageContext.request.contextPath}/product" class="card">
                <div class="icon">📦</div>
                <div class="label">Sản phẩm</div>
            </a>
            <a href="${pageContext.request.contextPath}/user" class="card">
                <div class="icon">👤</div>
                <div class="label">Người dùng</div>
            </a>
            --%>
        </div>
    </div>
</div>

</body>
</html>

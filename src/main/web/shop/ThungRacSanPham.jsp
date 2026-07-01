<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<c:set var="currentShop" value="${sessionScope.currentShop}" scope="request"/>

<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thùng rác - Sản phẩm</title>
    <style>
        :root{--bg-base:#FFF8F1;--bg-sidebar:#FFFFFF;--bg-panel:#FFFFFF;--bg-input:#FFF3E9;--bg-hover:#FFF1E4;--border:#FBE3CF;--text-main:#3A2A1E;--text-muted:#9C8579;--text-dim:#C2A992;--primary:#FF7A30;--primary-dk:#E8590C;--primary-lt:rgba(255,122,48,.12);--accent:#E63946;--accent-lt:rgba(230,57,70,.10);--success:#2ECC71;--success-lt:rgba(46,204,113,.12);--warning:#FFB703;--warning-lt:rgba(255,183,3,.15);--sh-sm:0 2px 6px rgba(58,42,30,.06);--sh-md:0 8px 20px rgba(58,42,30,.10);}
        *{box-sizing:border-box;margin:0;padding:0;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;}
        a{text-decoration:none;color:inherit;}ul{list-style:none;}
        body{background:var(--bg-base);color:var(--text-muted);display:flex;height:100vh;overflow:hidden;}
        .sidebar{width:260px;background:var(--bg-sidebar);border-right:1px solid var(--border);display:flex;flex-direction:column;flex-shrink:0;}
        .sidebar-brand{padding:22px 24px;display:flex;flex-direction:column;gap:10px;border-bottom:1px solid var(--border);}
        .brand-row{display:flex;align-items:center;gap:12px;}
        .logo-icon{background:linear-gradient(135deg,var(--primary),var(--accent));color:#fff;width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:18px;box-shadow:0 4px 10px rgba(255,122,48,.35);}
        .brand-text{display:flex;flex-direction:column;}
        .brand-title{color:var(--text-main);font-weight:800;font-size:15px;}
        .brand-subtitle{color:var(--primary);font-size:11px;font-weight:600;}
        .hi-owner{font-size:12px;color:var(--text-muted);}
        .hi-owner strong{color:var(--primary-dk);}
        .menu-section{padding:16px 0;overflow-y:auto;flex:1;}
        .menu-title{font-size:11px;text-transform:uppercase;color:var(--text-dim);margin:16px 24px 8px;font-weight:700;letter-spacing:.5px;}
        .menu-item{padding:12px 24px;display:flex;align-items:center;justify-content:space-between;color:var(--text-muted);font-size:13.5px;font-weight:500;transition:all .2s;border-left:3px solid transparent;}
        .menu-item:hover{background:var(--bg-hover);color:var(--primary-dk);transform:translateX(4px);}
        .menu-item.active{background:var(--primary-lt);color:var(--primary-dk);border-left-color:var(--primary);font-weight:700;}
        .menu-item-left{display:flex;align-items:center;gap:12px;}
        .main-content{flex:1;display:flex;flex-direction:column;overflow:hidden;}
        .top-header{height:72px;background:var(--bg-sidebar);border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;padding:0 32px;flex-shrink:0;}
        .top-header h2{color:var(--text-main);font-size:19px;font-weight:800;}
        .header-actions{display:flex;align-items:center;gap:16px;}
        .avatar{width:38px;height:38px;background:linear-gradient(135deg,var(--warning),var(--primary));border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:14px;}
        .btn-logout{display:flex;align-items:center;gap:6px;padding:9px 16px;border-radius:10px;background:var(--accent-lt);color:var(--accent);font-size:13px;font-weight:700;border:1px solid transparent;transition:all .2s;}
        .btn-logout:hover{background:var(--accent);color:#fff;}
        .content-wrapper{padding:32px;overflow-y:auto;flex:1;}
        .alert{padding:13px 18px;border-radius:10px;margin-bottom:20px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;}
        .alert-success{background:var(--success-lt);border:1px solid var(--success);color:#1E8449;}
        .alert-error{background:var(--accent-lt);border:1px solid var(--accent);color:var(--accent);}
        .back-bar{display:flex;align-items:center;gap:12px;margin-bottom:24px;}
        .btn-back{display:inline-flex;align-items:center;gap:7px;padding:9px 18px;border-radius:10px;background:var(--bg-input);border:1px solid var(--border);color:var(--text-muted);font-size:13px;font-weight:700;cursor:pointer;transition:all .2s;}
        .btn-back:hover{background:var(--border);color:var(--text-main);}
        .trash-hint{font-size:13px;color:var(--text-dim);display:flex;align-items:center;gap:6px;}
        .panel{background:var(--bg-panel);border:1px solid var(--border);border-radius:16px;box-shadow:var(--sh-sm);overflow:hidden;}
        .panel-header{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
        .panel-title{color:var(--primary-dk);font-size:13px;font-weight:800;text-transform:uppercase;letter-spacing:.4px;display:flex;align-items:center;gap:8px;}
        .panel-title::before{content:'';width:4px;height:15px;background:var(--accent);border-radius:3px;display:inline-block;}
        .table-wrap{overflow-x:auto;}
        table{width:100%;border-collapse:collapse;text-align:left;}
        th{padding:12px 16px;font-size:11px;color:var(--text-dim);text-transform:uppercase;font-weight:700;border-bottom:2px solid var(--border);white-space:nowrap;}
        td{padding:14px 16px;border-bottom:1px solid var(--border);font-size:13.5px;color:var(--text-main);vertical-align:middle;}
        tr:last-child td{border-bottom:none;}
        tr:hover td{background:var(--bg-hover);}
        .btn{display:inline-flex;align-items:center;gap:7px;padding:8px 16px;border:none;border-radius:10px;font-weight:700;font-size:13px;cursor:pointer;transition:all .2s;}
        .btn:hover{transform:translateY(-1px);}
        .btn-restore{background:var(--success-lt);color:#1E8449;border:1px solid var(--success);}
        .btn-restore:hover{background:var(--success);color:#fff;}
        .inline-form{display:inline;}
        .count-chip{background:var(--accent-lt);color:var(--accent);font-size:12px;font-weight:700;padding:3px 10px;border-radius:12px;}
        .empty-state{text-align:center;padding:56px 20px;color:var(--text-dim);}
        .empty-state .empty-icon{font-size:46px;margin-bottom:14px;}
        .empty-state p{font-size:14px;}
        .status-badge{display:inline-flex;align-items:center;gap:5px;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700;}
        .status-deleted{background:var(--accent-lt);color:var(--accent);}
    </style>
</head>
<body>
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-row">
            <div class="logo-icon">🍔</div>
            <div class="brand-text">
                <span class="brand-title">${not empty currentShop.shopName ? currentShop.shopName : 'CỬA HÀNG'}</span>
                <span class="brand-subtitle">SHOP OWNER</span>
            </div>
        </div>
        <div class="hi-owner">👋 Hi, <strong>${sessionScope.account.userName}</strong></div>
    </div>
    <div class="menu-section">
        <div class="menu-title">Tổng quan</div>
        <a href="${pageContext.request.contextPath}/shop" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📊</span> Trang chủ</div>
        </a>
        <div class="menu-title">Sản phẩm</div>
        <a href="${pageContext.request.contextPath}/shop/products" class="menu-item active">
            <div class="menu-item-left"><span style="font-size:16px;">🍽️</span> Quản lý sản phẩm</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/product-types" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📂</span> Quản lý loại sản phẩm</div>
        </a>
        <div class="menu-title">Topping</div>
        <a href="${pageContext.request.contextPath}/shop/toppings" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🧂</span> Quản lý Topping</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🏷️</span> Quản lý loại Topping</div>
        </a>
        <div class="menu-title">Đơn hàng</div>
        <a href="${pageContext.request.contextPath}/shop/pos" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🧾</span> Bấm Bill</div>
        </a>
        <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">📋</span> Quản lý hóa đơn</div>
        </a>
        <div class="menu-title">Cửa hàng</div>
        <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item">
            <div class="menu-item-left"><span style="font-size:16px;">🏪</span> Thông tin cửa hàng</div>
        </a>
    </div>
</aside>

<main class="main-content">
    <header class="top-header">
        <h2>🗑️ THÙNG RÁC — SẢN PHẨM</h2>
        <div class="header-actions">
            <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content-wrapper">

        <c:if test="${param.success eq 'restore'}">
            <div class="alert alert-success">✅ Khôi phục sản phẩm thành công!</div>
        </c:if>
        <c:if test="${not empty loi}">
            <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <div class="back-bar">
            <a href="${pageContext.request.contextPath}/shop/products" class="btn-back">← Quay lại danh sách</a>
            <span class="trash-hint">🗑️ Các sản phẩm đã xóa — bấm <strong>Khôi phục</strong> để đưa trở lại danh sách.</span>
        </div>

        <div class="panel">
            <div class="panel-header">
                <span class="panel-title">Sản phẩm đã xóa</span>
                <span class="count-chip">${fn:length(deletedProducts)} mục</span>
            </div>
            <div class="table-wrap">
                <c:choose>
                    <c:when test="${empty deletedProducts}">
                        <div class="empty-state">
                            <div class="empty-icon">🗑️</div>
                            <p>Thùng rác trống — không có sản phẩm nào đã xóa.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Trạng thái</th>
                                    <th style="text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${deletedProducts}" varStatus="vs">
                                    <tr>
                                        <td>${vs.index + 1}</td>
                                        <td><strong>${p.productName}</strong></td>
                                        <td><span class="status-badge status-deleted">🗑️ Đã xóa</span></td>
                                        <td style="text-align:center;">
                                            <form method="post" action="${pageContext.request.contextPath}/shop/products" class="inline-form">
                                                <input type="hidden" name="action" value="restore"/>
                                                <input type="hidden" name="id" value="${p.id}"/>
                                                <button type="submit" class="btn btn-restore">♻️ Khôi phục</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div>
</main>
</body>
</html>

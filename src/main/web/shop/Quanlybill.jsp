<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="currentShop" value="${sessionScope.currentShop}" scope="request"/>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SHOP (roleId = 2) --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hóa đơn - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
    <style>
        :root {
            --bg-base:      #FFF8F1;
            --bg-sidebar:   #FFFFFF;
            --bg-panel:     #FFFFFF;
            --bg-input:     #FFF3E9;
            --bg-hover:     #FFF1E4;
            --border:       #FBE3CF;

            --text-main:    #3A2A1E;
            --text-muted:   #9C8579;
            --text-dim:     #C2A992;

            --primary:      #FF7A30;
            --primary-dk:   #E8590C;
            --primary-lt:   rgba(255,122,48,.12);

            --accent:       #E63946;
            --accent-lt:    rgba(230,57,70,.10);

            --success:      #2ECC71;
            --success-lt:   rgba(46,204,113,.12);

            --warning:      #FFB703;
            --warning-lt:   rgba(255,183,3,.15);

            --info:         #3B82F6;
            --info-lt:      rgba(59,130,246,.12);

            --sh-sm:  0 2px 6px rgba(58,42,30,.06);
            --sh-md:  0 8px 20px rgba(58,42,30,.10);
        }

        *{box-sizing:border-box;margin:0;padding:0;font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif;}
        a{text-decoration:none;color:inherit;}
        ul{list-style:none;}
        body{background:var(--bg-base);color:var(--text-muted);display:flex;height:100vh;overflow:hidden;}

        /* ── SIDEBAR ── */
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
        .menu-item{padding:12px 24px;display:flex;align-items:center;justify-content:space-between;color:var(--text-muted);font-size:13.5px;font-weight:500;transition:all .2s cubic-bezier(.4,0,.2,1);border-left:3px solid transparent;}
        .menu-item:hover{background:var(--bg-hover);color:var(--primary-dk);transform:translateX(4px);}
        .menu-item.active{background:var(--primary-lt);color:var(--primary-dk);border-left-color:var(--primary);font-weight:700;}
        .menu-item-left{display:flex;align-items:center;gap:12px;}

        /* ── MAIN ── */
        .main-content{flex:1;display:flex;flex-direction:column;overflow:hidden;}
        .top-header{height:72px;background:var(--bg-sidebar);border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;padding:0 32px;flex-shrink:0;}
        .top-header h2{color:var(--text-main);font-size:19px;font-weight:800;}
        .header-actions{display:flex;align-items:center;gap:16px;}
        .avatar{width:38px;height:38px;background:linear-gradient(135deg,var(--warning),var(--primary));border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:14px;}
        .btn-logout{display:flex;align-items:center;gap:6px;padding:9px 16px;border-radius:10px;background:var(--accent-lt);color:var(--accent);font-size:13px;font-weight:700;border:1px solid transparent;transition:all .2s;}
        .btn-logout:hover{background:var(--accent);color:#fff;transform:translateY(-1px);}

        .content-wrapper{padding:32px;overflow-y:auto;flex:1;}

        /* ── ALERTS ── */
        .alert{padding:13px 18px;border-radius:10px;margin-bottom:20px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;}
        .alert-success{background:var(--success-lt);border:1px solid var(--success);color:#1E8449;}
        .alert-error{background:var(--accent-lt);border:1px solid var(--accent);color:var(--accent);}

        /* ── PANEL & TABLE ── */
        .panel{background:var(--bg-panel);border:1px solid var(--border);border-radius:16px;box-shadow:var(--sh-sm);overflow:hidden;}
        .panel-header{padding:18px 22px;border-bottom:1px solid var(--border);}
        .panel-title{color:var(--primary-dk);font-size:13px;font-weight:800;text-transform:uppercase;letter-spacing:.4px;display:flex;align-items:center;gap:8px;}
        .panel-title::before{content:'';width:4px;height:15px;background:var(--primary);border-radius:3px;display:inline-block;}
        .panel-body{padding:0;}

        table{width:100%;border-collapse:collapse;text-align:left;}
        th{padding:12px 22px;font-size:11px;color:var(--text-dim);text-transform:uppercase;font-weight:700;border-bottom:1px solid var(--border);}
        td{padding:14px 22px;border-bottom:1px solid var(--border);font-size:13.5px;color:var(--text-main);vertical-align:middle;}
        tr:last-child td{border-bottom:none;}
        tr:hover td{background:var(--bg-hover);}

        .status-badge{display:inline-flex;align-items:center;gap:5px;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700;text-transform:uppercase;}
        .status-badge.pending{background:var(--warning-lt);color:#B07700;}
        .status-badge.done{background:var(--success-lt);color:#1E8449;}
        .status-badge.cancel{background:var(--accent-lt);color:var(--accent);}
        .status-badge.other{background:var(--info-lt);color:var(--info);}

        .btn{display:inline-flex;align-items:center;gap:7px;padding:8px 16px;border:none;border-radius:10px;font-weight:700;font-size:12.5px;cursor:pointer;transition:all .2s cubic-bezier(.4,0,.2,1);}
        .btn:hover{transform:translateY(-2px);}
        .btn-primary{background:var(--primary);color:#fff;box-shadow:0 4px 12px rgba(255,122,48,.25);}
        .btn-primary:hover{background:var(--primary-dk);}

        .empty-row{text-align:center;padding:48px 10px;color:var(--text-dim);font-size:13.5px;}

        .filter-bar{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:18px;align-items:center;}
        .filter-bar input[type="text"],.filter-bar input[type="date"],.filter-bar select{
            padding:9px 14px;border:1px solid var(--border);border-radius:10px;background:var(--bg-input);
            color:var(--text-main);font-size:13px;outline:none;
        }
        .filter-bar input[type="text"]{width:220px;}
        .filter-bar button{padding:9px 18px;border:none;border-radius:10px;background:var(--primary);color:#fff;font-weight:700;font-size:13px;cursor:pointer;}
        .filter-bar a.clear{font-size:12.5px;color:var(--text-dim);font-weight:600;}

        .status-badge.unpaid{background:var(--accent-lt);color:var(--accent);}
        .status-badge.paid{background:var(--success-lt);color:#1E8449;}
        .status-badge.pendingpay{background:var(--warning-lt);color:#B07700;}
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
    <a href="${pageContext.request.contextPath}/shop/products" class="menu-item">
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
    <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item active">
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
        <h2>🧾 HÓA ĐƠN / ĐƠN HÀNG CỦA SHOP</h2>
        <div class="header-actions">
            <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content-wrapper">

        <c:if test="${not empty loi}">
            <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
        </c:if>
        <c:if test="${param.error eq 'not_found'}">
            <div class="alert alert-error">⚠️ Không tìm thấy đơn hàng hoặc đơn không thuộc shop của bạn!</div>
        </c:if>

        <form class="filter-bar" method="get" action="${pageContext.request.contextPath}/shop/bills">
            <input type="text" name="q" placeholder="🔍 Tìm theo mã đơn / tên khách / SĐT..." value="${fn:escapeXml(q)}">
            <input type="date" name="date" value="${dateFilter}">
            <select name="status">
                <option value="" ${empty statusFilter ? 'selected' : ''}>Tất cả</option>
                <option value="UNPAID" ${statusFilter == 'UNPAID' ? 'selected' : ''}>Chưa thanh toán</option>
                <option value="PAID" ${statusFilter == 'PAID' ? 'selected' : ''}>Đã thanh toán</option>
                <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>Hủy</option>
            </select>
            <select name="method">
                <option value="" ${empty methodFilter ? 'selected' : ''}>Tất cả hình thức</option>
                <option value="COD" ${methodFilter == 'COD' ? 'selected' : ''}>💵 Tiền mặt</option>
                <option value="BANK" ${methodFilter == 'BANK' ? 'selected' : ''}>📱 QR chuyển khoản</option>
                <option value="PAYOS" ${methodFilter == 'PAYOS' ? 'selected' : ''}>🏦 PayOS</option>
            </select>
            <button type="submit">Lọc</button>
            <a href="${pageContext.request.contextPath}/shop/bills" class="clear">✕ Xóa lọc</a>
        </form>

        <section class="panel">
            <div class="panel-header">
                <div class="panel-title">📋 Danh sách đơn hàng</div>
            </div>
            <div class="panel-body">
                <c:choose>
                    <c:when test="${empty orderList}">
                        <div class="empty-row">🧾 Không có đơn hàng nào khớp với bộ lọc.</div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                            <tr>
                                <th>Mã đơn</th>
                                <th>Người nhận</th>
                                <th>Địa chỉ</th>
                                <th>Tổng tiền</th>
                                <th>Hình thức</th>
                                <th>Thanh toán</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="o" items="${orderList}">
                                <tr>
                                    <td>#${o.id}</td>
                                    <td>
                                        <strong><c:out value="${o.receiverName}"/></strong><br>
                                        <c:out value="${o.receiverPhone}"/>
                                    </td>
                                    <td><c:out value="${o.shippingAddress}"/></td>
                                    <td><fmt:formatNumber value="${o.totalPrice}" type="number"/> đ</td>
                                    <td>
                                        <c:set var="pm" value="${fn:toUpperCase(o.paymentMethod)}"/>
                                        <c:choose>
                                            <c:when test="${pm == 'BANK'}">📱 QR chuyển khoản</c:when>
                                            <c:when test="${pm == 'PAYOS'}">🏦 PayOS</c:when>
                                            <c:otherwise>💵 Tiền mặt</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="pst" value="${fn:toUpperCase(o.paymentStatus)}"/>
                                        <span class="status-badge ${pst == 'PAID' ? 'paid' : (pst == 'PENDING' ? 'pendingpay' : 'unpaid')}">
                                            <c:choose>
                                                <c:when test="${pst == 'PAID'}">✅ Đã thanh toán</c:when>
                                                <c:when test="${pst == 'PENDING'}">⏳ Đang chờ</c:when>
                                                <c:otherwise>⛔ Chưa thanh toán</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>${o.createdAt}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/shop/bills?action=view&as=modal&id=${o.id}" class="btn btn-primary">🧾 Xem hóa đơn</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>
</main>

<%@ include file="_invoiceModal.jspf" %>

</body>
</html>

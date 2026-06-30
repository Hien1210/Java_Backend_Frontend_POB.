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
    <title>Hóa đơn #${bill.order.id} - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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

        .content-wrapper{padding:32px;overflow-y:auto;flex:1;display:flex;justify-content:center;}

        /* ── BILL ── */
        .bill-wrap{max-width:680px;width:100%;}
        .bill{background:var(--bg-panel);border:1px solid var(--border);border-radius:16px;box-shadow:var(--sh-sm);padding:28px 32px;}
        .bill-header{text-align:center;margin-bottom:18px;border-bottom:2px dashed var(--border);padding-bottom:14px;}
        .bill-header h2{color:var(--primary-dk);font-size:20px;font-weight:800;}
        .bill-header .order-id{color:var(--text-dim);font-size:13px;margin-top:4px;}

        .info-row{display:flex;justify-content:space-between;font-size:14px;margin-bottom:6px;}
        .info-row span:first-child{color:var(--text-dim);}
        .info-row span:last-child{color:var(--text-main);font-weight:600;}

        table{width:100%;border-collapse:collapse;margin:16px 0;}
        th,td{padding:10px 8px;text-align:left;font-size:13.5px;border-bottom:1px solid var(--border);color:var(--text-main);}
        th{color:var(--text-dim);text-transform:uppercase;font-size:11px;font-weight:700;}
        th.num,td.num{text-align:right;}

        .totals{text-align:right;font-size:14px;}
        .totals .line{margin-bottom:6px;color:var(--text-muted);}
        .totals .grand{font-size:18px;font-weight:800;color:var(--primary-dk);margin-top:6px;}

        .status-badge{display:inline-flex;align-items:center;gap:5px;padding:4px 14px;border-radius:20px;font-size:12px;font-weight:700;background:var(--warning-lt);color:#B07700;}
        .status-badge.unpaid{background:var(--accent-lt);color:var(--accent);}
        .status-badge.paid{background:var(--success-lt);color:#1E8449;}
        .status-badge.pendingpay{background:var(--warning-lt);color:#B07700;}

        .actions{text-align:center;margin-top:18px;display:flex;gap:10px;justify-content:center;}
        .btn{display:inline-flex;align-items:center;gap:7px;padding:10px 20px;border:none;border-radius:10px;font-weight:700;font-size:13px;cursor:pointer;transition:all .2s cubic-bezier(.4,0,.2,1);}
        .btn:hover{transform:translateY(-2px);}
        .btn-primary{background:var(--primary);color:#fff;box-shadow:0 4px 12px rgba(255,122,48,.25);}
        .btn-primary:hover{background:var(--primary-dk);}
        .btn-secondary{background:var(--bg-input);border:1px solid var(--border);color:var(--text-muted);}

        @media print {
            .sidebar, .top-header, .actions { display: none; }
            .content-wrapper { padding: 0; }
        }
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
        <h2>🧾 HÓA ĐƠN #${bill.order.id}</h2>
        <div class="header-actions">
            <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content-wrapper">
        <div class="bill-wrap">
            <div class="bill">
                <div class="bill-header">
                    <h2>🧾 HÓA ĐƠN BÁN HÀNG</h2>
                    <div class="order-id">Mã đơn hàng: #${bill.order.id} — <c:out value="${bill.shopName}"/></div>
                </div>

                <div class="info-row"><span>Người nhận</span><span><c:out value="${bill.order.receiverName}"/></span></div>
                <div class="info-row"><span>Số điện thoại</span><span><c:out value="${bill.order.receiverPhone}"/></span></div>
                <div class="info-row"><span>Địa chỉ giao hàng</span><span><c:out value="${bill.order.shippingAddress}"/></span></div>
                <div class="info-row"><span>Phương thức thanh toán</span><span>
                    <c:set var="pm" value="${fn:toUpperCase(bill.order.paymentMethod)}"/>
                    <c:choose>
                        <c:when test="${pm == 'BANK'}">📱 QR chuyển khoản</c:when>
                        <c:when test="${pm == 'PAYOS'}">🏦 PayOS</c:when>
                        <c:otherwise>💵 Tiền mặt</c:otherwise>
                    </c:choose>
                </span></div>
                <div class="info-row"><span>Thanh toán</span><span>
                    <c:set var="pst" value="${fn:toUpperCase(bill.order.paymentStatus)}"/>
                    <span class="status-badge ${pst == 'PAID' ? 'paid' : (pst == 'PENDING' ? 'pendingpay' : 'unpaid')}">
                        <c:choose>
                            <c:when test="${pst == 'PAID'}">✅ Đã thanh toán</c:when>
                            <c:when test="${pst == 'PENDING'}">⏳ Đang chờ</c:when>
                            <c:otherwise>⛔ Chưa thanh toán</c:otherwise>
                        </c:choose>
                    </span>
                </span></div>
                <div class="info-row"><span>Trạng thái</span><span>
                    <c:set var="st2" value="${fn:toUpperCase(bill.order.staTus)}"/>
                    <c:set var="pst3" value="${fn:toUpperCase(bill.order.paymentStatus)}"/>
                    <c:choose>
                        <c:when test="${st2 == 'CANCELLED'}">
                            <span class="status-badge unpaid">🚫 Đã hủy</span>
                        </c:when>
                        <c:when test="${pst3 == 'UNPAID'}">
                            <span class="status-badge unpaid">❌ Thất bại</span>
                        </c:when>
                        <c:when test="${pst3 == 'PENDING'}">
                            <span class="status-badge pendingpay">⏳ Chờ đợi</span>
                        </c:when>
                        <c:when test="${st2 == 'DONE'}">
                            <span class="status-badge paid">✅ Hoàn thành</span>
                        </c:when>
                        <c:when test="${st2 == 'SHIPPING'}">
                            <span class="status-badge">🚚 Đang giao</span>
                        </c:when>
                        <c:when test="${st2 == 'PENDING'}">
                            <span class="status-badge pendingpay">⏳ Đang xử lý</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge"><c:out value="${bill.order.staTus}"/></span>
                        </c:otherwise>
                    </c:choose>
                </span></div>
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
                                <td>
                                    <c:out value="${line.productName}"/>
                                    <c:if test="${not empty line.toppings}">
                                        <div style="font-size:11px;color:var(--text-dim);margin-top:3px;">
                                            <c:forEach items="${line.toppings}" var="top">
                                                + <c:out value="${top.toppingName}"/> x${top.quantity}<br>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </td>
                                <td><c:out value="${line.sizeName}"/></td>
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

            <div class="actions">
                <a href="#" class="btn btn-primary" onclick="window.print(); return false;">🖨️ In hóa đơn</a>
                <a href="${pageContext.request.contextPath}/shop/bills" class="btn btn-secondary">← Quay lại danh sách</a>
            </div>
        </div>
    </div>
</main>

</body>
</html>

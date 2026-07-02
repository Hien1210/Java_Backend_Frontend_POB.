<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.id} - POB Shipper</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base:#0f172a;--bg-card:#1e293b;--bg-input:#0f172a;
            --text-main:#f8fafc;--text-muted:#94a3b8;--border-color:#334155;
            --topbar-bg:rgba(30,41,59,0.8);--shadow:0 4px 6px -1px rgb(0 0 0/.2);
        }
        :root[data-theme="light"] {
            --bg-base:#f4f7f5;--bg-card:#ffffff;--bg-input:#f8fafc;
            --text-main:#1e293b;--text-muted:#64748b;--border-color:#e2e8f0;
            --topbar-bg:rgba(255,255,255,0.85);--shadow:0 4px 12px rgba(0,0,0,.03);
        }
        :root {
            --primary:#4CAF50;--primary-hover:#43a047;--primary-light:rgba(76,175,80,.12);
            --secondary:#FF9800;--secondary-hover:#f57c00;--secondary-light:rgba(255,152,0,.12);
            --danger:#ef4444;--font-family:system-ui,-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;
        }
        *{box-sizing:border-box;margin:0;padding:0;font-family:var(--font-family);transition:background-color .25s,border-color .25s}
        body{background-color:var(--bg-base);color:var(--text-main);display:flex;height:100vh;overflow:hidden}
        a{text-decoration:none;color:inherit}
        .sidebar{width:260px;background-color:var(--bg-card);border-right:1px solid var(--border-color);display:flex;flex-direction:column;flex-shrink:0;z-index:10}
        .brand{padding:24px;display:flex;align-items:center;gap:12px;border-bottom:1px solid var(--border-color)}
        .logo{background:linear-gradient(135deg,var(--primary),#2e7d32);color:#fff;width:38px;height:38px;border-radius:10px;display:flex;align-items:center;justify-content:center;font-weight:800;font-size:18px}
        .brand-title{font-weight:700;font-size:16px;letter-spacing:.5px}
        .menu{padding:20px 12px;flex:1}
        .menu-item{padding:14px 16px;display:flex;align-items:center;gap:12px;color:var(--text-muted);font-size:14px;font-weight:600;border-radius:8px;margin-bottom:6px}
        .menu-item:hover{background-color:var(--bg-input);color:var(--text-main);transform:translateX(4px)}
        .menu-item.active{background-color:var(--primary-light);color:var(--primary)}
        .online-toggle-wrap{padding:16px 12px;border-top:1px solid var(--border-color)}
        .online-toggle-btn{width:100%;padding:12px 16px;border-radius:10px;border:none;cursor:pointer;display:flex;align-items:center;gap:10px;font-size:13px;font-weight:700;transition:all .2s}
        .online-toggle-btn.is-online{background:var(--primary-light);color:var(--primary);border:1.5px solid var(--primary)}
        .online-toggle-btn.is-offline{background:rgba(239,68,68,.08);color:#ef4444;border:1.5px solid rgba(239,68,68,.3)}
        .toggle-dot{width:10px;height:10px;border-radius:50%;flex-shrink:0}
        .toggle-dot.online{background:var(--primary);animation:pulse-green 1.5s infinite}
        .toggle-dot.offline{background:#ef4444}
        @keyframes pulse-green{0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,.25)}50%{box-shadow:0 0 0 6px rgba(76,175,80,.1)}}
        .main{flex:1;display:flex;flex-direction:column;overflow:hidden}
        .topbar{background-color:var(--topbar-bg);backdrop-filter:blur(10px);padding:16px 32px;display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border-color)}
        .topbar h1{font-size:18px;font-weight:700;display:flex;align-items:center;gap:8px}
        .topbar-right{display:flex;align-items:center;gap:16px}
        .theme-toggle{background:var(--bg-input);border:1px solid var(--border-color);width:38px;height:38px;border-radius:8px;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px}
        .avatar-circle{background:var(--primary);color:white;width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700}
        .btn-logout{padding:8px 16px;border-radius:8px;background:rgba(239,68,68,.1);color:var(--danger);font-size:13px;font-weight:600}
        .btn-logout:hover{background:var(--danger);color:white}
        .content{padding:24px 32px;overflow-y:auto;flex:1;display:flex;flex-direction:column;gap:20px;animation:fadeIn .3s ease-out}
        @keyframes fadeIn{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
        .card{background:var(--bg-card);border:1px solid var(--border-color);border-radius:14px;padding:20px;box-shadow:var(--shadow)}
        .card-title{font-size:14px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.5px;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border-color)}
        .info-row{display:flex;justify-content:space-between;align-items:flex-start;padding:8px 0;border-bottom:1px dashed var(--border-color);font-size:14px}
        .info-row:last-child{border-bottom:none}
        .info-label{color:var(--text-muted);font-weight:600;font-size:12px;text-transform:uppercase;min-width:140px}
        .info-value{font-weight:600;text-align:right}
        /* Route timeline */
        .route-timeline{display:flex;flex-direction:column;gap:0}
        .route-point{display:flex;gap:14px;padding:14px 0}
        .route-point:not(:last-child){border-bottom:1px dashed var(--border-color)}
        .route-dot{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
        .dot-shop{background:var(--secondary-light);color:var(--secondary)}
        .dot-customer{background:var(--primary-light);color:var(--primary)}
        .route-info-label{font-size:11px;font-weight:700;text-transform:uppercase;color:var(--text-muted);margin-bottom:2px}
        .route-info-name{font-weight:700;font-size:14px}
        .route-info-sub{font-size:12px;color:var(--text-muted);margin-top:2px}
        /* Item table */
        .item-list{display:flex;flex-direction:column;gap:10px}
        .item-row{background:var(--bg-input);border-radius:10px;padding:14px}
        .item-name{font-weight:700;font-size:14px}
        .item-size{font-size:12px;color:var(--text-muted);margin-top:2px}
        .item-topping-list{margin-top:6px;padding-left:12px;border-left:2px solid var(--border-color)}
        .item-topping{font-size:12px;color:var(--text-muted);padding:2px 0}
        .item-price-row{display:flex;justify-content:space-between;align-items:center;margin-top:8px}
        .item-qty{font-size:13px;color:var(--text-muted)}
        .item-subtotal{font-weight:700;color:var(--primary)}
        /* Tổng tiền */
        .total-row{display:flex;justify-content:space-between;align-items:center;padding:12px 0;font-size:15px;font-weight:700;border-top:2px solid var(--border-color);margin-top:8px}
        .total-amount{font-size:20px;font-weight:800;color:var(--primary)}
        /* Badge */
        .badge{padding:4px 10px;border-radius:6px;font-size:11px;font-weight:700;text-transform:uppercase}
        .badge-pickup{background:var(--secondary-light);color:var(--secondary)}
        .badge-shipping{background:var(--primary-light);color:var(--primary)}
        .badge-done{background:rgba(34,197,94,.1);color:#16a34a}
        /* Nút hành động */
        .action-bar{display:flex;gap:10px;justify-content:flex-end}
        .btn-back{padding:10px 20px;border-radius:8px;border:1px solid var(--border-color);background:transparent;color:var(--text-main);font-weight:700;font-size:13px;cursor:pointer}
        .btn-back:hover{background:var(--bg-input)}
        .btn-primary{padding:10px 20px;border-radius:8px;border:none;background:var(--primary);color:white;font-weight:700;font-size:13px;cursor:pointer}
        .btn-primary:hover{background:var(--primary-hover)}
        .btn-warning{padding:10px 20px;border-radius:8px;border:none;background:var(--secondary);color:white;font-weight:700;font-size:13px;cursor:pointer}
        .btn-warning:hover{background:var(--secondary-hover)}
        @media(max-width:768px){
            body{flex-direction:column}
            .sidebar{width:100%;height:auto;border-right:none;border-bottom:1px solid var(--border-color)}
            .menu{display:flex;overflow-x:auto;padding:10px}
            .menu-item{margin-bottom:0;white-space:nowrap}
            .content{padding:16px}
        }
    </style>
</head>
<body>

<aside class="sidebar">
    <div class="brand">
        <div class="logo">🛵</div>
        <div class="brand-text">
            <span class="brand-title">POB SHIPPER</span>
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <div style="font-size:10px;color:var(--primary);font-weight:bold;">● ĐANG HOẠT ĐỘNG</div>
                </c:when>
                <c:otherwise>
                    <div style="font-size:10px;color:#ef4444;font-weight:bold;">● NGOẠI TUYẾN</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <ul class="menu">
        <a href="${pageContext.request.contextPath}/shipper/donhang">
            <li class="menu-item active"><span>📋 Đơn hàng nhận</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao">
            <li class="menu-item"><span>🔔 Thông báo</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/profile">
            <li class="menu-item"><span>👤 Hồ sơ tài xế</span></li>
        </a>
    </ul>
    <div class="online-toggle-wrap">
        <form action="${pageContext.request.contextPath}/shipper/status" method="post">
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <button type="submit" class="online-toggle-btn is-online"
                            onclick="return confirm('Tắt chế độ Online? Bạn sẽ không nhận đơn mới.')">
                        <span class="toggle-dot online"></span>Đang Online — Nhấn để Offline
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="online-toggle-btn is-offline">
                        <span class="toggle-dot offline"></span>Đang Offline — Nhấn để Online
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <h1>📦 Chi tiết đơn hàng #${order.id}</h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-circle">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.fullName}">${fn:toUpperCase(fn:substring(sessionScope.account.fullName,0,1))}</c:when>
                    <c:otherwise>S</c:otherwise>
                </c:choose>
            </div>
            <span style="font-size:13px;font-weight:600;">${sessionScope.account.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
        </div>
    </header>

    <div class="content">

        <%-- Lộ trình giao hàng --%>
        <div class="card">
            <div class="card-title">🗺️ Lộ trình giao hàng</div>
            <div class="route-timeline">
                <div class="route-point">
                    <div class="route-dot dot-shop">🏪</div>
                    <div>
                        <div class="route-info-label">Lấy hàng tại cửa hàng</div>
                        <div class="route-info-name">${bill.shopName}</div>
                        <c:if test="${not empty order.shopId}">
                            <div class="route-info-sub">Shop ID: ${order.shopId}</div>
                        </c:if>
                    </div>
                </div>
                <div class="route-point">
                    <div class="route-dot dot-customer">🏠</div>
                    <div>
                        <div class="route-info-label">Giao tới khách hàng</div>
                        <div class="route-info-name">${order.receiverName}</div>
                        <div class="route-info-sub">📍 ${order.shippingAddress}</div>
                        <div class="route-info-sub">📞 ${order.receiverPhone}</div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Danh sách món hàng --%>
        <div class="card">
            <div class="card-title">🛍️ Danh sách món hàng</div>
            <div class="item-list">
                <c:forEach var="line" items="${bill.lines}">
                    <div class="item-row">
                        <div class="item-name">${line.productName}</div>
                        <div class="item-size">Size: ${line.sizeName}</div>
                        <c:if test="${not empty line.toppings}">
                            <div class="item-topping-list">
                                <c:forEach var="tp" items="${line.toppings}">
                                    <div class="item-topping">
                                        + ${tp.toppingName}
                                        <c:if test="${tp.quantity > 1}"> × ${tp.quantity}</c:if>
                                        (<fmt:formatNumber value="${tp.price}" type="number" maxFractionDigits="0"/>đ)
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                        <div class="item-price-row">
                            <span class="item-qty">SL: ${line.quantity} ×
                                <fmt:formatNumber value="${line.unitPrice}" type="number" maxFractionDigits="0"/>đ</span>
                            <span class="item-subtotal">
                                <fmt:formatNumber value="${line.lineTotal}" type="number" maxFractionDigits="0"/>đ
                            </span>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty bill.lines}">
                    <div style="text-align:center;padding:20px;color:var(--text-muted);">
                        Không có dữ liệu chi tiết món hàng.
                    </div>
                </c:if>

                <div class="total-row">
                    <span>Tổng cộng</span>
                    <span class="total-amount">
                        <fmt:formatNumber value="${order.totalPrice}" type="number" maxFractionDigits="0"/>đ
                    </span>
                </div>
            </div>
        </div>

        <%-- Thông tin thanh toán & trạng thái --%>
        <div class="card">
            <div class="card-title">💳 Thông tin thanh toán</div>
            <div class="info-row">
                <span class="info-label">Trạng thái đơn</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${order.staTus == 'READY_FOR_PICKUP'}">
                            <span class="badge badge-pickup">📦 Chờ lấy hàng</span>
                        </c:when>
                        <c:when test="${order.staTus == 'SHIPPING'}">
                            <span class="badge badge-shipping">🛵 Đang giao</span>
                        </c:when>
                        <c:when test="${order.staTus == 'DONE'}">
                            <span class="badge badge-done">✅ Đã giao</span>
                        </c:when>
                        <c:otherwise><span class="badge">${order.staTus}</span></c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Hình thức TT</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${order.paymentMethod == 'PAYOS'}">🏦 PayOS</c:when>
                        <c:when test="${order.paymentMethod == 'BANK'}">📱 QR Chuyển khoản</c:when>
                        <c:otherwise>💵 Tiền mặt (COD)</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Phí giao hàng</span>
                <span class="info-value">
                    <c:choose>
                        <c:when test="${order.deliveryFee != null}">
                            <fmt:formatNumber value="${order.deliveryFee}" type="number" maxFractionDigits="0"/>đ
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <div class="info-row">
                <span class="info-label">Thời gian đặt</span>
                <span class="info-value">${order.createdAt}</span>
            </div>
        </div>

        <%-- Nút hành động --%>
        <div class="action-bar">
            <a href="${pageContext.request.contextPath}/shipper/donhang">
                <button class="btn-back">← Quay lại danh sách</button>
            </a>

            <c:if test="${order.staTus == 'READY_FOR_PICKUP'}">
                <form action="${pageContext.request.contextPath}/shipper/donhang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <input type="hidden" name="action" value="updateStatusToShipping">
                    <button type="submit" class="btn-warning">📦 Xác nhận đã lấy hàng</button>
                </form>
            </c:if>
            <c:if test="${order.staTus == 'SHIPPING'}">
                <form action="${pageContext.request.contextPath}/shipper/donhang" method="post" style="display:inline;">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <input type="hidden" name="action" value="updateStatusToDone">
                    <button type="submit" class="btn-primary"
                            onclick="return confirm('Xác nhận đơn hàng đã giao thành công?')">
                        🎉 Hoàn thành giao đơn
                    </button>
                </form>
            </c:if>
        </div>

    </div>
</main>

<script>
    const html = document.documentElement;
    html.setAttribute('data-theme', localStorage.getItem('shipper-theme') || 'light');
    document.getElementById('themeToggleBtn').addEventListener('click', () => {
        const t = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', t);
        localStorage.setItem('shipper-theme', t);
    });
</script>
</body>
</html>

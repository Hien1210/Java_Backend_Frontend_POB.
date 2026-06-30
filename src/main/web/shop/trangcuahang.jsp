<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SHOP (roleId = 2) --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 2}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ cửa hàng</title>
    <style>
        /* ================= BIẾN MÀU (F&B THEME) ================= */
        :root {
            --bg-base: #FFF8F1;
            --bg-sidebar: #FFFFFF;
            --bg-panel: #FFFFFF;
            --bg-input: #FFF3E9;
            --bg-hover: #FFF1E4;
            --border-color: #FBE3CF;

            --text-main: #3A2A1E;
            --text-muted: #9C8579;
            --text-dim: #C2A992;

            --primary: #FF7A30;
            --primary-dark: #E8590C;
            --primary-light: rgba(255, 122, 48, 0.12);

            --accent: #E63946;
            --accent-light: rgba(230, 57, 70, 0.1);

            --success: #2ECC71;
            --success-light: rgba(46, 204, 113, 0.12);

            --warning: #FFB703;
            --warning-light: rgba(255, 183, 3, 0.15);

            --shadow-sm: 0 2px 6px rgba(58, 42, 30, 0.06);
            --shadow-md: 0 8px 20px rgba(58, 42, 30, 0.10);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }

        /* ================= SIDEBAR ================= */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; }
        .sidebar-brand { padding: 22px 24px; display: flex; flex-direction: column; gap: 10px; border-bottom: 1px solid var(--border-color); }
        .brand-row { display: flex; align-items: center; gap: 12px; }
        .logo-icon { background: linear-gradient(135deg, var(--primary), var(--accent)); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(255, 122, 48, 0.35); }
        .brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--text-main); font-weight: 800; font-size: 15px; }
        .brand-subtitle { color: var(--primary); font-size: 11px; font-weight: 600; }
        .hi-owner { font-size: 12px; color: var(--text-muted); padding-left: 2px; }
        .hi-owner strong { color: var(--primary-dark); }

        .menu-section { padding: 16px 0; overflow-y: auto; flex: 1; }
        .menu-title { font-size: 11px; text-transform: uppercase; color: var(--text-dim); margin: 16px 24px 8px; font-weight: 700; letter-spacing: 0.5px; }
        .menu-item { padding: 12px 24px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 13.5px; font-weight: 500; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-left: 3px solid transparent; }
        .menu-item:hover { background-color: var(--bg-hover); color: var(--primary-dark); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary-dark); border-left-color: var(--primary); font-weight: 700; }
        .menu-item-left { display: flex; align-items: center; gap: 12px; }
        .badge-count { font-size: 10px; padding: 3px 9px; border-radius: 12px; background: var(--accent); color: #fff; font-weight: 700; }

        /* ================= MAIN ================= */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .top-header { height: 72px; background-color: var(--bg-sidebar); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; flex-shrink: 0; }
        .top-header h2 { color: var(--text-main); font-size: 19px; font-weight: 800; }
        .header-actions { display: flex; align-items: center; gap: 16px; }
        .search-bar { background-color: var(--bg-input); border: 1px solid var(--border-color); border-radius: 10px; padding: 9px 16px; color: var(--text-main); width: 260px; outline: none; font-size: 13px; }
        .search-bar:focus { border-color: var(--primary); }
        .avatar { width: 38px; height: 38px; background: linear-gradient(135deg, var(--warning), var(--primary)); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 14px; box-shadow: var(--shadow-sm); }
        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 9px 16px; border-radius: 10px; background: var(--accent-light); color: var(--accent); font-size: 13px; font-weight: 700; border: 1px solid transparent; transition: all 0.2s ease; }
        .btn-logout:hover { background: var(--accent); color: white; transform: translateY(-1px); }

        .content-wrapper { padding: 32px; overflow-y: auto; flex: 1; }

        /* Banner chào mừng */
        .welcome-banner { background: linear-gradient(120deg, var(--primary) 0%, var(--accent) 100%); border-radius: 18px; padding: 28px 32px; color: #fff; margin-bottom: 28px; display: flex; align-items: center; justify-content: space-between; box-shadow: var(--shadow-md); }
        .welcome-banner h1 { font-size: 22px; font-weight: 800; margin-bottom: 6px; }
        .welcome-banner p { font-size: 13px; opacity: 0.92; }
        .welcome-emoji { font-size: 46px; }

        /* ================= STAT CARDS ================= */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; padding: 20px; display: flex; flex-direction: column; gap: 8px; transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); box-shadow: var(--shadow-sm); }
        .stat-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-md); }
        .stat-icon { width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; }
        .stat-icon.orange { background: var(--primary-light); }
        .stat-icon.red { background: var(--accent-light); }
        .stat-icon.green { background: var(--success-light); }
        .stat-icon.yellow { background: var(--warning-light); }
        .stat-title { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.3px; }
        .stat-value { font-size: 26px; font-weight: 800; color: var(--text-main); }

        /* ================= PANEL & TABLE ================= */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 14px; padding: 22px; box-shadow: var(--shadow-sm); }
        .panel-title { color: var(--primary-dark); font-size: 14px; font-weight: 800; margin-bottom: 18px; text-transform: uppercase; letter-spacing: 0.4px; display: flex; align-items: center; gap: 8px; }
        .panel-title::before { content: ''; width: 5px; height: 16px; background: var(--primary); border-radius: 3px; display: inline-block; }

        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { padding: 12px 14px; font-size: 11px; color: var(--text-dim); text-transform: uppercase; font-weight: 700; border-bottom: 1px solid var(--border-color); }
        td { padding: 14px; border-bottom: 1px solid var(--border-color); font-size: 13.5px; color: var(--text-main); vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background-color: var(--bg-hover); }

        .status-badge { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .status-badge.pending { background: var(--warning-light); color: #B07700; }
        .status-badge.done { background: var(--success-light); color: #1E8449; }
        .status-badge.cancel { background: var(--accent-light); color: var(--accent); }

        .empty-row { text-align: center; padding: 36px 10px; color: var(--text-dim); font-size: 13.5px; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-row">
                <div class="logo-icon">🍔</div>
                <div class="brand-text">
                    <span class="brand-title">${not empty currentShop.shopName ? currentShop.shopName : 'CỬA HÀNG CỦA TÔI'}</span>
                    <span class="brand-subtitle">SHOP OWNER</span>
                </div>
            </div>
            <div class="hi-owner">👋 Hi, <strong>${sessionScope.account.userName}</strong></div>
        </div>

        <div class="menu-section">
            <div class="menu-title">Tổng quan</div>
            <a href="${pageContext.request.contextPath}/shop" class="menu-item active">
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
            <h2>TRANG CHỦ CỬA HÀNG</h2>
            <div class="header-actions">
                <input type="text" class="search-bar" placeholder="Tìm sản phẩm, đơn hàng...">
                <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName, 0, 2))}</div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
            </div>
        </header>

        <div class="content-wrapper">

            <div class="welcome-banner">
                <div>
                    <h1>Chào mừng quay lại, ${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.userName}! 👋</h1>
                    <p>Đây là tổng quan hoạt động kinh doanh của cửa hàng bạn hôm nay.</p>
                </div>
                <div class="welcome-emoji">🍜</div>
            </div>

            <!-- STAT CARDS: DOANH THU -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon green">💰</div>
                    <span class="stat-title">Doanh thu hôm nay</span>
                    <span class="stat-value"><fmt:formatNumber value="${doanhThuHomNay}" pattern="#,##0"/> đ</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">📅</div>
                    <span class="stat-title">Doanh thu tuần này</span>
                    <span class="stat-value"><fmt:formatNumber value="${doanhThuTuanNay}" pattern="#,##0"/> đ</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon yellow">🗓️</div>
                    <span class="stat-title">Doanh thu tháng này</span>
                    <span class="stat-value"><fmt:formatNumber value="${doanhThuThangNay}" pattern="#,##0"/> đ</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">📦</div>
                    <span class="stat-title">Tổng đơn hàng</span>
                    <span class="stat-value">${tongDon}</span>
                </div>
            </div>

            <!-- STAT CARDS: ĐƠN HÀNG / SẢN PHẨM -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon green">✓</div>
                    <span class="stat-title">Đơn hoàn thành</span>
                    <span class="stat-value">${donHoanThanh}</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">✕</div>
                    <span class="stat-title">Đơn đã hủy</span>
                    <span class="stat-value">${donHuy}</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">🍽️</div>
                    <span class="stat-title">Tổng sản phẩm</span>
                    <span class="stat-value">${tongSanPham}</span>
                </div>
                <div class="stat-card">
                    <div class="stat-icon yellow">🧂</div>
                    <span class="stat-title">Tổng Topping</span>
                    <span class="stat-value">${tongTopping}</span>
                </div>
            </div>

            <!-- BIỂU ĐỒ DOANH THU 7 NGÀY -->
            <div class="panel" style="margin-bottom: 28px;">
                <div class="panel-title">Doanh thu 7 ngày gần đây</div>
                <canvas id="revenueChart" height="90"></canvas>
            </div>

            <!-- TOP SẢN PHẨM BÁN CHẠY -->
            <div class="panel" style="margin-bottom: 28px;">
                <div class="panel-title">Top món bán chạy</div>
                <table>
                    <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Số lượng đã bán</th>
                            <th>Doanh thu</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sp" items="${topSanPhamBanChay}">
                            <tr>
                                <td><c:out value="${sp.productName}"/></td>
                                <td>${sp.soLuongDaBan}</td>
                                <td><fmt:formatNumber value="${sp.doanhThu}" pattern="#,##0"/> đ</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty topSanPhamBanChay}">
                            <tr>
                                <td colspan="3" class="empty-row">
                                    🍽️ Chưa có dữ liệu bán hàng.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- ĐƠN HÀNG GẦN ĐÂY -->
            <div class="panel">
                <div class="panel-title">Đơn hàng gần đây</div>
                <table>
                    <thead>
                        <tr>
                            <th>Mã đơn</th>
                            <th>Khách hàng</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th>Ngày đặt</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${donHangGanDay}">
                            <tr>
                                <td>#<c:out value="${order.id}"/></td>
                                <td><c:out value="${order.receiverName}"/></td>
                                <td><fmt:formatNumber value="${order.totalPrice}" pattern="#,##0"/> đ</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.staTus == 'DONE'}">
                                            <span class="status-badge done">✓ Hoàn thành</span>
                                        </c:when>
                                        <c:when test="${order.staTus == 'CANCELLED'}">
                                            <span class="status-badge cancel">✕ Đã hủy</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge pending">⏳ ${order.staTus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${order.createdAt}"/></td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty donHangGanDay}">
                            <tr>
                                <td colspan="5" class="empty-row">
                                    📦 Chưa có đơn hàng nào gần đây.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('revenueChart');
        const labels = [
            <c:forEach var="d" items="${doanhThu7NgayQua}">'${d.ngay}',</c:forEach>
        ];
        const data = [
            <c:forEach var="d" items="${doanhThu7NgayQua}">${d.doanhThu},</c:forEach>
        ];
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Doanh thu (đ)',
                    data: data,
                    backgroundColor: '#FF7A30',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            }
        });
    </script>
</body>
</html>
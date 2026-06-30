<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Tổng quan hệ thống - Super Admin</title>
    <style>
        /* ================= BIẾN THEME (DARK/LIGHT) ================= */
        :root[data-theme="dark"] {
            --bg-base: #151521;
            --bg-sidebar: #1e1e2d;
            --bg-panel: #1e1e2d;
            --bg-input: #1a1a27;
            --bg-hover: #1b1b29;
            --text-main: #ffffff;
            --text-muted: #a1a5b7;
            --text-dim: #565674;
            --border-color: #2b2b40;
            --topbar-bg: #1a1a27;
        }

        :root[data-theme="light"] {
            --bg-base: #f1f5f9;
            --bg-sidebar: #ffffff;
            --bg-panel: #ffffff;
            --bg-input: #f8fafc;
            --bg-hover: #f1f5f9;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --text-dim: #94a3b8;
            --border-color: #e2e8f0;
            --topbar-bg: #ffffff;
        }

        :root {
            --primary: #20d489;
            --warning: #facc15;
            --danger: #ef4444;
            --info: #3b82f6;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease; }
        body { background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* SIDEBAR */
        .sidebar { width: 250px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; }
        .brand { padding: 20px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: var(--primary); color: #fff; width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: bold; }
        .brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--text-main); font-weight: bold; font-size: 14px; }
        .badge-system { background: rgba(32, 212, 137, 0.1); color: var(--primary); font-size: 10px; padding: 3px 6px; border-radius: 4px; border: 1px solid var(--primary); margin-left: auto; }

        .menu { padding: 15px 0; flex: 1; overflow-y: auto; }
        .menu-title { font-size: 11px; color: var(--text-dim); font-weight: bold; margin: 15px 20px 10px; text-transform: uppercase; }
        .menu-item { padding: 12px 20px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 14px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-left: 3px solid transparent; }
        .menu-item:hover { background-color: var(--bg-hover); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--bg-hover); color: var(--text-main); border-left-color: var(--primary); }
        .badge { font-size: 10px; padding: 3px 8px; border-radius: 10px; background: var(--border-color); color: var(--text-main); }
        .badge.yellow { background: var(--warning); color: #151521; font-weight: 600; }

        /* MAIN CONTENT */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { background-color: var(--topbar-bg); padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); }
        .topbar h1 { color: var(--text-main); font-size: 18px; font-weight: bold; }
        .topbar-right { display: flex; align-items: center; gap: 15px; }
        .avatar-circle { background: var(--warning); color: #151521; width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 13px; }

        /* Nút chuyển đổi Dark/Light */
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; transition: all 0.2s ease; }
        .theme-toggle:hover { background: var(--border-color); transform: scale(1.08) rotate(15deg); }

        .content { padding: 25px 30px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 25px; }

        /* CARDS THỐNG KÊ */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
        .stat-card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; display: flex; flex-direction: column; border-top: 3px solid var(--border-color); transition: all 0.2s ease;}
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
        .stat-card:nth-child(1) { border-top-color: var(--info); }
        .stat-card:nth-child(2) { border-top-color: var(--warning); }
        .stat-card:nth-child(3) { border-top-color: var(--primary); }
        .stat-card:nth-child(4) { border-top-color: var(--danger); }
        .stat-title { font-size: 12px; text-transform: uppercase; color: var(--text-muted); margin-bottom: 10px; font-weight: bold; }
        .stat-value { font-size: 28px; font-weight: bold; color: var(--text-main); }

        /* BẢNG DỮ LIỆU */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; }
        .panel-title { color: var(--warning); font-size: 14px; font-weight: bold; margin-bottom: 20px; text-transform: uppercase; border-left: 4px solid var(--warning); padding-left: 10px; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { padding: 12px 10px; font-size: 11px; color: var(--text-dim); text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        td { padding: 15px 10px; border-bottom: 1px solid var(--border-color); font-size: 13px; color: var(--text-main); }
        tr:hover td { background-color: var(--bg-hover); }

        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 8px 14px; border-radius: 6px; background: rgba(239, 68, 68, 0.1); color: var(--danger); text-decoration: none; font-size: 13px; font-weight: 600; transition: all 0.2s ease; }
        .btn-logout:hover { background: var(--danger); color: white; transform: translateY(-1px); }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
            <div style="display: flex; align-items: center; gap: 12px; width: 100%;">
                <div class="logo">S</div>
                <div class="brand-text">
                    <span class="brand-title">SUPER ADMIN</span>
                </div>
            </div>
            <div style="font-size: 12px; color: var(--text-muted); padding-left: 2px;">
                👋 Hi, <strong style="color: var(--primary);">${sessionScope.account.userName}</strong>
            </div>
        </div>
        <ul class="menu">
            <div class="menu-title">Quản lý hệ thống</div>
            <a href="${pageContext.request.contextPath}/tong-quan">
                <li class="menu-item active"><span>⊞ Tổng quan hệ thống</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests">
                <li class="menu-item">
                    <span>🏪 Duyệt Shop</span>
                    <c:if test="${shopChoDuyet > 0}">
                        <span class="badge yellow">${shopChoDuyet} mới</span>
                    </c:if>
                </li>
            </a>
            <li class="menu-item"><span>🛵 Duyệt Shipper</span></li>

            <div class="menu-title">Quản lý Dữ liệu</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan">
                <li class="menu-item"><span>👤 Người dùng</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/Category" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📂</span> Danh mục món ăn</div>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🍽️</span> Sản phẩm</div>
            </a>

        </ul>
    </aside>

    <main class="main">
        <header class="topbar">
            <h1>TỔNG QUAN HỆ THỐNG DỮ LIỆU</h1>
            <div class="topbar-right">
                <button type="button" class="theme-toggle" id="themeToggleBtn" title="Chuyển đổi giao diện">🌓</button>
                <div class="avatar-circle">AD</div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
            </div>
        </header>

        <div class="content">
            <!-- 4 CARD THỐNG KÊ -->
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-title">Tổng Tài Khoản Hệ Thống</span>
                    <span class="stat-value">${tongTaiKhoan}</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Shop Chờ Phê Duyệt</span>
                    <span class="stat-value" style="color: var(--warning);">${shopChoDuyet}</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Shipper Đang Hoạt Động</span>
                    <span class="stat-value" style="color: var(--primary);">${shipperHoatDong}</span>
                </div>
                <div class="stat-card">
                    <span class="stat-title">Cảnh Báo Vi Phạm</span>
                    <span class="stat-value" style="color: var(--danger);">${canhBaoViPham}</span>
                </div>
            </div>

            <!-- BẢNG TOP 5 YÊU CẦU DUYỆT SHOP -->
            <div class="panel">
                <div class="panel-title">■ YÊU CẦU DUYỆT SHOP GẦN ĐÂY</div>
                <table>
                    <thead>
                        <tr>
                            <th>Người đăng ký</th>
                            <th>Email</th>
                            <th>Ngày đăng ký</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="account" items="${top5Shop}">
                            <tr>
                                <td>
                                    <strong style="color: var(--text-main);">${account.fullName}</strong><br>
                                    <span style="font-size: 12px; color: var(--text-dim);">📞 ${account.phone}</span>
                                </td>
                                <td style="color: var(--text-muted);">${account.email}</td>
                                <td style="color: var(--text-muted);">${account.createdAt}</td>
                                <td style="color: var(--warning); font-weight: bold;">⏳ Chờ xử lý</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty top5Shop}">
                            <tr>
                                <td colspan="4" style="text-align: center; color: var(--text-dim); padding: 20px;">
                                    🏪 Hiện chưa có yêu cầu đăng ký shop nào.<br>
                                    Bấm vào menu <b>"Duyệt Shop"</b> để xem toàn bộ danh sách từ Database.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script>
        (function () {
            const htmlElement = document.documentElement;
            const themeToggleBtn = document.getElementById('themeToggleBtn');
            const savedTheme = localStorage.getItem('theme') || 'dark';
            htmlElement.setAttribute('data-theme', savedTheme);

            themeToggleBtn.addEventListener('click', () => {
                const currentTheme = htmlElement.getAttribute('data-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                htmlElement.setAttribute('data-theme', newTheme);
                localStorage.setItem('theme', newTheme);
            });
        })();
    </script>
</body>
</html>

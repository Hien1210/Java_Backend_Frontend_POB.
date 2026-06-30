<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết yêu cầu shop - Super Admin</title>
    <style>
        /* ================= BIẾN THEME (DARK/LIGHT) ================= */
        :root[data-theme="dark"] {
            --bg-base: #151521;
            --bg-sidebar: #1e1e2d;
            --bg-panel: #1e1e2d;
            --bg-input: #111119;
            --bg-hover: #1b1b29;
            --text-main: #ffffff;
            --text-muted: #a1a5b7;
            --text-dim: #565674;
            --border-color: #2b2b40;
            --topbar-bg: #1e1e2d;
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

        /* Reset cơ bản */
        * { box-sizing: border-box; margin: 0; padding: 0; transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }

        /* Sidebar */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); display: flex; flex-direction: column; border-right: 1px solid var(--border-color); height: 100%; flex-shrink: 0; }
        .sidebar-brand { padding: 20px 25px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo-icon { background: var(--primary); color: #fff; width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 16px; }
        .brand-text { display: flex; flex-direction: column; flex: 1; }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 14px; letter-spacing: 0.5px; }
        .brand-subtitle { color: var(--warning); font-size: 10px; }
        .badge-system { background: rgba(32, 212, 137, 0.1); color: var(--primary); font-size: 10px; padding: 4px 8px; border-radius: 4px; border: 1px solid var(--primary); }

        .menu-section { padding: 15px 0; overflow-y: auto; }
        .menu-title { font-size: 11px; text-transform: uppercase; color: var(--text-dim); margin: 15px 25px 10px; font-weight: 600; letter-spacing: 0.5px; }
        .menu-item { padding: 12px 25px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); text-decoration: none; font-size: 13px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-left: 3px solid transparent; }
        .menu-item:hover { background-color: var(--bg-hover); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: rgba(32, 212, 137, 0.1); color: var(--primary); border-left-color: var(--primary); }
        .menu-item-left { display: flex; align-items: center; gap: 12px; }
        .badge-count { font-size: 10px; padding: 3px 8px; border-radius: 12px; background: var(--border-color); color: var(--text-main); }
        .badge-count.green { background: var(--primary); color: #151521; font-weight: 600; }

        /* Main Content & Header */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; background-color: var(--bg-base); }
        .top-header { height: 70px; background-color: var(--topbar-bg); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 30px; flex-shrink: 0; }
        .top-header h2 { color: var(--text-main); font-size: 18px; font-weight: 600; }
        .header-actions { display: flex; align-items: center; gap: 15px; }
        .search-bar { background-color: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; padding: 8px 15px; color: var(--text-main); width: 280px; outline: none; font-size: 13px; }
        .search-bar:focus { border-color: var(--primary); }
        .avatar { width: 35px; height: 35px; background-color: var(--warning); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #151521; font-weight: bold; font-size: 14px; }

        /* Nút chuyển đổi Dark/Light */
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; transition: all 0.2s ease; }
        .theme-toggle:hover { background: var(--border-color); transform: scale(1.08) rotate(15deg); }

        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 8px 14px; border-radius: 6px; background: rgba(239, 68, 68, 0.1); color: var(--danger); text-decoration: none; font-size: 13px; font-weight: 600; border: 1px solid transparent; }
        .btn-logout:hover { background: var(--danger); color: white; border-color: var(--danger); transform: translateY(-1px); }

        .content-wrapper { padding: 30px; overflow-y: auto; flex: 1; }
        .section-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .section-title-wrapper { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
        .indicator { width: 8px; height: 16px; background-color: var(--warning); border-radius: 2px; }
        .section-title { color: var(--warning); font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .section-desc { color: var(--text-muted); font-size: 13px; margin-left: 18px; }
        .section-desc strong { color: var(--text-main); }

        /* Grid & Card cho chi tiết */
        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 22px; margin-top: 10px; }
        .info-card { background: var(--bg-panel); border-radius: 10px; padding: 24px; border: 1px solid var(--border-color); }
        .info-card h3 { color: var(--warning); font-size: 14px; font-weight: 700; margin-bottom: 20px; text-transform: uppercase; border-left: 3px solid var(--warning); padding-left: 10px; }
        .info-row { display: flex; padding: 10px 0; border-bottom: 1px solid var(--border-color); }
        .info-label { width: 120px; font-weight: 600; color: var(--text-muted); }
        .info-value { flex: 1; color: var(--text-main); word-break: break-word; }

        /* Actions */
        .action-group { display: flex; gap: 15px; margin-top: 25px; flex-wrap: wrap; }
        .btn { display: inline-block; padding: 10px 24px; border-radius: 6px; font-weight: 600; font-size: 13px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); text-align: center; cursor: pointer; text-decoration: none; border: none; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
        .btn:active { transform: translateY(0); }
        .btn-approve { background: var(--primary); color: #151521; }
        .btn-approve:hover { background: #1ab877; }
        .btn-reject { background: var(--danger); color: white; }
        .btn-reject:hover { background: #b91c1c; }
        .btn-back { background: #475569; color: white; display: inline-block; margin-bottom: 20px; }
        .btn-back:hover { background: #334155; }

        .error-msg { background: rgba(239, 68, 68, 0.1); border: 1px solid var(--danger); color: var(--danger); padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: bold; }
        .empty { margin: 0; padding: 30px; background: var(--bg-panel); color: var(--primary); text-align: center; font-size: 15px; border-radius: 10px; border: 1px dashed var(--border-color); }

        @media (max-width: 820px) { .detail-grid { grid-template-columns: 1fr; } }
    </style>
    <script>
        function askRejectReason() {
            var reason = prompt("Nhập lý do từ chối yêu cầu shop:");
            if (reason === null) {
                return false;
            }
            if (reason.trim() === "") {
                alert("Vui lòng nhập lý do từ chối.");
                return false;
            }
            document.getElementById("rejectionReason").value = reason.trim();
            return true;
        }
    </script>
</head>
<body>

    <aside class="sidebar">
       <div class="sidebar-brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
                  <div style="display: flex; align-items: center; gap: 12px; width: 100%;">
                      <div class="logo-icon">S</div>
                      <div class="brand-text">
                          <span class="brand-title">SUPER</span>
                          <span class="brand-subtitle">ADMIN PANEL</span>
                      </div>
                      <span class="badge-system">SYSTEM</span>
                  </div>
                  <div style="font-size: 12px; color: var(--text-muted); padding-left: 2px;">
                      👋 Hi, <strong style="color: var(--primary);">${sessionScope.account.userName}</strong>
                  </div>
              </div>
        <div class="menu-section">
            <div class="menu-title">QUẢN LÝ HỆ THỐNG</div>
            <a href="${pageContext.request.contextPath}/tong-quan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">⊞</span> Tổng quan hệ thống</div>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item active">
                <div class="menu-item-left"><span style="font-size: 16px;">🏪</span> Duyệt Shop</div>
                <c:if test="${not empty pendingShops}">
                    <span class="badge-count green">${pendingShops.size()} mới</span>
                </c:if>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🛵</span> Duyệt Shipper</div>
            </a>

            <div class="menu-title" style="margin-top: 25px;">QUẢN LÝ DỮ LIỆU</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">👤</span> Người dùng</div>
            </a>
            <a href="${pageContext.request.contextPath}/Category" class="menu-item">
                            <div class="menu-item-left"><span style="font-size: 16px;">📂</span> Danh mục món ăn</div>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🍽️</span> Sản phẩm</div>
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <h2>CHI TIẾT YÊU CẦU DUYỆT SHOP</h2>
            <div class="header-actions">
                <input type="text" class="search-bar" placeholder="Tìm kiếm...">
                <button type="button" class="theme-toggle" id="themeToggleBtn" title="Chuyển đổi giao diện">🌓</button>
                <div class="avatar">AD</div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><span style="font-size: 14px;">🚪</span> Đăng xuất</a>
            </div>
        </header>

        <div class="content-wrapper">
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="btn btn-back">← Quay lại danh sách</a>

            <c:if test="${not empty loi}">
                <div class="error-msg">⚠️ <c:out value="${loi}"/></div>
            </c:if>

            <c:if test="${not empty shop}">
                <div class="section-header">
                    <div>
                        <div class="section-title-wrapper">
                            <div class="indicator"></div>
                            <h1 class="section-title">CHI TIẾT YÊU CẦU ĐĂNG KÝ SHOP - MÃ SỐ #<c:out value="${shop.id}"/></h1>
                        </div>
                        <p class="section-desc">Xem thông tin chi tiết cửa hàng yêu cầu mở shop.</p>
                    </div>
                </div>

                <div class="detail-grid">
                    <!-- Thông tin cửa hàng đăng ký -->
                    <div class="info-card" style="grid-column: 1 / -1; max-width: 800px; margin: 0 auto; width: 100%;">
                        <h3>🏪 THÔNG TIN ĐĂNG KÝ SHOP</h3>
                        <div class="info-row">
                            <div class="info-label">ID</div>
                            <div class="info-value"><c:out value="${shop.id}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Tên shop</div>
                            <div class="info-value"><c:out value="${shop.shopName}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Mô tả</div>
                            <div class="info-value"><c:out value="${shop.shopDescription}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Địa chỉ</div>
                            <div class="info-value"><c:out value="${shop.shopAddress}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value"><c:out value="${shop.shopPhone}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Trạng thái</div>
                            <div class="info-value"><c:out value="${shop.status}"/></div>
                        </div>
                        <div class="info-row">
                            <div class="info-label">Ngày tạo</div>
                            <div class="info-value"><c:out value="${shop.createdAt}"/></div>
                        </div>
                    </div>
                </div>

                <div class="action-group">
                    <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post">
                        <input type="hidden" name="action" value="accept">
                        <input type="hidden" name="id" value="${shop.id}">
                        <button type="submit" class="btn btn-approve" onclick="return confirm('Xác nhận DUYỆT cửa hàng [${shop.shopName}]?')">✓ CHẤP NHẬN</button>
                    </form>

                    <form action="${pageContext.request.contextPath}/super-admin/shop-requests" method="post" onsubmit="return askRejectReason()">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="id" value="${shop.id}">
                        <input type="hidden" name="rejectionReason" id="rejectionReason">
                        <button type="submit" class="btn btn-reject">✕ TỪ CHỐI</button>
                    </form>
                </div>
            </c:if>

            <c:if test="${empty shop}">
                <div class="empty">Không tìm thấy thông tin yêu cầu mở shop.</div>
            </c:if>
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<c:set var="formAccount" value="${not empty accountSua ? accountSua : accountForm}"/>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản - Super Admin</title>
    <style>
        /* ================= BIẾN HỆ THỐNG (THEMING) ================= */
        :root[data-theme="dark"] {
            --bg-base: #0f172a;
            --bg-sidebar: #1e293b;
            --bg-panel: #1e293b;
            --bg-input: #0f172a;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --border-color: #334155;
            --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
            --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
            --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.3), 0 4px 6px -4px rgb(0 0 0 / 0.3);
            --topbar-bg: rgba(30, 41, 59, 0.8);
        }

        :root[data-theme="light"] {
            --bg-base: #f1f5f9;
            --bg-sidebar: #ffffff;
            --bg-panel: #ffffff;
            --bg-input: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 3px 0 rgba(0,0,0,0.1);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.06);
            --shadow-lg: 0 10px 25px -5px rgba(0,0,0,0.05), 0 8px 10px -6px rgba(0,0,0,0.05);
            --topbar-bg: rgba(255, 255, 255, 0.8);
        }

        /* Màu chủ đạo cố định */
        :root {
            --primary: #10b981;
            --primary-hover: #059669;
            --primary-light: rgba(16, 185, 129, 0.15);
            --warning: #f59e0b;
            --danger: #ef4444;
            --danger-light: rgba(239, 68, 68, 0.1);
            --info: #3b82f6;
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }

        /* ================= RESET & CƠ BẢN ================= */
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.3s ease, border-color 0.3s ease; }
        body { background-color: var(--bg-base); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        /* Custom thanh cuộn mượt */
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--border-color); border-radius: 4px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--text-muted); }

        /* ================= SIDEBAR ================= */
        .sidebar { width: 260px; background-color: var(--bg-sidebar); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; box-shadow: var(--shadow-sm); z-index: 10; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: linear-gradient(135deg, var(--primary), #3b82f6); color: #fff; width: 36px; height: 36px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3); }
        .brand-text { display: flex; flex-direction: column; }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 15px; letter-spacing: 0.5px; }

        .menu { padding: 20px 12px; flex: 1; overflow-y: auto; }
        .menu-title { font-size: 11px; color: var(--text-muted); font-weight: 700; margin: 20px 12px 8px; text-transform: uppercase; letter-spacing: 1px; }
        .menu-item { padding: 12px 16px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); font-size: 14px; font-weight: 500; border-radius: 8px; margin-bottom: 4px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); font-weight: 600; }
        .badge-count { font-size: 11px; padding: 2px 8px; border-radius: 20px; background: var(--border-color); color: var(--text-main); font-weight: 600; }
        .badge-count.green { background: var(--primary); color: #fff; }

        /* ================= MAIN CONTENT & HEADER ================= */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; position: relative; }

        .topbar { background-color: var(--topbar-bg); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); padding: 16px 32px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); z-index: 5; }
        .topbar h1 { color: var(--text-main); font-size: 20px; font-weight: 700; letter-spacing: -0.5px; }
        .topbar-right { display: flex; align-items: center; gap: 20px; }

        /* Search Box nâng cấp */
        .search-form { display: flex; gap: 8px; position: relative; }
        .search-box { background: var(--bg-input); border: 1px solid var(--border-color); padding: 10px 16px 10px 38px; border-radius: 8px; color: var(--text-main); width: 300px; outline: none; font-size: 13px; transition: all 0.2s; }
        .search-box:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15); width: 340px; }
        .search-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--text-muted); pointer-events: none; font-size: 13px; }
        .btn-search { background: var(--primary); border: none; border-radius: 8px; padding: 10px 18px; color: #fff; font-weight: 600; font-size: 13px; cursor: pointer; transition: all 0.2s; }
        .btn-search:hover { background: var(--primary-hover); transform: translateY(-1px); }

        /* Theme Toggle Button */
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; transition: all 0.2s; }
        .theme-toggle:hover { background: var(--border-color); transform: scale(1.05); }

        .avatar-circle { background: var(--warning); color: #151521; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; box-shadow: var(--shadow-sm); }
        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 10px 16px; border-radius: 8px; background: var(--danger-light); color: var(--danger); font-size: 13px; font-weight: 600; transition: all 0.2s; }
        .btn-logout:hover { background: var(--danger); color: white; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2); }

        .content { padding: 32px; overflow-y: auto; flex: 1; display: flex; flex-direction: column; gap: 32px; animation: fadeInUp 0.4s ease-out; }

        /* ================= PANELS & TABLES ================= */
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; box-shadow: var(--shadow-md); }
        .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; flex-wrap: wrap; gap: 16px; }
        .panel-title-wrapper { display: flex; flex-direction: column; gap: 4px; }
        .panel-title { color: var(--text-main); font-size: 16px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; display: flex; align-items: center; gap: 8px; }
        .panel-title::before { content: ''; display: inline-block; width: 4px; height: 16px; background: var(--primary); border-radius: 2px; }
        .panel-title.orange::before { background: var(--warning); }
        .panel-subtitle { font-size: 12px; color: var(--text-muted); }

        .btn-add-user { background: linear-gradient(135deg, var(--primary), #059669); color: white; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; border: none; cursor: pointer; display: flex; align-items: center; gap: 8px; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); transition: all 0.2s; }
        .btn-add-user:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(16, 185, 129, 0.3); }
        .btn-clear { background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 8px; padding: 8px 16px; color: var(--text-main); font-size: 12px; font-weight: 500; transition: 0.2s; }
        .btn-clear:hover { background: var(--border-color); }

        /* ================= TABLE DESIGN ================= */
        .table-responsive { width: 100%; overflow-x: auto; border-radius: 8px; }
        table { width: 100%; border-collapse: separate; border-spacing: 0; text-align: left; }
        th { padding: 14px 16px; font-size: 11px; color: var(--text-muted); text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; border-bottom: 2px solid var(--border-color); background: rgba(0,0,0,0.02); }
        td { padding: 16px; border-bottom: 1px solid var(--border-color); font-size: 13px; color: var(--text-main); vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr { transition: all 0.2s; }
        tbody tr:hover { background-color: rgba(16, 185, 129, 0.02); transform: scale([1.002]); }

        /* Badges */
        .role-badge { padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; }
        .role-admin { background: rgba(245, 158, 11, 0.12); color: var(--warning); }
        .role-shop { background: rgba(59, 130, 246, 0.12); color: var(--info); }
        .role-user { background: rgba(148, 163, 184, 0.12); color: var(--text-muted); }
        .role-shipper { background: rgba(16, 185, 129, 0.12); color: var(--primary); }

        .avatar-img { width: 38px; height: 38px; border-radius: 50%; object-fit: cover; background: var(--bg-input); border: 2px solid var(--border-color); display: flex; align-items: center; justify-content: center; font-size: 10px; overflow: hidden; box-shadow: var(--shadow-sm); }
        .protected-badge { color: var(--text-muted); font-size: 12px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; opacity: 0.7; }

        .sort-link { color: var(--text-muted); text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s; }
        .sort-link:hover { color: var(--primary); }
        .sort-icon { font-size: 11px; }

        /* Action Buttons */
        .actions-group { display: flex; gap: 6px; }
        .btn-action { padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; cursor: pointer; border: 1px solid var(--border-color); background: var(--bg-panel); color: var(--text-main); transition: all 0.15s; }
        .btn-action:hover { border-color: var(--primary); color: var(--primary); background: var(--primary-light); }
        .btn-action.btn-delete-row { color: var(--danger); }
        .btn-action.btn-delete-row:hover { border-color: var(--danger); background: var(--danger-light); color: var(--danger); }

        .info-msg { background: var(--primary-light); border: 1px solid var(--primary); color: var(--primary); padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 13px; font-weight: 500; display: flex; align-items: center; gap: 8px; }

        /* ================= POPUP MODAL DIALOG ================= */
        .modal-backdrop { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); -webkit-backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 100; opacity: 0; pointer-events: none; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
        .modal-backdrop.active { opacity: 1; pointer-events: auto; }

        .modal-content { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 16px; width: 650px; max-width: 90%; max-height: 90vh; overflow-y: auto; box-shadow: var(--shadow-lg); transform: scale(0.9) translateY(20px); transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); }
        .modal-backdrop.active .modal-content { transform: scale(1) translateY(0); }

        .modal-header { padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; }
        .modal-close { background: transparent; border: none; color: var(--text-muted); font-size: 20px; cursor: pointer; padding: 4px; line-height: 1; border-radius: 6px; transition: 0.2s; }
        .modal-close:hover { color: var(--text-main); background: var(--bg-input); }
        .modal-body { padding: 24px; }

        /* Form styling inside modal */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full-width { grid-column: span 2; }
        label { font-size: 12px; color: var(--text-main); font-weight: 600; }
        input, select { background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-main); padding: 10px 14px; border-radius: 8px; font-size: 13px; outline: none; transition: all 0.2s; }
        input:focus, select:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15); }
        .hint { font-size: 11px; color: var(--text-muted); margin-top: 2px; }
        .error-msg { color: var(--danger); font-size: 12px; margin-top: 12px; display: block; font-weight: 500; }

        .btn-group { display: flex; justify-content: flex-end; gap: 10px; margin-top: 24px; padding-top: 16px; border-top: 1px solid var(--border-color); }
        .btn-modal { padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 13px; cursor: pointer; border: none; transition: all 0.15s; }
        .btn-modal-primary { background: var(--primary); color: white; }
        .btn-modal-primary:hover { background: var(--primary-hover); transform: translateY(-1px); }
        .btn-modal-secondary { background: var(--bg-input); border: 1px solid var(--border-color); color: var(--text-main); }
        .btn-modal-secondary:hover { background: var(--border-color); }

        /* KEYFRAMES ANIMATION */
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(12px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="brand" style="flex-direction: column; align-items: flex-start; gap: 10px;">
            <div style="display: flex; align-items: center; gap: 12px; width: 100%;">
                <div class="logo">S</div>
                <div class="brand-text">
                    <span class="brand-title">SUPER ADMIN</span>
                    <span style="font-size: 10px; color: var(--warning); font-weight: 600;">MANAGEMENT</span>
                </div>
            </div>
            <div style="font-size: 12px; color: var(--text-muted); padding-left: 2px;">
                👋 Hi, <strong style="color: var(--primary);">${sessionScope.account.userName}</strong>
            </div>
        </div>

        <ul class="menu">
            <div class="menu-title">Quản lý hệ thống</div>
            <a href="${pageContext.request.contextPath}/tong-quan">
                <li class="menu-item"><span>⊞ Tổng quan hệ thống</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item">
                <div>🏪 Duyệt Shop</div>
                <span class="badge-count green">2 mới</span>
            </a>
            <li class="menu-item"><span>🛵 Duyệt Shipper</span></li>

            <div class="menu-title">Quản lý Dữ liệu</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan">
                <li class="menu-item active"><span>👤 Người dùng</span></li>
            </a>
            <a href="${pageContext.request.contextPath}/Category" class="menu-item">
                <div>📂 Danh mục món ăn</div>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="menu-item">
                <div>🍽️ Sản phẩm</div>
            </a>
        </ul>
    </aside>

    <main class="main">
        <header class="topbar">
            <h1>Quản lý tài khoản</h1>
            <div class="topbar-right">
                <form action="${pageContext.request.contextPath}/quanlitaikhoan" method="post" class="search-form">
                    <input type="hidden" name="action" value="search">
                    <span class="search-icon">🔍</span>
                    <input type="text" name="searchKeyword" class="search-box"
                           placeholder="Tìm kiếm tài khoản, email..."
                           value="${fn:escapeXml(searchKeyword)}">
                    <button type="submit" class="btn-search">Tìm</button>
                </form>

                <button type="button" class="theme-toggle" id="themeToggleBtn" title="Chuyển đổi giao diện">🌓</button>

                <div class="avatar-circle" title="Admin">AD</div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
            </div>
        </header>

        <div class="content">
        <c:if test="${param.success == 'create'}">
            <div class="info-msg">✅ Tạo tài khoản thành công!</div>
        </c:if>
        <c:if test="${param.success == 'update'}">
            <div class="info-msg">✅ Cập nhật tài khoản thành công!</div>
        </c:if>
        <c:if test="${param.success == 'delete'}">
            <div class="info-msg">✅ Xóa tài khoản thành công!</div>
        </c:if>
            <div class="panel">
                <div class="panel-header">
                    <div class="panel-title-wrapper">
                        <div class="panel-title">Danh sách tài khoản hệ thống</div>
                        <div class="panel-subtitle">Hiển thị danh sách và phân quyền người dùng toàn bộ hệ thống.</div>
                    </div>
                    <div style="display: flex; gap: 8px;">
                        <c:if test="${not empty searchKeyword}">
                            <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="btn-clear">🔄 Xóa tìm kiếm</a>
                        </c:if>
                        <button type="button" class="btn-add-user" onclick="openAccountModal()">➕ Thêm tài khoản mới</button>
                    </div>
                </div>

                <c:if test="${not empty searchKeyword}">
                    <div class="info-msg">
                        <span>🔍 Kết quả tìm kiếm cho: <strong>"${fn:escapeXml(searchKeyword)}"</strong> (Tìm thấy <strong>${fn:length(danhsach)}</strong> kết quả)</span>
                    </div>
                </c:if>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 80px;">
                                    <a href="?sortField=id&sortOrder=${currentSortField == 'id' && currentSortOrder == 'ASC' ? 'DESC' : 'ASC'}&searchKeyword=${fn:escapeXml(searchKeyword)}" class="sort-link">
                                        ID <span class="sort-icon">${currentSortField == 'id' && currentSortOrder == 'ASC' ? '▲' : (currentSortField == 'id' && currentSortOrder == 'DESC' ? '▼' : '⇅')}</span>
                                    </a>
                                </th>
                                <th style="width: 70px;">Avatar</th>
                                <th>
                                    <a href="?sortField=username&sortOrder=${currentSortField == 'username' && currentSortOrder == 'ASC' ? 'DESC' : 'ASC'}&searchKeyword=${fn:escapeXml(searchKeyword)}" class="sort-link">
                                        Tài khoản <span class="sort-icon">${currentSortField == 'username' && currentSortOrder == 'ASC' ? '▲' : (currentSortField == 'username' && currentSortOrder == 'DESC' ? '▼' : '⇅')}</span>
                                    </a>
                                </th>
                                <th>
                                    <a href="?sortField=email&sortOrder=${currentSortField == 'email' && currentSortOrder == 'ASC' ? 'DESC' : 'ASC'}&searchKeyword=${fn:escapeXml(searchKeyword)}" class="sort-link">
                                        Liên hệ <span class="sort-icon">${currentSortField == 'email' && currentSortOrder == 'ASC' ? '▲' : (currentSortField == 'email' && currentSortOrder == 'DESC' ? '▼' : '⇅')}</span>
                                    </a>
                                </th>
                                <th style="width: 140px;">
                                    <a href="?sortField=role&sortOrder=${currentSortField == 'role' && currentSortOrder == 'ASC' ? 'DESC' : 'ASC'}&searchKeyword=${fn:escapeXml(searchKeyword)}" class="sort-link">
                                        Vai trò <span class="sort-icon">${currentSortField == 'role' && currentSortOrder == 'ASC' ? '▲' : (currentSortField == 'role' && currentSortOrder == 'DESC' ? '▼' : '⇅')}</span>
                                    </a>
                                </th>
                                <th style="width: 160px; text-align: center;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="acc" items="${danhsach}">
                                <tr>
                                    <td style="font-weight: 700; color: var(--text-muted);">#<c:out value="${acc.id}"/></td>
                                    <td>
                                        <div class="avatar-img">
                                            <c:choose>
                                                <c:when test="${not empty acc.avatarUrl}">
                                                    <img src="${acc.avatarUrl}" alt="Avatar" style="width:100%; height:100%; object-fit:cover;">
                                                </c:when>
                                                <c:otherwise>👤</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>
                                        <div style="font-weight: 600;"><c:out value="${acc.userName}"/></div>
                                        <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;"><c:out value="${acc.fullName}"/></div>
                                    </td>
                                    <td>
                                        <div><c:out value="${acc.email}"/></div>
                                        <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">📞 <c:out value="${acc.phone}"/></div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${acc.roleId == 1}"><span class="role-badge role-admin">👑 Admin</span></c:when>
                                            <c:when test="${acc.roleId == 2}"><span class="role-badge role-shop">🏪 Shop</span></c:when>
                                            <c:when test="${acc.roleId == 3}"><span class="role-badge role-user">👤 User</span></c:when>
                                            <c:when test="${acc.roleId == 4}"><span class="role-badge role-shipper">🛵 Shipper</span></c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-group" style="justify-content: center;">
                                            <c:choose>
                                                <c:when test="${acc.roleId == 1}">
                                                    <span class="protected-badge">🔒 Hệ thống bảo vệ</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/quanlitaikhoan?action=edit&id=${acc.id}" class="btn-action">✏️ Sửa</a>
                                                    <form action="${pageContext.request.contextPath}/quanlitaikhoan" method="post" style="display: inline;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${acc.id}">
                                                        <button class="btn-action btn-delete-row" type="submit" onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản [ ${acc.userName} ] không?')">🗑️ Xóa</button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${not empty searchKeyword and empty danhsach}">
                                <tr>
                                    <td colspan="6" style="text-align: center; padding: 40px; color: var(--danger);">
                                        ⚠️ Không tìm thấy tài khoản nào khớp với từ khóa của bạn.
                                    </td>
                                end pt-tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>

    <div class="modal-backdrop" id="accountModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="panel-title-wrapper">
                    <h3 class="panel-title ${not empty accountSua ? 'orange' : ''}">
                        <c:choose>
                            <c:when test="${not empty accountSua}">Cập nhật tài khoản</c:when>
                            <c:otherwise>Tạo tài khoản hệ thống mới</c:otherwise>
                        </c:choose>
                    </h3>
                </div>
                <button type="button" class="modal-close" onclick="closeAccountModal()">✕</button>
            </div>

            <div class="modal-body">
                <div style="font-size: 11px; color: var(--text-muted); background: rgba(0,0,0,0.03); padding: 10px; border-radius: 6px; margin-bottom: 20px;">
                    💡 <strong>Lưu ý:</strong> Tài khoản loại Khách hàng (User) sẽ tự đăng ký ngoài hệ thống. Tại đây chỉ thao tác tạo lập phân quyền các cấp quản trị: Admin, Shop, Shipper.
                </div>

                <form action="${pageContext.request.contextPath}/quanlitaikhoan" method="post" accept-charset="UTF-8">
                    <c:choose>
                        <c:when test="${not empty accountSua}">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${accountSua.id}">
                        </c:when>
                        <c:otherwise>
                            <input type="hidden" name="action" value="create">
                        </c:otherwise>
                    </c:choose>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="username">Tên đăng nhập (Username) *</label>
                            <input id="username" type="text" name="username" value="${fn:escapeXml(formAccount.userName)}" required placeholder="Ví dụ: admin_store">
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu *</label>
                            <c:choose>
                                <c:when test="${empty accountSua}">
                                    <input id="password" type="password" name="password" required placeholder="Nhập mật khẩu an toàn">
                                </c:when>
                                <c:otherwise>
                                    <input id="password" type="password" name="password" placeholder="••••••••">
                                    <span class="hint">Để trống nếu giữ nguyên mật khẩu cũ.</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="form-group">
                            <label for="fullname">Họ và tên</label>
                            <input id="fullname" type="text" name="fullname" value="${fn:escapeXml(formAccount.fullName)}" placeholder="Nguyễn Văn A">
                        </div>

                        <div class="form-group">
                            <label for="email">Địa chỉ Email *</label>
                            <input id="email" type="email" name="email" value="${fn:escapeXml(formAccount.email)}" required placeholder="name@example.com">
                        </div>

                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <input id="phone" type="text" name="phone" value="${fn:escapeXml(formAccount.phone)}" placeholder="09xx xxx xxx">
                        </div>

                        <div class="form-group">
                            <label for="roleid">Phân quyền (Role) *</label>
                            <select id="roleid" name="roleid" required>
                                <option value="1" ${formAccount.roleId == 1 ? 'selected' : ''}>👑 Admin (Quản trị viên)</option>
                                <option value="2" ${formAccount.roleId == 2 ? 'selected' : ''}>🏪 Shop (Chủ cửa hàng)</option>
                                <option value="4" ${formAccount.roleId == 4 ? 'selected' : ''}>🛵 Shipper (Giao hàng)</option>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label for="avatarurl">Đường dẫn ảnh đại diện (Avatar URL)</label>
                            <input id="avatarurl" type="text" name="avatarurl" value="${fn:escapeXml(formAccount.avatarUrl)}" placeholder="https://domain.com/path-to-image.png">
                        </div>
                    </div>

                    <c:if test="${not empty loi}">
                        <span class="error-msg">⚠️ <c:out value="${loi}"/></span>
                    </c:if>

                    <div class="btn-group">
                        <button type="button" class="btn-modal btn-modal-secondary" onclick="closeAccountModal()">Hủy thao tác</button>
                        <button type="submit" class="btn-modal btn-modal-primary">
                            <c:choose>
                                <c:when test="${not empty accountSua}">💾 Lưu cập nhật</c:when>
                                <c:otherwise>🚀 Tạo ngay</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        const modal = document.getElementById('accountModal');
        const themeToggleBtn = document.getElementById('themeToggleBtn');
        const htmlElement = document.documentElement;

        // Trạng thái edit từ Server gửi về bằng JSTL
        const isEditMode = ${not empty accountSua ? true : false};
        const hasError = ${not empty loi ? true : false};

        // --- XỬ LÝ POPUP MODAL ---
        function openAccountModal() {
            modal.classList.add('active');
        }

        function closeModalLogic() {
            modal.classList.remove('active');
            if (isEditMode) {
                // Nếu đang ở chế độ Edit từ Backend, khi hủy cần redirect để xóa session/request attribute của accountSua
                window.location.href = '${pageContext.request.contextPath}/quanlitaikhoan';
            }
        }

        function closeAccountModal() {
            closeModalLogic();
        }

        // Đóng popup khi bấm click ra ngoài vùng form
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeModalLogic();
            }
        });

        // Tự động mở popup nếu có lỗi từ Server hoặc đang ở trạng thái Sửa dữ liệu
        document.addEventListener('DOMContentLoaded', () => {
            if (isEditMode || hasError) {
                openAccountModal();
            }
        });

        // --- XỬ LÝ DARK / LIGHT MODE ---
        // Đọc cấu hình theme trước đó từ localStorage hệ thống trình duyệt
        const savedTheme = localStorage.getItem('theme') || 'dark';
        htmlElement.setAttribute('data-theme', savedTheme);

        themeToggleBtn.addEventListener('click', () => {
            const currentTheme = htmlElement.getAttribute('data-theme');
            let newTheme = 'dark';

            if (currentTheme === 'dark') {
                newTheme = 'light';
            }

            htmlElement.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
        });
    </script>

</body>
</html>
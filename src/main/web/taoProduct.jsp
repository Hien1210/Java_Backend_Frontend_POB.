<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<%-- BẢO MẬT: KIỂM TRA QUYỀN SUPER ADMIN --%>
<c:if test="${empty sessionScope.account || sessionScope.account.roleId != 1}">
    <c:redirect url="/dangnhap"/>
</c:if>

<!DOCTYPE html>
<html lang="vi" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Quản lý sản phẩm - Super Admin</title>
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

        * { box-sizing: border-box; margin: 0; padding: 0; transition: background-color 0.3s ease, border-color 0.3s ease, color 0.3s ease; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-base); color: var(--text-muted); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }

        .sidebar { width: 260px; background-color: var(--bg-sidebar); display: flex; flex-direction: column; border-right: 1px solid var(--border-color); height: 100%; flex-shrink: 0; }
        .sidebar-brand { padding: 20px 25px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo-icon { background: var(--primary); color: #fff; width: 32px; height: 32px; border-radius: 6px; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 16px; }
        .brand-text { display: flex; flex-direction: column; flex: 1; }
        .brand-title { color: var(--text-main); font-weight: 700; font-size: 14px; letter-spacing: 0.5px; }
        .brand-subtitle { color: var(--warning); font-size: 10px; }
        .badge-system { background: rgba(32, 212, 137, 0.1); color: var(--primary); font-size: 10px; padding: 4px 8px; border-radius: 4px; border: 1px solid var(--primary); }

        .menu-section { padding: 15px 0; overflow-y: auto; }
        .menu-title { font-size: 11px; text-transform: uppercase; color: var(--text-dim); margin: 15px 25px 10px; font-weight: 600; letter-spacing: 0.5px; }
        .menu-item { padding: 12px 25px; display: flex; align-items: center; justify-content: space-between; color: var(--text-muted); text-decoration: none; font-size: 13px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); border-left: 3px solid transparent; cursor: pointer; }
        .menu-item:hover { background-color: var(--bg-hover); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: rgba(32, 212, 137, 0.1); color: var(--primary); border-left-color: var(--primary); }
        .menu-item-left { display: flex; align-items: center; gap: 12px; }

        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; background-color: var(--bg-base); }
        .top-header { height: 70px; background-color: var(--topbar-bg); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 30px; flex-shrink: 0; }
        .top-header h2 { color: var(--text-main); font-size: 18px; font-weight: 600; }
        .header-actions { display: flex; align-items: center; gap: 15px; }
        .search-bar { background-color: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; padding: 8px 15px; color: var(--text-main); width: 280px; outline: none; font-size: 13px; }
        .search-bar:focus { border-color: var(--primary); }
        .avatar { width: 35px; height: 35px; background-color: var(--warning); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #151521; font-weight: bold; font-size: 14px; }
        .btn-logout { display: flex; align-items: center; gap: 6px; padding: 8px 14px; border-radius: 6px; background: rgba(239, 68, 68, 0.1); color: var(--danger); text-decoration: none; font-size: 13px; font-weight: 600; border: 1px solid transparent; }
        .btn-logout:hover { background: var(--danger); color: white; border-color: var(--danger); transform: translateY(-1px); }

        /* Nút chuyển đổi Dark/Light */
        .theme-toggle { background: var(--bg-input); border: 1px solid var(--border-color); width: 38px; height: 38px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; justify-content: center; color: var(--text-main); font-size: 16px; transition: all 0.2s ease; }
        .theme-toggle:hover { background: var(--border-color); transform: scale(1.08) rotate(15deg); }

        .content-wrapper { padding: 30px; overflow-y: auto; flex: 1; }
        .section-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px; }
        .section-title-wrapper { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
        .indicator { width: 8px; height: 16px; background-color: var(--warning); border-radius: 2px; }
        .section-title { color: var(--warning); font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .section-desc { color: var(--text-muted); font-size: 13px; margin-left: 18px; }
        .grid-2col { display: grid; grid-template-columns: 1fr 350px; gap: 24px; margin-top: 10px; }
        .card { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; overflow: hidden; }
        .card-header { background: var(--bg-base); padding: 16px 20px; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; }
        .card-header-title { color: var(--warning); font-size: 13px; font-weight: 700; text-transform: uppercase; display: flex; align-items: center; gap: 10px; }
        .card-body { padding: 20px; }

        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; color: var(--text-muted); margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group label .required { color: var(--danger); }
        .form-control { width: 100%; padding: 10px 14px; background: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; color: var(--text-main); font-size: 14px; outline: none; transition: 0.2s; font-family: inherit; }
        .form-control:focus { border-color: var(--primary); }
        .form-control::placeholder { color: var(--text-dim); }
        textarea.form-control { min-height: 100px; resize: vertical; }

        .btn { display: inline-flex; align-items: center; gap: 8px; padding: 10px 24px; border: none; border-radius: 6px; font-weight: 600; font-size: 13px; cursor: pointer; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); text-decoration: none; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 14px rgba(0,0,0,0.15); }
        .btn:active { transform: translateY(0); }
        .btn-gold { background: var(--warning); color: #151521; }
        .btn-gold:hover { background: #e6b800; }
        .btn-secondary { background: #3f4254; color: #fff; }
        .btn-secondary:hover { background: #4b4f63; }
        .btn-sm { padding: 6px 12px; font-size: 12px; border-radius: 4px; }
        .btn-danger { background: rgba(239, 68, 68, 0.15); color: var(--danger); border: 1px solid var(--danger); }
        .btn-danger:hover { background: var(--danger); color: #fff; }
        .btn-navy { background: rgba(59, 130, 246, 0.15); color: var(--info); border: 1px solid var(--info); }
        .btn-navy:hover { background: var(--info); color: #fff; }
        .btn-row { display: flex; gap: 10px; margin-top: 10px; flex-wrap: wrap; }

        .alert { display: flex; align-items: center; gap: 10px; padding: 12px 16px; border-radius: 6px; margin-top: 14px; font-size: 13px; }
        .alert-error { background: rgba(239, 68, 68, 0.1); border: 1px solid var(--danger); color: var(--danger); }
        .alert-success { background: rgba(32, 212, 137, 0.1); border: 1px solid var(--primary); color: var(--primary); }

        .table-wrap { margin-top: 10px; }
        .table-toolbar { display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; border-bottom: 1px solid var(--border-color); flex-wrap: wrap; gap: 10px; }
        .table-result-count { font-size: 13px; color: var(--text-muted); }
        .table-result-count strong { color: var(--text-main); }
        table { width: 100%; border-collapse: collapse; }
        th { padding: 12px 16px; text-align: left; font-size: 10px; font-weight: 700; color: var(--text-dim); text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 1px solid var(--border-color); }
        td { padding: 12px 16px; border-bottom: 1px solid var(--border-color); font-size: 13px; color: var(--text-main); vertical-align: middle; }
        tr:hover td { background: var(--bg-hover); }
        .id-badge { display: inline-flex; align-items: center; justify-content: center; width: 30px; height: 30px; border-radius: 6px; background: var(--border-color); font-size: 12px; font-weight: 700; color: var(--text-main); }
        .id-badge.first { background: var(--warning); color: #151521; }
        .id-badge.second { background: var(--info); color: #fff; }
        .product-name { font-weight: 600; color: var(--text-main); }
        .product-meta { font-size: 11px; color: var(--text-dim); }
        .desc-text { color: var(--text-muted); font-size: 12px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .desc-empty { color: var(--text-dim); font-style: italic; font-size: 12px; }
        .status-badge { display: inline-flex; align-items: center; gap: 6px; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .status-badge.active { background: rgba(32, 212, 137, 0.1); color: var(--primary); border: 1px solid var(--primary); }
        .status-badge.warn { background: rgba(250, 204, 21, 0.1); color: var(--warning); border: 1px solid var(--warning); }
        .status-badge.red { background: rgba(239, 68, 68, 0.1); color: var(--danger); border: 1px solid var(--danger); }
        .action-cell { display: flex; gap: 6px; flex-wrap: wrap; }
        .inline-form { display: inline; }

        .empty-state { padding: 60px 20px; text-align: center; color: var(--text-dim); }
        .empty-state svg { width: 48px; height: 48px; margin: 0 auto 16px; opacity: 0.3; display: block; }
        .empty-title { font-size: 16px; font-weight: 600; color: var(--text-muted); margin-bottom: 6px; }

        .info-item { display: flex; align-items: flex-start; gap: 12px; padding: 8px 0; border-bottom: 1px solid var(--border-color); }
        .info-item:last-child { border-bottom: none; }
        .info-icon { width: 24px; height: 24px; border-radius: 6px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .info-icon.gold { background: rgba(250, 204, 21, 0.15); }
        .info-icon.gold svg { color: var(--warning); }
        .info-icon.red { background: rgba(239, 68, 68, 0.15); }
        .info-icon.red svg { color: var(--danger); }
        .info-text { font-size: 12px; color: var(--text-muted); line-height: 1.5; }
        .info-text strong { color: var(--text-main); }

        .stat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--border-color); }
        .stat-box { background: var(--bg-input); border-radius: 8px; padding: 14px; text-align: center; }
        .stat-number { font-size: 28px; font-weight: 800; color: var(--text-main); }
        .stat-label { font-size: 10px; font-weight: 600; color: var(--text-dim); text-transform: uppercase; letter-spacing: 0.5px; margin-top: 2px; }
        .stat-box.gold .stat-number { color: var(--warning); }

        .table-footer { display: flex; justify-content: space-between; align-items: center; padding: 12px 20px; border-top: 1px solid var(--border-color); font-size: 12px; color: var(--text-dim); }
        .pagination { display: flex; gap: 4px; }
        .page-btn { width: 30px; height: 28px; border: 1px solid var(--border-color); background: transparent; color: var(--text-muted); border-radius: 4px; cursor: pointer; display: flex; align-items: center; justify-content: center; font-size: 13px; transition: 0.2s; }
        .page-btn:hover { border-color: var(--warning); color: var(--text-main); }
        .page-btn.active { background: var(--warning); border-color: var(--warning); color: #151521; font-weight: 700; }
    </style>
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
                <div class="menu-item-left"><span style="font-size: 16px;">⤴</span> Tổng quan hệ thống</div>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🏪</span> Duyệt Shop</div>
            </a>

            <div class="menu-title" style="margin-top: 25px;">QUẢN LÝ DỮ LIỆU</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">👤</span> Người dùng</div>
            </a>
            <a href="${pageContext.request.contextPath}/Category" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">📂</span> Danh mục món ăn</div>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="menu-item active">
                <div class="menu-item-left"><span style="font-size: 16px;">🍽️</span> Sản phẩm</div>
            </a>
        </div>
    </aside>

    <div class="main-content">

        <header class="top-header">
            <h2>QUẢN LÝ SẢN PHẨM</h2>
            <div class="header-actions">
                <input type="text" class="search-bar" placeholder="Tìm kiếm sản phẩm...">
                <button type="button" class="theme-toggle" id="themeToggleBtn" title="Chuyển đổi giao diện">🌓</button>
                <div class="avatar">AD</div>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><span style="font-size: 14px;">🚪</span> Đăng xuất</a>
            </div>
        </header>

        <div class="content-wrapper">

            <div class="section-header">
                <div>
                    <div class="section-title-wrapper">
                        <div class="indicator"></div>
                        <h1 class="section-title">QUẢN LÝ SẢN PHẨM</h1>
                    </div>
                    <p class="section-desc">Quản lý danh sách sản phẩm trong hệ thống.</p>
                </div>
            </div>
<c:if test="${param.success == 'create'}">
    <div class="alert alert-success">✅ Tạo sản phẩm thành công!</div>
</c:if>
<c:if test="${param.success == 'update'}">
    <div class="alert alert-success">✅ Cập nhật sản phẩm thành công!</div>
</c:if>
<c:if test="${param.success == 'delete'}">
    <div class="alert alert-success">✅ Xóa sản phẩm thành công!</div>
</c:if>
            <div class="grid-2col">

                <div class="card">
                    <div class="card-header">
                        <div class="card-header-title">
                            <c:choose>
                                <c:when test="${not empty productSua}">✏️ CẬP NHẬT SẢN PHẨM</c:when>
                                <c:otherwise>➕ TẠO SẢN PHẨM MỚI</c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${not empty productSua}">
                            <a href="${pageContext.request.contextPath}/product" style="font-size:12px;color:var(--text-dim);text-decoration:none;">← Hủy sửa</a>
                        </c:if>
                    </div>
                    <div class="card-body">
                        <c:set var="formProduct" value="${not empty productSua ? productSua : productForm}"/>
                        <form action="${pageContext.request.contextPath}/product" method="post">
                            <c:choose>
                                <c:when test="${not empty productSua}">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="${productSua.id}">
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" name="action" value="create">
                                </c:otherwise>
                            </c:choose>

                            <div class="form-group">
                                <label for="productname">Tên sản phẩm <span class="required">*</span></label>
                                <input type="text" id="productname" name="productname" class="form-control"
                                       value="${fn:escapeXml(formProduct.productname)}"
                                       placeholder="Ví dụ: Cơm tấm sườn bì chả..." required>
                            </div>

                            <div class="form-group">
                                <label for="shopid">Shop ID <span class="required">*</span></label>
                                <input type="number" id="shopid" name="shopid" class="form-control"
                                       value="${formProduct.shopid}"
                                       placeholder="Nhập ID shop..." min="1" required>
                            </div>

                            <div class="form-group">
                                <label for="categoryid">Category ID <span class="required">*</span></label>
                                <input type="number" id="categoryid" name="categoryid" class="form-control"
                                       value="${formProduct.categoryid}"
                                       placeholder="Nhập ID category..." min="1" required>
                            </div>

                            <div class="form-group">
                                <label for="price">Giá bán <span class="required">*</span></label>
                                <input type="number" id="price" name="price" class="form-control"
                                       value="${formProduct.price}"
                                       placeholder="0" min="0" step="0.01" required>
                            </div>

                            <div class="form-group">
                                <label for="soldQuantity">Số lượng tồn</label>
                                <input type="number" id="stock_quantity" name="stock_quantity" class="form-control"
                                       value="${formProduct.soldQuantity}"
                                       placeholder="0" min="0">
                            </div>

                            <div class="form-group">
                                <label for="soldCount">Đã bán</label>
                                <input type="number" id="soldCount" name="soldCount" class="form-control"
                                       value="${formProduct.soldCount}"
                                       placeholder="0" min="0">
                            </div>

                            <div class="form-group">
                                <label for="status">Trạng thái</label>
                                <select id="status" name="status" class="form-control">
                                    <option value="ACTIVE" ${fn:toUpperCase(formProduct.staTus) == 'ACTIVE' ? 'selected' : ''}>Đang bán</option>
                                    <option value="HIDDEN" ${fn:toUpperCase(formProduct.staTus) == 'HIDDEN' ? 'selected' : ''}>Tạm ẩn</option>
                                    <option value="OUT_OF_STOCK" ${fn:toUpperCase(formProduct.staTus) == 'OUT_OF_STOCK' ? 'selected' : ''}>Hết hàng</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="description">Mô tả</label>
                                <textarea id="description" name="description" class="form-control"
                                          placeholder="Mô tả ngắn về sản phẩm..."><c:out value="${formProduct.description}"/></textarea>
                            </div>

                            <c:if test="${not empty loi}">
                                <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
                            </c:if>

                            <div class="btn-row">
                                <button type="submit" class="btn btn-gold">
                                    <c:choose>
                                        <c:when test="${not empty productSua}">💾 Lưu cập nhật</c:when>
                                        <c:otherwise>+ Tạo mới</c:otherwise>
                                    </c:choose>
                                </button>
                                <c:if test="${not empty productSua}">
                                    <a href="${pageContext.request.contextPath}/product" class="btn btn-secondary">✕ Hủy</a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <div class="card-header-title">📋 HƯỚNG DẪN</div>
                    </div>
                    <div class="card-body">
                        <p style="font-size:13px;color:var(--text-muted);line-height:1.7;margin-bottom:14px;">
                            Sản phẩm gắn với 1 shop và 1 category. Hệ thống sẽ kiểm tra shop/category có tồn tại trước khi lưu.
                        </p>

                        <div class="info-item">
                            <div class="info-icon gold">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M20 6L9 17l-5-5"/></svg>
                            </div>
                            <div class="info-text">Tên sản phẩm nên <strong>rõ nghĩa</strong> và dễ tìm kiếm</div>
                        </div>
                        <div class="info-item">
                            <div class="info-icon gold">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M20 6L9 17l-5-5"/></svg>
                            </div>
                            <div class="info-text">Giá bán phải là <strong>số dương</strong></div>
                        </div>
                        <div class="info-item">
                            <div class="info-icon red">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17" stroke-width="2.5"/></svg>
                            </div>
                            <div class="info-text">Xóa sản phẩm sẽ <strong>ẩn khỏi danh sách</strong> nếu bảng có cột xóa mềm</div>
                        </div>

                        <div class="stat-grid">
                            <div class="stat-box">
                                <div class="stat-number">${tongSanPham}</div>
                                <div class="stat-label">Tổng sản phẩm</div>
                            </div>
                            <div class="stat-box gold">
                                <div class="stat-number">${sanPhamDangBan}</div>
                                <div class="stat-label">Đang bán</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card table-wrap">
                <div class="table-toolbar">
                    <div class="table-result-count">
                        Danh sách sản phẩm — <strong>${fn:length(danhsach)}</strong> bản ghi
                    </div>
                    <a href="${pageContext.request.contextPath}/product" class="btn btn-gold" style="padding:8px 16px;font-size:12px;border-radius:6px;">
                        ➕ Thêm mới
                    </a>
                </div>

                <div style="overflow-x:auto;">
                    <table>
                        <thead>
                            <tr>
                                <th style="width:60px;">ID</th>
                                <th>Sản phẩm</th>
                                <th style="width:90px;">Shop ID</th>
                                <th style="width:110px;">Category ID</th>
                                <th style="width:120px;">Giá</th>
                                <th style="width:110px;">Tồn</th>
                                <th style="width:100px;">Đã bán</th>
                                <th style="width:130px;">Trạng thái</th>
                                <th style="width:150px;">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty danhsach}">
                                    <c:forEach var="product" items="${danhsach}" varStatus="loop">
                                        <tr>
                                            <td>
                                                <div class="id-badge ${loop.index == 0 ? 'first' : loop.index == 1 ? 'second' : ''}">
                                                    <c:out value="${product.id}"/>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="product-name"><c:out value="${product.productname}"/></div>
                                                <div class="product-meta">#product-<c:out value="${product.id}"/></div>
                                                <c:choose>
                                                    <c:when test="${not empty product.description}">
                                                        <div class="desc-text" style="margin-top:6px;"><c:out value="${product.description}"/></div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="desc-empty" style="margin-top:6px;">Chưa có mô tả</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><c:out value="${product.shopid}"/></td>
                                            <td><c:out value="${product.categoryid}"/></td>
                                            <td><c:out value="${product.price}"/></td>
                                            <td><c:out value="${product.soldQuantity}"/></td>
                                            <td><c:out value="${product.soldCount}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${fn:toUpperCase(product.staTus) eq 'ACTIVE' || fn:toUpperCase(product.staTus) eq 'AVAILABLE' || fn:toUpperCase(product.staTus) eq 'PUBLISHED'}">
                                                        <span class="status-badge active">Đang bán</span>
                                                    </c:when>
                                                    <c:when test="${fn:toUpperCase(product.staTus) eq 'OUT_OF_STOCK'}">
                                                        <span class="status-badge warn">Hết hàng</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge red"><c:out value="${product.staTus}"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-cell">
                                                    <a href="${pageContext.request.contextPath}/product?action=edit&id=${product.id}"
                                                       class="btn btn-sm btn-navy" title="Sửa">
                                                        ✏️ Sửa
                                                    </a>
                                                    <form class="inline-form"
                                                          action="${pageContext.request.contextPath}/product"
                                                          method="post"
                                                          onsubmit="return confirm('Xóa sản phẩm «${fn:escapeXml(product.productname)}»?')">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${product.id}">
                                                        <button type="submit" class="btn btn-sm btn-danger" title="Xóa">
                                                            🗑️ Xóa
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="9">
                                            <div class="empty-state">
                                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"/>
                                                    <line x1="7" y1="7" x2="7.01" y2="7" stroke-width="2.5"/>
                                                </svg>
                                                <div class="empty-title">Chưa có sản phẩm nào</div>
                                                <div style="font-size:13px;color:var(--text-dim);">Hãy tạo sản phẩm đầu tiên bằng form bên trên.</div>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="table-footer">
                    <span>Hiển thị 1–${fn:length(danhsach)} trong tổng số ${fn:length(danhsach)} sản phẩm</span>
                    <div class="pagination">
                        <button class="page-btn">‹</button>
                        <button class="page-btn active">1</button>
                        <button class="page-btn">›</button>
                    </div>
                </div>
            </div>

        </div>
    </div>

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

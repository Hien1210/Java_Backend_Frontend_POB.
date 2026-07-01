<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%-- DEBUG --%>
<%
    Object danhsach = request.getAttribute("danhsach");
    Object danhsachLoai = request.getAttribute("danhsachLoai");
    System.out.println("=== JSP DEBUG ===");
    System.out.println("danhsach: " + danhsach);
    System.out.println("danhsachLoai: " + danhsachLoai);
    if (danhsach != null) {
        java.util.List<?> list = (java.util.List<?>) danhsach;
        System.out.println("danhsach size: " + list.size());
    }
%>
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
    <title>Quản lý Sản Phẩm - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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
        .search-bar{background:var(--bg-input);border:1px solid var(--border);border-radius:10px;padding:9px 16px;color:var(--text-main);width:240px;outline:none;font-size:13px;}
        .search-bar:focus{border-color:var(--primary);}
        .avatar{width:38px;height:38px;background:linear-gradient(135deg,var(--warning),var(--primary));border-radius:50%;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:700;font-size:14px;}
        .btn-logout{display:flex;align-items:center;gap:6px;padding:9px 16px;border-radius:10px;background:var(--accent-lt);color:var(--accent);font-size:13px;font-weight:700;border:1px solid transparent;transition:all .2s;}
        .btn-logout:hover{background:var(--accent);color:#fff;transform:translateY(-1px);}

        .content-wrapper{padding:32px;overflow-y:auto;flex:1;}

        /* ── ALERTS ── */
        .alert{padding:13px 18px;border-radius:10px;margin-bottom:20px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;}
        .alert-success{background:var(--success-lt);border:1px solid var(--success);color:#1E8449;}
        .alert-error{background:var(--accent-lt);border:1px solid var(--accent);color:var(--accent);}

        /* ── MINI STATS ── */
        .mini-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-bottom:24px;}
        .mini-stat{background:var(--bg-panel);border:1px solid var(--border);border-radius:14px;padding:16px 18px;display:flex;align-items:center;gap:12px;box-shadow:var(--sh-sm);transition:transform .2s;}
        .mini-stat:hover{transform:translateY(-2px);box-shadow:var(--sh-md);}
        .mini-stat-icon{width:42px;height:42px;border-radius:11px;display:flex;align-items:center;justify-content:center;font-size:19px;flex-shrink:0;}
        .mini-stat-icon.orange{background:var(--primary-lt);}
        .mini-stat-icon.green{background:var(--success-lt);}
        .mini-stat-icon.yellow{background:var(--warning-lt);}
        .mini-stat-icon.red{background:var(--accent-lt);}
        .mini-stat-num{font-size:22px;font-weight:800;color:var(--text-main);}
        .mini-stat-label{font-size:11px;color:var(--text-muted);font-weight:600;text-transform:uppercase;}

        /* ── BTN ── */
        .btn{display:inline-flex;align-items:center;gap:7px;padding:10px 20px;border:none;border-radius:10px;font-weight:700;font-size:13px;cursor:pointer;transition:all .2s cubic-bezier(.4,0,.2,1);}
        .btn:hover{transform:translateY(-2px);}
        .btn:active{transform:translateY(0);}
        .btn-primary{background:var(--primary);color:#fff;box-shadow:0 4px 12px rgba(255,122,48,.25);}
        .btn-primary:hover{background:var(--primary-dk);}
        .btn-secondary{background:var(--bg-input);border:1px solid var(--border);color:var(--text-muted);}
        .btn-secondary:hover{background:var(--border);color:var(--text-main);}
        .btn-sm{padding:6px 12px;font-size:12px;border-radius:8px;}
        .btn-edit{background:rgba(255,183,3,.15);color:#B07700;border:1px solid var(--warning);}
        .btn-edit:hover{background:var(--warning);color:#3A2A1E;}
        .btn-delete{background:var(--accent-lt);color:var(--accent);border:1px solid var(--accent);}
        .btn-delete:hover{background:var(--accent);color:#fff;}
        .btn-info{background:var(--info-lt);color:var(--info);border:1px solid var(--info);}
        .btn-info:hover{background:var(--info);color:#fff;}

        /* ── PRODUCT TABLE ── */
        .table-card{background:var(--bg-panel);border:1px solid var(--border);border-radius:16px;box-shadow:var(--sh-sm);overflow:hidden;}
        .table-toolbar{padding:16px 20px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;}
        .toolbar-left{display:flex;align-items:center;gap:12px;flex-wrap:wrap;}
        .filter-select{padding:8px 12px;background:var(--bg-input);border:1px solid var(--border);border-radius:8px;font-size:13px;color:var(--text-main);outline:none;cursor:pointer;}
        .filter-select:focus{border-color:var(--primary);}
        .search-input{padding:8px 14px;background:var(--bg-input);border:1px solid var(--border);border-radius:8px;font-size:13px;color:var(--text-main);outline:none;width:200px;transition:border-color .2s;}
        .search-input:focus{border-color:var(--primary);}
        .result-count{font-size:12px;color:var(--text-dim);}
        .result-count strong{color:var(--text-main);}

        .table-wrap{overflow-x:auto;}
        table{width:100%;border-collapse:collapse;text-align:left;}
        th{padding:12px 16px;font-size:11px;color:var(--text-dim);text-transform:uppercase;font-weight:700;border-bottom:2px solid var(--border);white-space:nowrap;}
        td{padding:13px 16px;border-bottom:1px solid var(--border);font-size:13.5px;color:var(--text-main);vertical-align:middle;}
        tr:last-child td{border-bottom:none;}
        tr:hover td{background:var(--bg-hover);}

        .product-img{width:46px;height:46px;border-radius:10px;object-fit:cover;background:var(--bg-input);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0;}
        .product-info{display:flex;align-items:center;gap:12px;}
        .product-name{font-weight:700;color:var(--text-main);}
        .product-category{font-size:11px;color:var(--text-muted);margin-top:2px;background:var(--bg-input);padding:2px 8px;border-radius:6px;display:inline-block;}
        .product-desc{font-size:11px;color:var(--text-muted);margin-top:3px;max-width:180px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}

        .price-main{font-weight:800;color:var(--primary-dk);font-size:14px;}
        .price-note{font-size:11px;color:var(--text-dim);margin-top:2px;}

        /* Size chips */
        .size-list{display:flex;flex-wrap:wrap;gap:5px;}
        .size-chip{display:inline-flex;align-items:center;gap:4px;padding:3px 9px;border-radius:8px;font-size:11px;font-weight:700;background:var(--primary-lt);color:var(--primary-dk);border:1px solid rgba(255,122,48,.3);}
        .size-chip .size-price{color:var(--text-muted);font-weight:500;}

        .badge{display:inline-flex;align-items:center;gap:5px;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700;text-transform:uppercase;}
        .badge-active{background:var(--success-lt);color:#1E8449;}
        .badge-hidden{background:var(--accent-lt);color:var(--accent);}
        .badge-out{background:var(--warning-lt);color:#B07700;}
        .badge-inactive{background:rgba(156,133,121,.12);color:var(--text-muted);}

        .stock-num{font-weight:700;}
        .stock-num.low{color:var(--accent);}
        .stock-num.ok{color:#1E8449;}

        .action-cell{display:flex;gap:6px;flex-wrap:wrap;justify-content:center;}
        .inline-form{display:inline;}

        .table-footer{padding:14px 20px;border-top:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;font-size:12px;color:var(--text-dim);}

        .empty-state{text-align:center;padding:56px 20px;color:var(--text-dim);}
        .empty-state .empty-icon{font-size:46px;margin-bottom:14px;}
        .empty-state p{font-size:14px;line-height:1.8;}
        .empty-state a{color:var(--primary);font-weight:700;}

        /* ── MODAL (Thêm / Sửa sản phẩm) ── */
        .modal-backdrop{position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(58,42,30,.5);backdrop-filter:blur(4px);display:flex;align-items:center;justify-content:center;z-index:100;opacity:0;pointer-events:none;transition:all .3s cubic-bezier(.4,0,.2,1);}
        .modal-backdrop.active{opacity:1;pointer-events:auto;}
        .modal-content{background:var(--bg-panel);border:1px solid var(--border);border-radius:20px;width:720px;max-width:94vw;max-height:90vh;overflow-y:auto;box-shadow:var(--sh-md);transform:scale(.93) translateY(20px);transition:all .3s cubic-bezier(.34,1.56,.64,1);}
        .modal-backdrop.active .modal-content{transform:scale(1) translateY(0);}
        .modal-header{padding:20px 26px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;position:sticky;top:0;background:var(--bg-panel);z-index:1;}
        .modal-title{color:var(--primary-dk);font-size:16px;font-weight:800;display:flex;align-items:center;gap:8px;}
        .modal-close{background:var(--bg-input);border:1px solid var(--border);color:var(--text-muted);font-size:18px;cursor:pointer;border-radius:8px;width:34px;height:34px;display:flex;align-items:center;justify-content:center;transition:all .2s;}
        .modal-close:hover{background:var(--accent-lt);color:var(--accent);border-color:var(--accent);}
        .modal-body{padding:26px;}

        /* Form grid trong modal */
        .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
        .form-full{grid-column:1/-1;}
        .form-group{display:flex;flex-direction:column;gap:6px;}
        .form-group label{font-size:12px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.4px;}
        .form-group label .req{color:var(--accent);}
        .form-control{width:100%;padding:11px 14px;background:var(--bg-input);border:1px solid var(--border);border-radius:10px;font-size:14px;color:var(--text-main);outline:none;transition:border-color .2s,box-shadow .2s;font-family:inherit;}
        .form-control:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(255,122,48,.12);}
        .form-control::placeholder{color:var(--text-dim);}
        select.form-control{cursor:pointer;}
        textarea.form-control{min-height:80px;resize:vertical;}

        /* Size section trong modal */
        .size-section{border:1px solid var(--border);border-radius:12px;overflow:hidden;}
        .size-section-header{padding:12px 16px;background:var(--bg-input);display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid var(--border);}
        .size-section-title{font-size:12px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.4px;}
        .size-rows{padding:12px;}
        .size-row{display:grid;grid-template-columns:1fr 1fr auto;gap:8px;align-items:center;margin-bottom:10px;}
        .size-row:last-child{margin-bottom:0;}
        .size-input{padding:9px 12px;background:var(--bg-input);border:1px solid var(--border);border-radius:8px;font-size:13px;color:var(--text-main);outline:none;width:100%;transition:border-color .2s;}
        .size-input:focus{border-color:var(--primary);box-shadow:0 0 0 2px rgba(255,122,48,.1);}
        .size-input::placeholder{color:var(--text-dim);}
        .btn-remove-size{width:32px;height:32px;border-radius:8px;background:var(--accent-lt);color:var(--accent);border:1px solid var(--accent);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:16px;transition:all .2s;flex-shrink:0;}
        .btn-remove-size:hover{background:var(--accent);color:#fff;}
        .btn-add-size{margin-top:8px;padding:8px 16px;background:var(--primary-lt);color:var(--primary-dk);border:1px dashed var(--primary);border-radius:8px;font-size:12px;font-weight:700;cursor:pointer;width:100%;transition:all .2s;}
        .btn-add-size:hover{background:var(--primary);color:#fff;border-style:solid;}

        .modal-footer{padding:20px 26px;border-top:1px solid var(--border);display:flex;justify-content:flex-end;gap:12px;}

        /* ── IMAGE PREVIEW ── */
        .img-preview-wrap{position:relative;}
        .img-preview{width:100%;height:120px;border:2px dashed var(--border);border-radius:12px;display:flex;align-items:center;justify-content:center;margin-top:8px;overflow:hidden;background:var(--bg-input);}
        .img-preview img{width:100%;height:100%;object-fit:cover;}
        .img-preview .placeholder{font-size:28px;color:var(--text-dim);}

        /* Sort indicator */
        .sort-header{cursor:pointer;user-select:none;}
        .sort-header:hover{color:var(--primary-dk);}
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
        <h2>🍽️ QUẢN LÝ SẢN PHẨM</h2>
        <div class="header-actions">
            <input type="text" class="search-bar"
                   placeholder="🔍 Tìm tên sản phẩm..."
                   oninput="filterProducts(this.value)">
            <a href="${pageContext.request.contextPath}/shop/products?action=trash" class="btn-logout" style="background:rgba(230,57,70,.10);color:#E63946;border:1px solid #E63946;">🗑️ Thùng rác</a>
            <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content-wrapper">

        <%-- Thông báo --%>
        <c:if test="${param.success eq 'create'}">
            <div class="alert alert-success">✅ Thêm sản phẩm thành công!</div>
        </c:if>
        <c:if test="${param.success eq 'update'}">
            <div class="alert alert-success">✅ Cập nhật sản phẩm thành công!</div>
        </c:if>
        <c:if test="${param.success eq 'delete'}">
            <div class="alert alert-success">✅ Xóa sản phẩm thành công!</div>
        </c:if>
        <c:if test="${not empty loi}">
            <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <%-- Mini Stats --%>
        <div class="mini-stats">
            <div class="mini-stat">
                <div class="mini-stat-icon orange">🍽️</div>
                <div>
                    <div class="mini-stat-num">${fn:length(danhsach)}</div>
                    <div class="mini-stat-label">Tổng sản phẩm</div>
                </div>
            </div>
            <div class="mini-stat">
                <div class="mini-stat-icon green">✅</div>
                <div>
                    <div class="mini-stat-num">${soDangBan}</div>
                    <div class="mini-stat-label">Đang bán</div>
                </div>
            </div>
            <div class="mini-stat">
                <div class="mini-stat-icon yellow">⏸️</div>
                <div>
                    <div class="mini-stat-num">${soHetHang}</div>
                    <div class="mini-stat-label">Hết hàng</div>
                </div>
            </div>
            <div class="mini-stat">
                <div class="mini-stat-icon red">📈</div>
                <div>
                    <div class="mini-stat-num">${tongDaBan}</div>
                    <div class="mini-stat-label">Đã bán</div>
                </div>
            </div>
        </div>

        <%-- Bảng danh sách sản phẩm --%>
        <div class="table-card">
            <div class="table-toolbar">
                <div class="toolbar-left">
                    <select class="filter-select" onchange="filterByType(this.value)">
                        <option value="">Tất cả loại</option>
                        <c:forEach var="pt" items="${danhsachLoai}">
                            <option value="${pt.id}"><c:out value="${pt.categoryName}"/></option>
                        </c:forEach>
                    </select>
                    <select class="filter-select" onchange="filterByStatus(this.value)">
                        <option value="">Tất cả trạng thái</option>
                        <option value="ACTIVE">✅ Đang bán</option>
                        <option value="HIDDEN">🙈 Tạm ẩn</option>
                        <option value="OUT_OF_STOCK">⏸️ Hết hàng</option>
                    </select>
                    <span class="result-count">Tổng: <strong id="visibleCount">${fn:length(danhsach)}</strong> sản phẩm</span>
                </div>
                <button type="button" class="btn btn-primary" onclick="openProductModal()">
                    ➕ Thêm sản phẩm mới
                </button>
            </div>

            <c:choose>
                <c:when test="${empty danhsach}">
                    <div class="empty-state">
                        <div class="empty-icon">🍽️</div>
                        <p>Chưa có sản phẩm nào trong cửa hàng.<br>
                           <a href="javascript:void(0)" onclick="openProductModal()">Thêm sản phẩm đầu tiên ngay →</a>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-wrap">
                        <table id="productTable">
                            <thead>
                                <tr>
                                    <th style="width:18%;">Sản phẩm</th>
                                    <th style="width:12%;">Loại SP</th>
                                    <th style="width:10%;">Giá bán</th>
                                    <th style="width:20%;">Size</th>
                                    <th style="width:8%;">Tồn kho</th>
                                    <th style="width:8%;">Đã bán</th>
                                    <th style="width:10%;">Trạng thái</th>
                                    <th style="width:14%;text-align:center;">Thao tác</th>
                                </tr>
                            </thead>
                           <tbody>
                               <c:forEach var="product" items="${danhsach}">
                                   <tr data-name="${fn:toLowerCase(product.productName)}"
                                       data-type="${product.categoryId}"
                                       data-status="${fn:toUpperCase(product.staTus)}">

                                       <!-- Sản phẩm -->
                                       <td>
                                           <div class="product-info">
                                               <div class="product-img">
                                                   <c:choose>
                                                       <c:when test="${not empty product.imageUrl && product.imageUrl != 'null'}">
                                                           <img src="${product.imageUrl}" alt="${product.productName}"
                                                                onerror="this.style.display='none';this.nextSibling.style.display='flex'">
                                                           <span style="display:none">🍽️</span>
                                                       </c:when>
                                                       <c:otherwise>🍽️</c:otherwise>
                                                   </c:choose>
                                               </div>
                                               <div>
                                                   <div class="product-name"><c:out value="${product.productName}"/></div>
                                                   <c:if test="${not empty product.description}">
                                                       <div class="product-desc"><c:out value="${product.description}"/></div>
                                                   </c:if>
                                               </div>
                                           </div>
                                       </td>

                                       <!-- Loại SP -->
                                       <td>
                                           <span class="product-category">
                                               <c:out value="${product.categoryName}"/>
                                           </span>
                                       </td>

                                       <!-- Giá bán -->
                                       <td>
                                           <div class="price-main">
                                               <c:choose>
                                                   <c:when test="${not empty product.sizes && product.sizes.size() > 0}">
                                                       <fmt:formatNumber value="${product.sizes[0].price}" type="number" maxFractionDigits="0"/>đ
                                                   </c:when>
                                                   <c:otherwise>
                                                       <span style="color:var(--text-dim);">Chưa có giá</span>
                                                   </c:otherwise>
                                               </c:choose>
                                           </div>
                                       </td>

                                       <!-- Size -->
                                       <td>
                                           <c:choose>
                                               <c:when test="${not empty product.sizes}">
                                                   <div class="size-list">
                                                       <c:forEach var="sz" items="${product.sizes}">
                                                           <span class="size-chip">
                                                               ${sz.sizeName}
                                                               <span class="size-price"><fmt:formatNumber value="${sz.price}" type="number" maxFractionDigits="0"/>đ</span>
                                                           </span>
                                                       </c:forEach>
                                                   </div>
                                               </c:when>
                                               <c:otherwise>
                                                   <span style="font-size:12px;color:var(--text-dim);">Không có size</span>
                                               </c:otherwise>
                                           </c:choose>
                                       </td>

                                       <!-- Tồn kho -->
                                       <td>
                                           <span class="stock-num ${product.stockQuantity <= 5 ? 'low' : 'ok'}">
                                               ${product.stockQuantity}
                                           </span>
                                       </td>

                                       <!-- Đã bán -->
                                       <td>
                                           <strong>${product.soldCount}</strong>
                                       </td>

                                       <!-- Trạng thái -->
                                       <td>
                                           <c:choose>
                                               <c:when test="${fn:toUpperCase(product.staTus) == 'ACTIVE'}">
                                                   <span class="badge badge-active">✅ Đang bán</span>
                                               </c:when>
                                               <c:when test="${fn:toUpperCase(product.staTus) == 'HIDDEN'}">
                                                   <span class="badge badge-hidden">🙈 Tạm ẩn</span>
                                               </c:when>
                                               <c:when test="${fn:toUpperCase(product.staTus) == 'OUT_OF_STOCK'}">
                                                   <span class="badge badge-out">⏸️ Hết hàng</span>
                                               </c:when>
                                               <c:otherwise>
                                                   <span class="badge badge-inactive"><c:out value="${product.staTus}"/></span>
                                               </c:otherwise>
                                           </c:choose>
                                       </td>

                                       <!-- Thao tác -->
                                       <td>
                                           <div class="action-cell">
                                               <a href="${pageContext.request.contextPath}/shop/products?action=edit&id=${product.id}"
                                                  class="btn btn-sm btn-edit">✏️ Sửa</a>
                                               <form class="inline-form"
                                                     action="${pageContext.request.contextPath}/shop/products"
                                                     method="post"
                                                     onsubmit="return confirm('Xóa sản phẩm «${fn:escapeXml(product.productName)}»?')">
                                                   <input type="hidden" name="action" value="delete">
                                                   <input type="hidden" name="id" value="${product.id}">
                                                   <button type="submit" class="btn btn-sm btn-delete">🗑️</button>
                                               </form>
                                           </div>
                                       </td>
                                   </tr>
                               </c:forEach>

                               <c:if test="${empty danhsach}">
                                   <tr>
                                       <td colspan="8" style="text-align:center;padding:40px;color:var(--text-dim);">
                                           <div style="font-size:46px;margin-bottom:14px;">🍽️</div>
                                           <p style="font-size:14px;">Chưa có sản phẩm nào trong cửa hàng.</p>
                                           <p style="font-size:13px;margin-top:8px;">
                                               <a href="javascript:void(0)" onclick="openProductModal()" style="color:var(--primary);font-weight:700;">
                                                   Thêm sản phẩm đầu tiên ngay →
                                               </a>
                                           </p>
                                       </td>
                                   </tr>
                               </c:if>
                           </tbody>
                        </table>
                    </div>
                    <div class="table-footer">
                        <span>Hiển thị <strong id="showCount">${fn:length(danhsach)}</strong> sản phẩm</span>
                        <span style="color:var(--text-dim);font-size:11px;">💡 Click ✏️ Sửa để quản lý các size của từng sản phẩm</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<%-- ── MODAL THÊM / SỬA SẢN PHẨM ── --%>
<div class="modal-backdrop" id="productModal">
    <div class="modal-content">
        <div class="modal-header">
            <div class="modal-title">
                <c:choose>
                    <c:when test="${not empty productSua}">✏️ Cập nhật sản phẩm</c:when>
                    <c:otherwise>➕ Thêm sản phẩm mới</c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="modal-close" onclick="closeProductModal()">✕</button>
        </div>
        <div class="modal-body">
            <form action="${pageContext.request.contextPath}/shop/products" method="post" id="productForm">
                <c:choose>
                    <c:when test="${not empty productSua}">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${productSua.id}">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="action" value="create">
                    </c:otherwise>
                </c:choose>

                <div class="form-grid">
                    <%-- Tên sản phẩm --%>
                    <div class="form-group form-full">
                        <label for="productName">Tên sản phẩm <span class="req">*</span></label>
                        <input type="text" id="productName" name="productName" class="form-control"
                               value="${fn:escapeXml(productSua.productName)}"
                               placeholder="Ví dụ: Cơm tấm sườn bì chả, Bún bò Huế..."
                               required autofocus>
                    </div>

                    <%-- Loại sản phẩm --%>
                    <div class="form-group">
                        <label for="productTypeId">Loại sản phẩm <span class="req">*</span></label>
                        <select id="productTypeId" name="productTypeId" class="form-control" required>
                            <option value="">-- Chọn loại --</option>
                            <c:forEach var="pt" items="${danhsachLoai}">
                                <option value="${pt.id}"
                                    ${productSua.categoryId == pt.id ? 'selected' : ''}>
                                    <c:out value="${pt.categoryName}"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <%-- Tồn kho --%>
                    <div class="form-group">
                        <label for="stockQuantity">Số lượng tồn kho</label>
                        <input type="number" id="stockQuantity" name="stockQuantity" class="form-control"
                               value="${not empty productSua.stockQuantity ? productSua.stockQuantity : 0}"
                               placeholder="0" min="0">
                    </div>

                    <%-- Đã bán --%>
                    <div class="form-group">
                        <label for="soldCount">Số đã bán</label>
                        <input type="number" id="soldCount" name="soldCount" class="form-control"
                               value="${not empty productSua.soldCount ? productSua.soldCount : 0}"
                               placeholder="0" min="0">
                    </div>

                    <%-- Trạng thái --%>
                    <div class="form-group">
                        <label for="status">Trạng thái</label>
                        <select id="status" name="status" class="form-control">
                            <option value="ACTIVE"        ${fn:toUpperCase(productSua.staTus) == 'ACTIVE'        ? 'selected' : ''}>✅ Đang bán</option>
                            <option value="HIDDEN"        ${fn:toUpperCase(productSua.staTus) == 'HIDDEN'        ? 'selected' : ''}>🙈 Tạm ẩn</option>
                            <option value="OUT_OF_STOCK"  ${fn:toUpperCase(productSua.staTus) == 'OUT_OF_STOCK'  ? 'selected' : ''}>⏸️ Hết hàng</option>
                        </select>
                    </div>

                    <%-- Ảnh sản phẩm --%>
                    <div class="form-group form-full">
                        <label for="imageUrl">URL ảnh sản phẩm</label>
                        <input type="text" id="imageUrl" name="imageUrl" class="form-control"
                               value="${fn:escapeXml(productSua.imageUrl)}"
                               placeholder="https://..."
                               oninput="previewImage(this.value)">
                        <div class="img-preview" id="imgPreview">
                            <c:choose>
                                <c:when test="${not empty productSua.imageUrl}">
                                    <img src="${productSua.imageUrl}" alt="Preview">
                                </c:when>
                                <c:otherwise><span class="placeholder">🖼️</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%-- Mô tả --%>
                    <div class="form-group form-full">
                        <label for="description">Mô tả sản phẩm</label>
                        <textarea id="description" name="description" class="form-control"
                                  placeholder="Mô tả ngắn về nguyên liệu, hương vị..."><c:out value="${productSua.description}"/></textarea>
                    </div>

                    <%-- SIZE SECTION --%>
                    <div class="form-group form-full">
                        <label>Size / Khẩu phần (tuỳ chọn)</label>
                        <div class="size-section">
                            <div class="size-section-header">
                                <span class="size-section-title">Danh sách size</span>
                                <span style="font-size:11px;color:var(--text-dim);">Điều chỉnh giá theo size</span>
                            </div>
                            <div class="size-rows" id="sizeRows">
                                <%-- Render các size hiện có khi Edit --%>
                                <c:choose>
                                    <c:when test="${not empty productSua.sizes}">
                                        <c:forEach var="sz" items="${productSua.sizes}" varStatus="loop">
                                            <div class="size-row">
                                                <input type="text" name="sizeName[]" class="size-input"
                                                       value="${fn:escapeXml(sz.sizeName)}"
                                                       placeholder="Tên size (S, M, L...)">
                                                <input type="number" name="sizePrice[]" class="size-input"
                                                       value="${sz.price}"
                                                       placeholder="Giá size (đ)" min="0" step="500">
                                                <button type="button" class="btn-remove-size" onclick="removeSize(this)">×</button>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- Ô size mặc định khi tạo mới --%>
                                        <div class="size-row">
                                            <input type="text" name="sizeName[]" class="size-input" placeholder="Tên size (S, M, L...)">
                                            <input type="number" name="sizePrice[]" class="size-input" placeholder="Giá size (đ)" min="0" step="500">
                                            <button type="button" class="btn-remove-size" onclick="removeSize(this)">×</button>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div style="padding:0 12px 12px;">
                                <button type="button" class="btn-add-size" onclick="addSizeRow()">
                                    ＋ Thêm size
                                </button>
                            </div>
                        </div>
                    </div>
                </div><%-- end form-grid --%>

                <c:if test="${not empty loi}">
                    <div class="alert alert-error" style="margin-top:16px;">⚠️ <c:out value="${loi}"/></div>
                </c:if>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="closeProductModal()">Hủy</button>
            <button type="submit" form="productForm" class="btn btn-primary">
                <c:choose>
                    <c:when test="${not empty productSua}">💾 Lưu thay đổi</c:when>
                    <c:otherwise>➕ Thêm sản phẩm</c:otherwise>
                </c:choose>
            </button>
        </div>
    </div>
</div>

<script>
    const modal = document.getElementById('productModal');
    const isEditMode = ${ not empty productSua ? 'true' : 'false' };
    const hasError   = ${ not empty loi ? 'true' : 'false' };

    /* ── Modal controls ── */
    function openProductModal() {
        modal.classList.add('active');
    }
    function closeProductModal() {
        modal.classList.remove('active');
        if (isEditMode) {
            window.location.href = '${pageContext.request.contextPath}/shop/products';
        }
    }
    modal.addEventListener('click', e => { if (e.target === modal) closeProductModal(); });
    document.addEventListener('DOMContentLoaded', () => {
        if (isEditMode || hasError) openProductModal();
    });

    /* ── Size rows ── */
    function addSizeRow() {
        const container = document.getElementById('sizeRows');
        const row = document.createElement('div');
        row.className = 'size-row';
        row.innerHTML = `
            <input type="text"   name="sizeName[]"  class="size-input" placeholder="Tên size (S, M, L...)">
            <input type="number" name="sizePrice[]" class="size-input" placeholder="Giá size (đ)" min="0" step="500">
            <button type="button" class="btn-remove-size" onclick="removeSize(this)">×</button>
        `;
        container.appendChild(row);
        row.querySelector('input').focus();
    }
    function removeSize(btn) {
        const rows = document.querySelectorAll('.size-row');
        if (rows.length > 1) {
            btn.closest('.size-row').remove();
        } else {
            btn.closest('.size-row').querySelectorAll('input').forEach(i => i.value = '');
        }
    }

    /* ── Image preview ── */
    function previewImage(url) {
        const wrap = document.getElementById('imgPreview');
        if (!url) {
            wrap.innerHTML = '<span class="placeholder">🖼️</span>';
            return;
        }
        wrap.innerHTML = '<img src="' + url + '" alt="Preview" onerror="this.parentNode.innerHTML=\'<span class=placeholder>🖼️</span>\'">';
    }

    /* ── Client-side filters ── */
    function filterProducts(keyword) {
        applyFilters();
    }
    function filterByType(typeId) {
        applyFilters();
    }
    function filterByStatus(status) {
        applyFilters();
    }

    function applyFilters() {
        const kw     = document.querySelector('.search-bar').value.toLowerCase().trim();
        const typeEl = document.querySelectorAll('.filter-select')[0];
        const stEl   = document.querySelectorAll('.filter-select')[1];
        const typeId = typeEl ? typeEl.value : '';
        const status = stEl  ? stEl.value  : '';

        const rows = document.querySelectorAll('#productTable tbody tr');
        let visible = 0;
        rows.forEach(row => {
            const name  = (row.getAttribute('data-name')   || '').toLowerCase();
            const rType = row.getAttribute('data-type')    || '';
            const rStat = row.getAttribute('data-status')  || '';
            const show  = (!kw || name.includes(kw))
                       && (!typeId || rType === typeId)
                       && (!status || rStat === status);
            row.style.display = show ? '' : 'none';
            if (show) visible++;
        });
        const el = document.getElementById('visibleCount');
        if (el) el.textContent = visible;
        const sel = document.getElementById('showCount');
        if (sel) sel.textContent = visible;
    }

    /* ── Search bar oninput also applies all filters ── */
    document.querySelector('.search-bar').addEventListener('input', applyFilters);

    /* ── Auto-dismiss alerts ── */
    document.querySelectorAll('.alert').forEach(el => {
        setTimeout(() => {
            el.style.transition = 'opacity .5s';
            el.style.opacity = '0';
            setTimeout(() => el.remove(), 500);
        }, 4000);
    });
</script>

</body>
</html>
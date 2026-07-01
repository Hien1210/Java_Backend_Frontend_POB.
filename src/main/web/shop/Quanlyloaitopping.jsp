<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

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
    <title>Quản lý Loại Topping - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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

        .content-wrapper{padding:32px;overflow-y:auto;flex:1;}

        /* ── ALERTS ── */
        .alert{padding:13px 18px;border-radius:10px;margin-bottom:20px;font-size:13px;font-weight:600;display:flex;align-items:center;gap:10px;}
        .alert-success{background:var(--success-lt);border:1px solid var(--success);color:#1E8449;}
        .alert-error{background:var(--accent-lt);border:1px solid var(--accent);color:var(--accent);}

        /* ── GRID LAYOUT ── */
        .page-grid{display:grid;grid-template-columns:360px 1fr;gap:24px;align-items:start;}
        @media(max-width:900px){.page-grid{grid-template-columns:1fr;}}

        /* ── PANEL ── */
        .panel{background:var(--bg-panel);border:1px solid var(--border);border-radius:16px;box-shadow:var(--sh-sm);overflow:hidden;}
        .panel-header{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
        .panel-title{color:var(--primary-dk);font-size:13px;font-weight:800;text-transform:uppercase;letter-spacing:.4px;display:flex;align-items:center;gap:8px;}
        .panel-title::before{content:'';width:4px;height:15px;background:var(--primary);border-radius:3px;display:inline-block;}
        .panel-body{padding:22px;}

        /* ── FORM ── */
        .form-group{margin-bottom:16px;}
        .form-group label{display:block;font-size:12px;font-weight:700;color:var(--text-muted);margin-bottom:7px;text-transform:uppercase;letter-spacing:.4px;}
        .form-group label .req{color:var(--accent);}
        .form-control{width:100%;padding:11px 14px;background:var(--bg-input);border:1px solid var(--border);border-radius:10px;font-size:14px;color:var(--text-main);outline:none;transition:border-color .2s,box-shadow .2s;}
        .form-control:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(255,122,48,.15);}
        .form-control::placeholder{color:var(--text-dim);}
        select.form-control{cursor:pointer;}

        .btn-row{display:flex;gap:10px;margin-top:20px;flex-wrap:wrap;}
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

        /* ── TABLE ── */
        .table-wrap{overflow-x:auto;}
        table{width:100%;border-collapse:collapse;text-align:left;}
        th{padding:12px 16px;font-size:11px;color:var(--text-dim);text-transform:uppercase;font-weight:700;border-bottom:2px solid var(--border);white-space:nowrap;}
        td{padding:14px 16px;border-bottom:1px solid var(--border);font-size:13.5px;color:var(--text-main);vertical-align:middle;}
        tr:last-child td{border-bottom:none;}
        tr:hover td{background:var(--bg-hover);}

        .badge{display:inline-flex;align-items:center;gap:5px;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:700;text-transform:uppercase;}
        .badge-active{background:var(--success-lt);color:#1E8449;}
        .badge-hidden{background:var(--accent-lt);color:var(--accent);}
        .badge-inactive{background:rgba(156,133,121,.12);color:var(--text-muted);}

        .action-cell{display:flex;gap:8px;flex-wrap:wrap;}
        .inline-form{display:inline;}

        .count-chip{background:var(--primary-lt);color:var(--primary-dk);font-size:12px;font-weight:700;padding:3px 10px;border-radius:12px;}

        .empty-state{text-align:center;padding:48px 20px;color:var(--text-dim);}
        .empty-state .empty-icon{font-size:42px;margin-bottom:12px;}
        .empty-state p{font-size:14px;}

        /* ── MINI STATS ── */
        .mini-stats{display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:24px;}
        .mini-stat{background:var(--bg-panel);border:1px solid var(--border);border-radius:12px;padding:16px 18px;display:flex;align-items:center;gap:12px;box-shadow:var(--sh-sm);}
        .mini-stat-icon{width:36px;height:36px;border-radius:9px;display:flex;align-items:center;justify-content:center;font-size:17px;flex-shrink:0;}
        .mini-stat-icon.orange{background:var(--primary-lt);}
        .mini-stat-icon.green{background:var(--success-lt);}
        .mini-stat-num{font-size:22px;font-weight:800;color:var(--text-main);}
        .mini-stat-label{font-size:11px;color:var(--text-muted);font-weight:600;text-transform:uppercase;}
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
    <a href="${pageContext.request.contextPath}/shop/topping-categories" class="menu-item active">
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
        <h2>🏷️ QUẢN LÝ LOẠI TOPPING</h2>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/shop/topping-categories?action=trash" class="btn-logout" style="background:rgba(230,57,70,.10);color:#E63946;border:1px solid #E63946;">🗑️ Thùng rác</a>
            <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content-wrapper">

        <%-- Thông báo --%>
        <c:if test="${param.success eq 'create'}">
            <div class="alert alert-success">✅ Tạo loại topping thành công!</div>
        </c:if>
        <c:if test="${param.success eq 'update'}">
            <div class="alert alert-success">✅ Cập nhật loại topping thành công!</div>
        </c:if>
        <c:if test="${param.success eq 'delete'}">
            <div class="alert alert-success">✅ Xóa loại topping thành công!</div>
        </c:if>
        <c:if test="${not empty loi}">
            <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <%-- Mini Stats --%>
        <div class="mini-stats">
            <div class="mini-stat">
                <div class="mini-stat-icon orange">🏷️</div>
                <div>
                    <div class="mini-stat-num">${fn:length(danhsach)}</div>
                    <div class="mini-stat-label">Tổng loại topping</div>
                </div>
            </div>
        </div>

        <c:set var="formCat" value="${not empty categorySua ? categorySua : categoryForm}"/>

        <div class="page-grid">

            <%-- ── FORM PANEL ── --%>
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-title">
                        <c:choose>
                            <c:when test="${not empty categorySua}">✏️ Cập nhật loại topping</c:when>
                            <c:otherwise>➕ Thêm loại topping mới</c:otherwise>
                        </c:choose>
                    </div>
                    <c:if test="${not empty categorySua}">
                        <a href="${pageContext.request.contextPath}/shop/topping-categories" style="font-size:12px;color:var(--text-dim);">Hủy ✕</a>
                    </c:if>
                </div>
                <div class="panel-body">
                    <form action="${pageContext.request.contextPath}/shop/topping-categories" method="post">
                        <c:choose>
                            <c:when test="${not empty categorySua}">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${categorySua.id}">
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="action" value="create">
                            </c:otherwise>
                        </c:choose>

                        <div class="form-group">
                            <label for="categoryName">Tên loại topping <span class="req">*</span></label>
                            <input type="text" id="categoryName" name="categoryName" class="form-control"
                                   value="${fn:escapeXml(formCat.name)}"
                                   placeholder="Ví dụ: Nước sốt, Phô mai, Rau củ..."
                                   required autofocus>
                        </div>

                        <div class="form-group">
                            <label for="description">Mô tả</label>
                            <textarea id="description" name="description" class="form-control" rows="3"
                                      placeholder="Mô tả ngắn về loại topping (không bắt buộc)">${fn:escapeXml(formCat.description)}</textarea>
                        </div>

                        <div class="btn-row">
                            <button type="submit" class="btn btn-primary">
                                <c:choose>
                                    <c:when test="${not empty categorySua}">💾 Lưu thay đổi</c:when>
                                    <c:otherwise>➕ Thêm mới</c:otherwise>
                                </c:choose>
                            </button>
                            <c:if test="${not empty categorySua}">
                                <a href="${pageContext.request.contextPath}/shop/topping-categories"
                                   class="btn btn-secondary">✕ Hủy</a>
                            </c:if>
                        </div>
                    </form>
                </div>
            </section>

            <%-- ── LIST PANEL ── --%>
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-title">
                        Danh sách loại topping
                        <span class="count-chip">${fn:length(danhsach)}</span>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty danhsach}">
                        <div class="empty-state">
                            <div class="empty-icon">🏷️</div>
                            <p>Chưa có loại topping nào.<br>Hãy tạo loại topping đầu tiên!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-wrap">
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Tên loại topping</th>
                                        <th>Mô tả</th>
                                        <th style="text-align:center;">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cat" items="${danhsach}" varStatus="vs">
                                        <tr>
                                            <td style="color:var(--warning);font-weight:700;">${vs.index + 1}</td>
                                            <td>
                                                <strong><c:out value="${cat.name}"/></strong>
                                            </td>
                                            <td>
                                                <c:out value="${cat.description}" default="—"/>
                                            </td>
                                            <td>
                                                <div class="action-cell" style="justify-content:center;">
                                                    <a href="${pageContext.request.contextPath}/shop/topping-categories?action=edit&id=${cat.id}"
                                                       class="btn btn-sm btn-edit">✏️ Sửa</a>
                                                    <form class="inline-form"
                                                          action="${pageContext.request.contextPath}/shop/topping-categories"
                                                          method="post"
                                                          onsubmit="return confirm('Xóa loại topping «${fn:escapeXml(cat.name)}»?')">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${cat.id}">
                                                        <button type="submit" class="btn btn-sm btn-delete">🗑️ Xóa</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

        </div><%-- end page-grid --%>
    </div><%-- end content-wrapper --%>
</main>

</body>
</html>

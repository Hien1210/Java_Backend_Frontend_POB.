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
    <title>Thông tin cửa hàng - ${not empty currentShop.shopName ? currentShop.shopName : 'Cửa hàng'}</title>
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

        /* ── GRID LAYOUT ── */
        .page-grid{display:grid;grid-template-columns:1fr 360px;gap:24px;align-items:start;}
        @media(max-width:960px){.page-grid{grid-template-columns:1fr;}}

        /* ── PANEL ── */
        .panel{background:var(--bg-panel);border:1px solid var(--border);border-radius:16px;box-shadow:var(--sh-sm);overflow:hidden;}
        .panel-header{padding:18px 22px;border-bottom:1px solid var(--border);display:flex;align-items:center;justify-content:space-between;}
        .panel-title{color:var(--primary-dk);font-size:13px;font-weight:800;text-transform:uppercase;letter-spacing:.4px;display:flex;align-items:center;gap:8px;}
        .panel-title::before{content:'';width:4px;height:15px;background:var(--primary);border-radius:3px;display:inline-block;}
        .panel-body{padding:24px;}

        /* ── FORM ── */
        .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
        .form-full{grid-column:1/-1;}
        .form-group{margin-bottom:16px;display:flex;flex-direction:column;gap:6px;}
        .form-group label{display:block;font-size:12px;font-weight:700;color:var(--text-muted);margin-bottom:2px;text-transform:uppercase;letter-spacing:.4px;}
        .form-group label .req{color:var(--accent);}
        .form-control{width:100%;padding:11px 14px;background:var(--bg-input);border:1px solid var(--border);border-radius:10px;font-size:14px;color:var(--text-main);outline:none;transition:border-color .2s,box-shadow .2s;font-family:inherit;}
        .form-control:focus{border-color:var(--primary);box-shadow:0 0 0 3px rgba(255,122,48,.15);}
        .form-control::placeholder{color:var(--text-dim);}
        textarea.form-control{min-height:100px;resize:vertical;}
        .secret-field{display:flex;gap:8px;align-items:center;}
        .secret-field .form-control{flex:1;}
        .btn-toggle-secret{flex-shrink:0;width:40px;height:40px;border:1px solid var(--border);border-radius:10px;background:var(--bg-input);cursor:pointer;font-size:16px;}
        .btn-toggle-secret:hover{background:var(--border);}

        .btn-row{display:flex;gap:10px;margin-top:8px;flex-wrap:wrap;}
        .btn{display:inline-flex;align-items:center;gap:7px;padding:10px 20px;border:none;border-radius:10px;font-weight:700;font-size:13px;cursor:pointer;transition:all .2s cubic-bezier(.4,0,.2,1);}
        .btn:hover{transform:translateY(-2px);}
        .btn:active{transform:translateY(0);}
        .btn-primary{background:var(--primary);color:#fff;box-shadow:0 4px 12px rgba(255,122,48,.25);}
        .btn-primary:hover{background:var(--primary-dk);}
        .btn-secondary{background:var(--bg-input);border:1px solid var(--border);color:var(--text-muted);}
        .btn-secondary:hover{background:var(--border);color:var(--text-main);}

        /* ── HINT ── */
        .hint{font-size:11px;color:var(--text-dim);margin-top:-2px;}

        /* ── SIDE INFO CARD ── */
        .info-card{padding:24px;}
        .logo-preview-wrap{display:flex;flex-direction:column;align-items:center;gap:14px;margin-bottom:20px;}
        .logo-preview{width:120px;height:120px;border-radius:20px;border:2px dashed var(--border);background:var(--bg-input);display:flex;align-items:center;justify-content:center;overflow:hidden;font-size:40px;color:var(--text-dim);}
        .logo-preview img{width:100%;height:100%;object-fit:cover;}

        .status-badge{display:inline-flex;align-items:center;gap:6px;padding:6px 16px;border-radius:20px;font-size:12px;font-weight:700;text-transform:uppercase;}
        .status-approved{background:var(--success-lt);color:#1E8449;}
        .status-pending{background:var(--warning-lt);color:#B07700;}
        .status-rejected{background:var(--accent-lt);color:var(--accent);}

        .info-row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border);font-size:13px;}
        .info-row:last-child{border-bottom:none;}
        .info-row .lbl{color:var(--text-muted);font-weight:600;}
        .info-row .val{color:var(--text-main);font-weight:700;text-align:right;}

        .reject-box{background:var(--accent-lt);border:1px solid var(--accent);border-radius:10px;padding:12px 14px;margin-top:14px;font-size:12px;color:var(--accent);line-height:1.6;}
        .reject-box strong{display:block;margin-bottom:4px;}
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
    <a href="${pageContext.request.contextPath}/shop/bills" class="menu-item">
        <div class="menu-item-left"><span style="font-size:16px;">📋</span> Quản lý hóa đơn</div>
    </a>

    <div class="menu-title">Cửa hàng</div>
    <a href="${pageContext.request.contextPath}/shop/profile" class="menu-item active">
        <div class="menu-item-left"><span style="font-size:16px;">🏪</span> Thông tin cửa hàng</div>
    </a>
</div>
</aside>

<main class="main-content">
    <header class="top-header">
        <h2>🏪 THÔNG TIN CỬA HÀNG CỦA TÔI</h2>
        <div class="header-actions">
            <div class="avatar">${fn:toUpperCase(fn:substring(sessionScope.account.userName,0,2))}</div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </header>

    <div class="content-wrapper">

        <%-- Thông báo --%>
        <c:if test="${param.success eq 'update'}">
            <div class="alert alert-success">✅ Cập nhật thông tin cửa hàng thành công!</div>
        </c:if>
        <c:if test="${not empty loi}">
            <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
        </c:if>

        <c:set var="formShop" value="${not empty shopForm ? shopForm : currentShop}"/>

        <div class="page-grid">

            <%-- ── FORM PANEL: CHỈNH SỬA THÔNG TIN ── --%>
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-title">✏️ Chỉnh sửa thông tin cửa hàng</div>
                </div>
                <div class="panel-body">
                    <form action="${pageContext.request.contextPath}/shop/profile" method="post" id="shopProfileForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${currentShop.id}">

                        <div class="form-grid">
                            <div class="form-group form-full">
                                <label for="shopName">Tên cửa hàng <span class="req">*</span></label>
                                <input type="text" id="shopName" name="shopName" class="form-control"
                                       value="${fn:escapeXml(formShop.shopName)}"
                                       placeholder="Ví dụ: Quán Cơm Tấm Cô Ba..."
                                       required autofocus>
                            </div>

                            <div class="form-group form-full">
                                <label for="shopDescription">Mô tả cửa hàng</label>
                                <textarea id="shopDescription" name="shopDescription" class="form-control"
                                          placeholder="Giới thiệu ngắn về cửa hàng của bạn..."><c:out value="${formShop.shopDescription}"/></textarea>
                            </div>

                            <div class="form-group form-full">
                                <label for="shopAddress">Địa chỉ <span class="req">*</span></label>
                                <input type="text" id="shopAddress" name="shopAddress" class="form-control"
                                       value="${fn:escapeXml(formShop.shopAddress)}"
                                       placeholder="Số nhà, đường, quận/huyện, tỉnh/thành..."
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="shopPhone">Số điện thoại <span class="req">*</span></label>
                                <input type="text" id="shopPhone" name="shopPhone" class="form-control"
                                       value="${fn:escapeXml(formShop.shopPhone)}"
                                       placeholder="09xx xxx xxx"
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="shopLogo">URL ảnh Logo</label>
                                <input type="text" id="shopLogo" name="shopLogo" class="form-control"
                                       value="${fn:escapeXml(formShop.shopLogo)}"
                                       placeholder="https://..."
                                       oninput="previewLogo(this.value)">
                                <p class="hint">Dán đường dẫn ảnh logo để hiển thị bên cạnh.</p>
                            </div>

                            <div class="form-group form-full">
                                <label for="clientKey">Client ID</label>
                                <div class="secret-field">
                                    <input type="password" id="clientKey" name="clientKey" class="form-control"
                                           value="${fn:escapeXml(formShop.clientKey)}"
                                           placeholder="Client ID dùng cho cổng thanh toán..." autocomplete="off">
                                    <button type="button" class="btn-toggle-secret" onclick="toggleSecret('clientKey', this)">👁</button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="apiKey">API Key</label>
                                <div class="secret-field">
                                    <input type="password" id="apiKey" name="apiKey" class="form-control"
                                           value="${fn:escapeXml(formShop.apiKey)}"
                                           placeholder="API Key..." autocomplete="off">
                                    <button type="button" class="btn-toggle-secret" onclick="toggleSecret('apiKey', this)">👁</button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="checkSumKey">Checksum Key</label>
                                <div class="secret-field">
                                    <input type="password" id="checkSumKey" name="checkSumKey" class="form-control"
                                           value="${fn:escapeXml(formShop.checkSumKey)}"
                                           placeholder="Checksum Key..." autocomplete="off">
                                    <button type="button" class="btn-toggle-secret" onclick="toggleSecret('checkSumKey', this)">👁</button>
                                </div>
                            </div>
                        </div>

                        <div class="btn-row">
                            <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-secondary">✕ Hủy</a>
                        </div>
                    </form>
                </div>
            </section>

            <%-- ── SIDE PANEL: TRẠNG THÁI & XEM TRƯỚC ── --%>
            <section class="panel">
                <div class="panel-header">
                    <div class="panel-title">📋 Tổng quan</div>
                </div>
                <div class="info-card">

                    <div class="logo-preview-wrap">
                        <div class="logo-preview" id="logoPreview">
                            <c:choose>
                                <c:when test="${not empty currentShop.shopLogo}">
                                    <img src="${currentShop.shopLogo}" alt="Logo"
                                         onerror="this.parentNode.innerHTML='🏪'">
                                </c:when>
                                <c:otherwise>🏪</c:otherwise>
                            </c:choose>
                        </div>

                        <c:choose>
                            <c:when test="${fn:toUpperCase(currentShop.status) == 'APPROVED' || fn:toUpperCase(currentShop.status) == 'ACCEPT' || fn:toUpperCase(currentShop.status) == 'ACTIVE'}">
                                <span class="status-badge status-approved">✅ Đã duyệt - Đang hoạt động</span>
                            </c:when>
                            <c:when test="${fn:toUpperCase(currentShop.status) == 'REJECT' || fn:toUpperCase(currentShop.status) == 'REJECTED'}">
                                <span class="status-badge status-rejected">✕ Bị từ chối</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-pending">⏳ Chờ duyệt</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="info-row">
                        <span class="lbl">Mã cửa hàng</span>
                        <span class="val">#${currentShop.id}</span>
                    </div>
                    <div class="info-row">
                        <span class="lbl">Tên cửa hàng</span>
                        <span class="val"><c:out value="${currentShop.shopName}"/></span>
                    </div>
                    <div class="info-row">
                        <span class="lbl">Số điện thoại</span>
                        <span class="val"><c:out value="${currentShop.shopPhone}"/></span>
                    </div>
                    <div class="info-row">
                        <span class="lbl">Chủ sở hữu</span>
                        <span class="val"><c:out value="${sessionScope.account.userName}"/></span>
                    </div>

                    <c:if test="${(fn:toUpperCase(currentShop.status) == 'REJECT' || fn:toUpperCase(currentShop.status) == 'REJECTED') && not empty currentShop.rejectionReason}">
                        <div class="reject-box">
                            <strong>⚠️ Lý do từ chối lần trước:</strong>
                            <c:out value="${currentShop.rejectionReason}"/>
                        </div>
                    </c:if>
                </div>
            </section>

        </div><%-- end page-grid --%>
    </div><%-- end content-wrapper --%>
</main>

<script>
    function previewLogo(url) {
        const wrap = document.getElementById('logoPreview');
        if (!url) {
            wrap.innerHTML = '🏪';
            return;
        }
        wrap.innerHTML = '<img src="' + url + '" alt="Logo" onerror="this.parentNode.innerHTML=\'🏪\'">';
    }

    function toggleSecret(inputId, btn) {
        const input = document.getElementById(inputId);
        const hidden = input.type === 'password';
        input.type = hidden ? 'text' : 'password';
        btn.textContent = hidden ? '🙈' : '👁';
    }

    /* Auto-dismiss alerts */
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

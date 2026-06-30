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
    <title>Quản lý Category - Super Admin</title>
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
            --shadow-md: 0 4px 6px rgba(0,0,0,0.15);
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
            --shadow-md: 0 4px 6px rgba(0,0,0,0.06);
        }

        :root {
            --primary: #20d489;
            --warning: #facc15;
            --danger: #ef4444;
            --info: #3b82f6;
            --secondary: #64748b;
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

        /* Main Content & Header */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; background-color: var(--bg-base); }
        .top-header { height: 70px; background-color: var(--topbar-bg); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 30px; flex-shrink: 0; }
        .top-header h2 { color: var(--text-main); font-size: 18px; font-weight: 600; }
        .header-actions { display: flex; align-items: center; gap: 15px; }
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

        .grid { display: grid; grid-template-columns: 360px 1fr; gap: 20px; align-items: start; }
        @media (max-width: 992px) { .grid { grid-template-columns: 1fr; } }
        
        .panel { background: var(--bg-panel); border: 1px solid var(--border-color); border-radius: 10px; box-shadow: var(--shadow-md); overflow: hidden; }
        .panel-header { padding: 16px 20px; border-bottom: 1px solid var(--border-color); font-weight: 600; color: var(--text-main); font-size: 14px; text-transform: uppercase; }
        .panel-body { padding: 20px; }

        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: 600; font-size: 12px; margin-bottom: 8px; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px; }
        input, select { width: 100%; padding: 10px 14px; background-color: var(--bg-input); border: 1px solid var(--border-color); border-radius: 6px; font-size: 14px; color: var(--text-main); outline: none; transition: border-color 0.2s; }
        input:focus, select:focus { border-color: var(--primary); }

        .actions { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 20px; }
        
        .btn { display: inline-block; padding: 8px 16px; border-radius: 6px; font-weight: 600; font-size: 12px; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); text-align: center; text-transform: uppercase; cursor: pointer; text-decoration: none; border: 1px solid transparent; background: transparent;}
        .btn:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); }
        .btn:active { transform: translateY(0); }

        .btn-primary { background: rgba(32, 212, 137, 0.15); color: var(--primary); border-color: var(--primary); }
        .btn-primary:hover { background: var(--primary); color: #151521; }
        .btn-secondary { background: rgba(100, 116, 139, 0.15); color: var(--secondary); border-color: var(--secondary); }
        .btn-secondary:hover { background: var(--secondary); color: white; }
        .btn-warning { background: rgba(250, 204, 21, 0.15); color: var(--warning); border-color: var(--warning); font-size: 11px; padding: 6px 12px; }
        .btn-warning:hover { background: var(--warning); color: #151521; }
        .btn-danger { background: rgba(239, 68, 68, 0.15); color: var(--danger); border-color: var(--danger); font-size: 11px; padding: 6px 12px; }
        .btn-danger:hover { background: var(--danger); color: white; }

        .btn-header { background: transparent; border-color: var(--info); color: var(--info); }
        .btn-header:hover { background: var(--info); color: white; }

        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; font-weight: 600; }
        .alert-error { background: rgba(239, 68, 68, 0.1); border: 1px solid var(--danger); color: var(--danger); }
        .alert-success { background: rgba(32, 212, 137, 0.1); border: 1px solid var(--primary); color: var(--primary); }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 16px 20px; text-align: left; }
        th { background-color: var(--bg-input); color: var(--text-muted); font-size: 12px; font-weight: 600; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        td { border-bottom: 1px solid var(--border-color); color: var(--text-main); font-size: 14px; vertical-align: middle; }
        tr:hover td { background-color: var(--bg-hover); }
        tr:last-child td { border-bottom: none; }
        td strong { color: var(--text-main); font-weight: 600; }

        .table-actions { display: flex; gap: 8px; flex-wrap: wrap; }
        .inline-form { display: inline; }
        .empty { padding: 30px; text-align: center; color: var(--primary); background: var(--bg-input); border-radius: 8px; border: 1px dashed var(--border-color); }
        
        .badge { display: inline-block; border-radius: 12px; padding: 4px 10px; font-size: 11px; font-weight: 700; text-transform: uppercase; background: rgba(161, 165, 183, 0.1); color: var(--text-muted); border: 1px solid var(--border-color); }
        .badge.active { background: rgba(32, 212, 137, 0.1); color: var(--primary); border-color: var(--primary); }
        .badge.hidden { background: rgba(239, 68, 68, 0.1); color: var(--danger); border-color: var(--danger); }
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
                <div class="menu-item-left"><span style="font-size: 16px;">⊞</span> Tổng quan hệ thống</div>
            </a>
            <a href="${pageContext.request.contextPath}/super-admin/shop-requests" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🏪</span> Duyệt Shop</div>
            </a>
            <a href="#" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🛵</span> Duyệt Shipper</div>
            </a>

            <div class="menu-title" style="margin-top: 25px;">QUẢN LÝ DỮ LIỆU</div>
            <a href="${pageContext.request.contextPath}/quanlitaikhoan" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">👤</span> Người dùng</div>
            </a>
            <a href="${pageContext.request.contextPath}/Category" class="menu-item active">
                <div class="menu-item-left"><span style="font-size: 16px;">📂</span> Danh mục món ăn</div>
            </a>
            <a href="${pageContext.request.contextPath}/product" class="menu-item">
                <div class="menu-item-left"><span style="font-size: 16px;">🍽️</span> Sản phẩm</div>
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <h2>HỆ THỐNG QUẢN LÝ DANH MỤC (CATEGORY)</h2>
            <div class="header-actions">
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
                        <h1 class="section-title">QUẢN LÝ CATEGORY</h1>
                    </div>
                    <p class="section-desc">Tạo, cập nhật và quản lý danh sách Category trên hệ thống.</p>
                </div>
                <a href="${pageContext.request.contextPath}/Category" class="btn btn-header">Làm mới trang</a>
            </div>

            <c:if test="${param.success == 'create'}">
                <div class="alert alert-success">✅ Tạo category thành công!</div>
            </c:if>
            <c:if test="${param.success == 'update'}">
                <div class="alert alert-success">✅ Cập nhật category thành công!</div>
            </c:if>
            <c:if test="${param.success == 'delete'}">
                <div class="alert alert-success">✅ Xóa category thành công!</div>
            </c:if>
            <c:if test="${not empty loi}">
                <div class="alert alert-error">⚠️ <c:out value="${loi}"/></div>
            </c:if>

            <c:set var="formCategory" value="${not empty categorySua ? categorySua : categoryForm}"/>
            <div class="grid">
                <!-- FORM PANEL -->
                <section class="panel">
                    <div class="panel-header">
                        <c:choose>
                            <c:when test="${not empty categorySua}">CẬP NHẬT CATEGORY #${categorySua.id}</c:when>
                            <c:otherwise>TẠO CATEGORY MỚI</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="panel-body">
                        <form action="${pageContext.request.contextPath}/Category" method="post">
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
                                <label for="shopId">Shop ID <span style="color:var(--danger)">*</span></label>
                                <input type="number" id="shopId" name="shopId" min="1" value="${formCategory.shopId}" required placeholder="Nhập ID của Shop...">
                            </div>

                            <div class="form-group">
                                <label for="categoryName">Tên Category <span style="color:var(--danger)">*</span></label>
                                <input type="text" id="categoryName" name="categoryName"
                                       value="${fn:escapeXml(formCategory.categoryName)}" required placeholder="Ví dụ: Đồ ăn nhanh, Đồ uống...">
                            </div>

                            <div class="form-group">
                                <label for="status">Trạng thái</label>
                                <select id="status" name="status">
                                    <option value="ACTIVE" ${fn:toUpperCase(formCategory.status) == 'ACTIVE' ? 'selected' : ''}>ACTIVE (Hiển thị)</option>
                                    <option value="HIDDEN" ${fn:toUpperCase(formCategory.status) == 'HIDDEN' ? 'selected' : ''}>HIDDEN (Ẩn)</option>
                                </select>
                            </div>

                            <div class="actions">
                                <button type="submit" class="btn btn-primary">
                                    <c:choose>
                                        <c:when test="${not empty categorySua}">✓ Cập nhật</c:when>
                                        <c:otherwise>+ Thêm mới</c:otherwise>
                                    </c:choose>
                                </button>
                                <c:if test="${not empty categorySua}">
                                    <a href="${pageContext.request.contextPath}/Category" class="btn btn-secondary">✕ Hủy</a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </section>

                <!-- LIST PANEL -->
                <section class="panel">
                    <div class="panel-header">DANH SÁCH CATEGORY (${fn:length(danhsach)})</div>
                    <div class="panel-body" style="padding: 0;">
                        <c:choose>
                            <c:when test="${empty danhsach}">
                                <div class="empty">Chưa có category nào trong hệ thống.</div>
                            </c:when>
                            <c:otherwise>
                                <div style="overflow-x: auto;">
                                    <table>
                                        <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Shop ID</th>
                                            <th>Tên Category</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach var="category" items="${danhsach}">
                                            <tr>
                                                <td style="color: var(--warning); font-weight: bold;">#<c:out value="${category.id}"/></td>
                                                <td><c:out value="${category.shopId}"/></td>
                                                <td><strong><c:out value="${category.categoryName}"/></strong></td>
                                                <td>
                                                    <span class="badge ${fn:toLowerCase(category.status)}"><c:out value="${category.status}"/></span>
                                                </td>
                                                <td>
                                                    <div class="table-actions">
                                                        <a href="${pageContext.request.contextPath}/Category?action=edit&id=${category.id}" class="btn btn-warning">Sửa</a>
                                                        <form class="inline-form"
                                                              action="${pageContext.request.contextPath}/Category"
                                                              method="post"
                                                              onsubmit="return confirm('Xác nhận XÓA category [${fn:escapeXml(category.categoryName)}]?')">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${category.id}">
                                                            <button type="submit" class="btn btn-danger">Xóa</button>
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
                    </div>
                </section>
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

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo - POB Shipper</title>
    <style>
        :root[data-theme="dark"] {
            --bg-base: #0f172a; --bg-card: #1e293b; --bg-input: #0f172a;
            --text-main: #f8fafc; --text-muted: #94a3b8; --border-color: #334155;
            --topbar-bg: rgba(30, 41, 59, 0.8); --shadow: 0 4px 6px -1px rgb(0 0 0 / 0.2);
        }
        :root[data-theme="light"] {
            --bg-base: #f4f7f5; --bg-card: #ffffff; --bg-input: #f8fafc;
            --text-main: #1e293b; --text-muted: #64748b; --border-color: #e2e8f0;
            --topbar-bg: rgba(255, 255, 255, 0.85); --shadow: 0 4px 12px rgba(0,0,0,0.03);
        }
        :root {
            --primary: #4CAF50; --primary-hover: #43a047; --primary-light: rgba(76,175,80,0.12);
            --secondary: #FF9800; --secondary-hover: #f57c00; --secondary-light: rgba(255,152,0,0.12);
            --danger: #ef4444;
            --font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: var(--font-family); transition: background-color 0.25s, border-color 0.25s; }
        body { background-color: var(--bg-base); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: var(--bg-card); border-right: 1px solid var(--border-color); display: flex; flex-direction: column; flex-shrink: 0; z-index: 10; }
        .brand { padding: 24px; display: flex; align-items: center; gap: 12px; border-bottom: 1px solid var(--border-color); }
        .logo { background: linear-gradient(135deg, var(--primary), #2e7d32); color: #fff; width: 38px; height: 38px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 10px rgba(76,175,80,0.3); }
        .brand-title { font-weight: 700; font-size: 16px; letter-spacing: 0.5px; }
        .menu { padding: 20px 12px; flex: 1; }
        .menu-item { padding: 14px 16px; display: flex; align-items: center; gap: 12px; color: var(--text-muted); font-size: 14px; font-weight: 600; border-radius: 8px; margin-bottom: 6px; }
        .menu-item:hover { background-color: var(--bg-input); color: var(--text-main); transform: translateX(4px); }
        .menu-item.active { background-color: var(--primary-light); color: var(--primary); }
        .brand-text { display: flex; flex-direction: column; gap: 2px; }
        .online-toggle-wrap { padding: 16px 12px; border-top: 1px solid var(--border-color); }
        .online-toggle-btn { width: 100%; padding: 12px 16px; border-radius: 10px; cursor: pointer; display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 700; transition: all 0.2s; }
        .online-toggle-btn.is-online { background: var(--primary-light); color: var(--primary); border: 1.5px solid var(--primary); }
        .online-toggle-btn.is-offline { background: rgba(239,68,68,0.08); color: #ef4444; border: 1.5px solid rgba(239,68,68,0.3); }
        .toggle-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; }
        .toggle-dot.online { background: var(--primary); animation: pulse-green 1.5s infinite; }
        .toggle-dot.offline { background: #ef4444; }
        @keyframes pulse-green { 0%,100%{box-shadow:0 0 0 3px rgba(76,175,80,0.25)} 50%{box-shadow:0 0 0 6px rgba(76,175,80,0.1)} }
        .btn-logout { padding: 8px 16px; border-radius: 8px; background: rgba(239,68,68,0.1); color: var(--danger); font-size: 13px; font-weight: 600; }
        .btn-logout:hover { background: var(--danger); color: white; }

        /* MAIN */
        .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .topbar { padding: 16px 28px; background-color: var(--topbar-bg); backdrop-filter: blur(10px); border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; flex-shrink: 0; }
        .topbar h1 { font-size: 18px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .theme-toggle { background: none; border: 1px solid var(--border-color); border-radius: 8px; padding: 6px 10px; cursor: pointer; font-size: 16px; color: var(--text-main); }
        .avatar-circle { width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, var(--primary), var(--secondary)); color: #fff; font-weight: 700; font-size: 14px; display: flex; align-items: center; justify-content: center; }
        .online-badge { font-size: 11px; padding: 3px 8px; border-radius: 20px; font-weight: 600; }
        .online-badge.online { background: var(--primary-light); color: var(--primary); }
        .online-badge.offline { background: rgba(239,68,68,0.1); color: var(--danger); }

        /* CONTENT */
        .content { flex: 1; overflow-y: auto; padding: 28px; }
        .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
        .page-title { font-size: 22px; font-weight: 700; display: flex; align-items: center; gap: 10px; }
        .unread-badge { background: var(--secondary); color: #fff; font-size: 12px; font-weight: 700; padding: 2px 8px; border-radius: 20px; }

        .btn-mark-all { background: var(--primary-light); color: var(--primary); border: 1px solid var(--primary); border-radius: 8px; padding: 8px 16px; font-size: 13px; font-weight: 600; cursor: pointer; }
        .btn-mark-all:hover { background: var(--primary); color: #fff; }

        /* NOTIFICATION LIST */
        .notif-list { display: flex; flex-direction: column; gap: 12px; }
        .notif-card { background: var(--bg-card); border: 1px solid var(--border-color); border-radius: 12px; padding: 16px 20px; display: flex; gap: 14px; align-items: flex-start; box-shadow: var(--shadow); position: relative; }
        .notif-card.unread { border-left: 4px solid var(--secondary); background: var(--secondary-light); }
        .notif-card.unread .notif-title { color: var(--text-main); }
        .notif-icon { font-size: 24px; flex-shrink: 0; margin-top: 2px; }
        .notif-body { flex: 1; }
        .notif-title { font-size: 15px; font-weight: 700; margin-bottom: 4px; color: var(--text-muted); }
        .notif-card.unread .notif-title { color: var(--text-main); }
        .notif-message { font-size: 13px; color: var(--text-muted); line-height: 1.6; }
        .notif-time { font-size: 11px; color: var(--text-muted); margin-top: 6px; }
        .notif-dot { width: 9px; height: 9px; border-radius: 50%; background: var(--secondary); flex-shrink: 0; margin-top: 7px; }
        .notif-read-btn { background: none; border: 1px solid var(--border-color); border-radius: 6px; padding: 4px 10px; font-size: 11px; cursor: pointer; color: var(--text-muted); flex-shrink: 0; margin-top: 4px; }
        .notif-read-btn:hover { background: var(--primary-light); color: var(--primary); border-color: var(--primary); }

        .empty-state { text-align: center; padding: 60px 20px; color: var(--text-muted); }
        .empty-state .empty-icon { font-size: 56px; margin-bottom: 16px; }
        .empty-state p { font-size: 16px; }
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
            <li class="menu-item"><span>📋 Đơn hàng nhận</span></li>
        </a>
        <a href="${pageContext.request.contextPath}/shipper/thongbao">
            <li class="menu-item active"><span>🔔 Thông báo</span></li>
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
                        <span class="toggle-dot online"></span>
                        Đang Online — Nhấn để Offline
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="submit" class="online-toggle-btn is-offline">
                        <span class="toggle-dot offline"></span>
                        Đang Offline — Nhấn để Online
                    </button>
                </c:otherwise>
            </c:choose>
        </form>
    </div>
</aside>

<main class="main">
    <header class="topbar">
        <h1>
            Hộp thư thông báo
            <c:choose>
                <c:when test="${sessionScope.account.online}">
                    <span class="online-badge online">● Online</span>
                </c:when>
                <c:otherwise>
                    <span class="online-badge offline">● Offline</span>
                </c:otherwise>
            </c:choose>
        </h1>
        <div class="topbar-right">
            <button type="button" class="theme-toggle" id="themeToggleBtn">🌓</button>
            <div class="avatar-circle" title="${sessionScope.account.fullName}">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.fullName}">${fn:toUpperCase(fn:substring(sessionScope.account.fullName, 0, 1))}</c:when>
                    <c:otherwise>S</c:otherwise>
                </c:choose>
            </div>
            <span style="font-size:13px;font-weight:600;">${sessionScope.account.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Đăng xuất</a>
        </div>
    </header>

    <div class="content">
        <div class="page-header">
            <div class="page-title">
                🔔 Thông báo
                <c:if test="${unreadCount > 0}">
                    <span class="unread-badge">${unreadCount} chưa đọc</span>
                </c:if>
            </div>
            <c:if test="${unreadCount > 0}">
                <form action="${pageContext.request.contextPath}/shipper/thongbao" method="post" style="margin:0">
                    <input type="hidden" name="action" value="markAll"/>
                    <button type="submit" class="btn-mark-all">✅ Đánh dấu tất cả đã đọc</button>
                </form>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="empty-state">
                    <div class="empty-icon">🔕</div>
                    <p>Bạn chưa có thông báo nào.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="notif-list">
                    <c:forEach var="n" items="${notifications}">
                        <div class="notif-card ${n.read ? '' : 'unread'}">
                            <div class="notif-icon">🔔</div>
                            <div class="notif-body">
                                <div class="notif-title">${fn:escapeXml(n.title)}</div>
                                <div class="notif-message">${fn:escapeXml(n.message)}</div>
                                <div class="notif-time">
                                    <c:if test="${n.createdAt != null}">
                                        ${n.createdAt.hour}:<c:set var="m" value="${n.createdAt.minute}"/><c:if test="${m < 10}">0</c:if>${m}
                                        ${n.createdAt.dayOfMonth}/${n.createdAt.monthValue}/${n.createdAt.year}
                                    </c:if>
                                </div>
                            </div>
                            <c:if test="${!n.read}">
                                <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">
                                    <div class="notif-dot"></div>
                                    <form action="${pageContext.request.contextPath}/shipper/thongbao" method="post" style="margin:0">
                                        <input type="hidden" name="id" value="${n.id}"/>
                                        <button type="submit" class="notif-read-btn">Đã đọc</button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<script>
    const themeBtn = document.getElementById('themeToggleBtn');
    const html = document.documentElement;
    const saved = localStorage.getItem('shipperTheme') || 'light';
    html.setAttribute('data-theme', saved);
    themeBtn.addEventListener('click', () => {
        const next = html.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
        html.setAttribute('data-theme', next);
        localStorage.setItem('shipperTheme', next);
    });
</script>
</body>
</html>

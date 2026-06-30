<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản shop</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #172554, #0f766e);
            color: #172033;
        }

        .card {
            width: min(920px, calc(100% - 32px));
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            border-radius: 24px;
            background: #ffffff;
            box-shadow: 0 24px 70px rgba(0, 0, 0, 0.28);
        }

        .intro {
            padding: 56px;
            color: #ffffff;
            background: radial-gradient(circle at 20% 15%, #facc15 0, transparent 28%),
                        linear-gradient(150deg, #0f766e, #172554);
        }

        .intro h1 {
            margin: 0 0 14px;
            font-size: 44px;
            line-height: 1.05;
        }

        .intro p {
            max-width: 320px;
            line-height: 1.7;
            opacity: 0.9;
        }

        .form-panel {
            padding: 44px;
        }

        label {
            display: block;
            margin-top: 14px;
            font-weight: 700;
            font-size: 13px;
        }

        input {
            width: 100%;
            box-sizing: border-box;
            margin-top: 6px;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            outline: none;
        }

        input:focus {
            border-color: #0f766e;
            box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.14);
        }

        button {
            width: 100%;
            margin-top: 22px;
            padding: 13px;
            border: 0;
            border-radius: 999px;
            background: #0f766e;
            color: #ffffff;
            font-weight: 800;
            cursor: pointer;
        }

        .error {
            display: block;
            margin-top: 12px;
            color: #dc2626;
            text-align: center;
        }

        .link {
            display: block;
            margin-top: 14px;
            color: #0f766e;
            text-align: center;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
        }

        @media (max-width: 760px) {
            .card { grid-template-columns: 1fr; }
            .intro, .form-panel { padding: 32px; }
        }
    </style>
</head>
<body>
<main class="card">
    <section class="intro">
        <h1>Mở tài khoản shop</h1>
        <p>Tài khoản này dùng để đăng ký thông tin cửa hàng và chờ SuperAdmin duyệt trước khi bán hàng.</p>
    </section>

    <section class="form-panel">
        <h2>Đăng ký account shop</h2>
        <form action="${pageContext.request.contextPath}/dangky-shop" method="post" accept-charset="UTF-8">
            <label for="fullname">Họ tên chủ shop</label>
            <input id="fullname" type="text" name="fullname" value="${fullname}" required>

            <label for="username">Username</label>
            <input id="username" type="text" name="username" value="${username}" required>

            <label for="phone">Số điện thoại</label>
            <input id="phone" type="tel" name="phone" value="${phone}" required>

            <label for="email">Email</label>
            <input id="email" type="email" name="email" value="${email}" required>

            <label for="password">Mật khẩu</label>
            <input id="password" type="password" name="password" required>

            <label for="confirm_password">Xác nhận mật khẩu</label>
            <input id="confirm_password" type="password" name="confirm_password" required>

            <button type="submit">Đăng ký shop</button>
            <i class="error">${loi}</i>
        </form>
        <a class="link" href="${pageContext.request.contextPath}/dangnhap">Đã có tài khoản? Đăng nhập</a>
        <a class="link" href="${pageContext.request.contextPath}/dangky">Đăng ký tài khoản người dùng</a>
    </section>
</main>
</body>
</html>

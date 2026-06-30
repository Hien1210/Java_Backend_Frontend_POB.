<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản Shipper - POB</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
            /* Phối lại màu nền gradient theo tone Xanh lá và Cam ấm của Shipper */
            background: linear-gradient(135deg, #1b4332, #2d6a4f, #ff9800);
            color: #172033;
        }

        .card {
            width: min(920px, calc(100% - 32px));
            display: grid;
            grid-template-columns: 1fr 1fr;
            overflow: hidden;
            border-radius: 24px;
            background: #ffffff;
            box-shadow: 0 24px 70px rgba(0, 0, 0, 0.3);
        }

        .intro {
            padding: 56px;
            color: #ffffff;
            /* Điểm xuyết vòng tròn màu Cam để báo hiệu có đơn hàng mới */
            background: radial-gradient(circle at 20% 15%, #ff9800 0, transparent 28%),
                        linear-gradient(150deg, #4caf50, #1b4332);
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
        }

        .intro .icon-bg {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.9;
            animation: drive 2s ease-in-out infinite alternate;
        }

        .intro h1 {
            margin: 0 0 14px;
            font-size: 40px;
            line-height: 1.1;
            font-weight: 800;
        }

        .intro p {
            max-width: 320px;
            line-height: 1.7;
            opacity: 0.9;
            font-size: 15px;
        }

        .form-panel {
            padding: 44px;
            max-height: 85vh;
            overflow-y: auto; /* Thêm cuộn nhẹ phòng trường hợp màn hình nhỏ */
        }

        .form-panel h2 {
            margin-top: 0;
            font-size: 24px;
            color: #1b4332;
        }

        label {
            display: block;
            margin-top: 14px;
            font-weight: 700;
            font-size: 13px;
            color: #4b5563;
        }

        input, select {
            width: 100%;
            box-sizing: border-box;
            margin-top: 6px;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            outline: none;
            font-size: 14px;
            background-color: #f9fafb;
            transition: all 0.3s ease;
        }

        input:focus, select:focus {
            /* Đổi viền sang màu xanh lá của Shipper */
            border-color: #4caf50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.18);
            background-color: #ffffff;
        }

        button {
            width: 100%;
            margin-top: 24px;
            padding: 14px;
            border: 0;
            border-radius: 999px;
            /* Nút bấm phối màu xanh lá tạo cảm giác tin cậy, an toàn */
            background: #4caf50;
            color: #ffffff;
            font-weight: 800;
            font-size: 15px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
            transition: all 0.3s ease;
        }

        button:hover {
            background: #43a047;
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(76, 175, 80, 0.4);
        }

        .error {
            display: block;
            margin-top: 12px;
            color: #dc2626;
            text-align: center;
            font-style: normal;
            font-size: 14px;
            font-weight: 600;
        }

        .link {
            display: block;
            margin-top: 14px;
            color: #2d6a4f;
            text-align: center;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
        }

        .link:hover {
            text-decoration: underline;
        }

        /* Hiệu ứng xe máy nhún nhảy nhẹ nhàng bên panel giới thiệu */
        @keyframes drive {
            from { transform: translateY(0) rotate(0deg); }
            to { transform: translateY(-8px) rotate(-2deg); }
        }

        @media (max-width: 760px) {
            .card { grid-template-columns: 1fr; }
            .intro, .form-panel { padding: 32px; }
            .intro .icon-bg { font-size: 60px; margin-bottom: 10px; }
        }
    </style>
</head>
<body>
<main class="card">
    <section class="intro">
        <div class="icon-bg">
            <i class="fa-solid fa-motorcycle"></i>
        </div>
        <h1>Gia nhập đội ngũ Shipper POB</h1>
        <p>Thu nhập hấp dẫn, tự chủ thời gian. Đăng ký thông tin tài xế để nhận lịch phỏng vấn và kích hoạt app ngay!</p>
    </section>

    <section class="form-panel">
        <h2>Đăng ký tài khoản tài xế</h2>
        <form action="${pageContext.request.contextPath}/dangky-shipper" method="post" accept-charset="UTF-8">

            <input type="hidden" name="role_id" value="4">

            <label for="fullname">Họ tên tài xế (CCCD)</label>
            <input id="fullname" type="text" name="fullname" value="${fullname}" placeholder="Nhập đầy đủ họ và tên" required>

            <label for="username">Username đăng nhập</label>
            <input id="username" type="text" name="username" value="${username}" placeholder="Ví dụ: taixepob01" required>


            <label for="phone">Số điện thoại nhận cuốc</label>
            <input id="phone" type="tel" name="phone" value="${phone}" placeholder="Nhập số điện thoại liên hệ" pattern="[0-9]{10,11}" required>

            <label for="email">Địa chỉ Email</label>
            <input id="email" type="email" name="email" value="${email}" placeholder="Ví dụ: taixe@gmail.com" required>

            <label for="shipper_region">Khu vực hoạt động</label>
            <select id="shipper_region" name="shipper_region" required>
                <option value="" disabled selected>Chọn khu vực chạy xe</option>
                <option value="KV_TRUNG_TAM">Khu vực các quận Nội thành</option>
                <option value="KV_NGOAI_THANH">Khu vực các quận/huyện Ngoại thành</option>
            </select>

            <label for="password">Mật khẩu</label>
            <input id="password" type="password" name="password" placeholder="Tối thiểu 6 ký tự" minlength="6" required>

            <label for="confirm_password">Xác nhận mật khẩu</label>
            <input id="confirm_password" type="password" name="confirm_password" placeholder="Nhập lại mật khẩu" required>

            <button type="submit">Đăng ký đối tác tài xế</button>
            <i class="error">${loi}</i>
        </form>
        <a class="link" href="${pageContext.request.contextPath}/dangnhap">Đã có tài khoản? Đăng nhập</a>
        <a class="link" href="${pageContext.request.contextPath}/dangky">Đăng ký tài khoản khách hàng mua đồ ăn</a>
    </section>
</main>
</body>
</html>
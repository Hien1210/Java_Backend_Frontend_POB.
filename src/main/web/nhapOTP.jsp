<%@ page pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận OTP</title>
    <style>
        /* Thiết lập màu sắc và font chữ dựa trên hình ảnh */
        :root {
            --bg-dark: #273053;
            --btn-color: #2b3a67;
            --text-dark: #1f2949;
            --border-color: #d1d5e5;
        }

        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: var(--bg-dark);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Container chính chứa 2 phần */
        .card-container {
            display: flex;
            width: 900px;
            height: 550px;
            background: #ffffff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
        }

        /* Phần Form (Bên trái) */
        .form-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px;
            position: relative;
        }

        /* Logo giả lập góc trái trên */
        .logo {
            position: absolute;
            top: 30px;
            left: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: bold;
            color: var(--text-dark);
        }
        .logo-icon {
            width: 24px;
            height: 24px;
            background: var(--btn-color);
            border-radius: 6px;
        }

        /* Tiêu đề và Icon OTP */
        .icon-circle {
            width: 70px;
            height: 70px;
            border: 2px solid var(--btn-color);
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 20px;
        }
        .icon-circle svg {
            width: 35px;
            height: 35px;
            fill: var(--btn-color);
        }

        .form-title {
            color: var(--text-dark);
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 10px;
            text-align: center;
        }

        /* Thông báo email đã gửi OTP */
        .email-notice {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 10px;
            padding: 10px 18px;
            margin-bottom: 20px;
            text-align: center;
            max-width: 320px;
            width: 100%;
            animation: fadeIn 0.4s ease-out;
        }
        .email-notice p {
            margin: 0;
            font-size: 13px;
            color: #166534;
            line-height: 1.5;
        }
        .email-notice .email-address {
            font-weight: 700;
            color: #15803d;
        }

        /* Thông báo lỗi OTP sai */
        .error-alert {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 10px 18px;
            margin-bottom: 16px;
            text-align: center;
            max-width: 320px;
            width: 100%;
            animation: shake 0.4s ease-out;
        }
        .error-alert p {
            margin: 0;
            font-size: 13px;
            color: #dc2626;
            font-weight: 600;
        }

        /* Animation shake khi lỗi */
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            15% { transform: translateX(-6px); }
            30% { transform: translateX(6px); }
            45% { transform: translateX(-4px); }
            60% { transform: translateX(4px); }
            75% { transform: translateX(-2px); }
            90% { transform: translateX(2px); }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Khung nhập OTP */
        .otp-container {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-bottom: 24px;
        }

        input[type="number"] {
            width: 45px;
            height: 55px;
            border: 2px solid var(--border-color);
            border-radius: 12px;
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            color: var(--text-dark);
            outline: none;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input[type="number"]:focus {
            border-color: var(--btn-color);
            box-shadow: 0 0 0 3px rgba(43, 58, 103, 0.12);
        }

        /* Khi OTP sai, viền đỏ cho ô input */
        input[type="number"].input-error {
            border-color: #ef4444;
        }

        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        /* Nút xác nhận */
        .submit-btn {
            width: 100%;
            max-width: 320px;
            padding: 15px;
            border: none;
            border-radius: 30px;
            background-color: var(--btn-color);
            color: white;
            font-size: 14px;
            font-weight: bold;
            letter-spacing: 1px;
            text-transform: uppercase;
            cursor: pointer;
            transition: background 0.3s, transform 0.2s, box-shadow 0.3s;
        }

        .submit-btn:hover {
            background-color: #1a254a;
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(43, 58, 103, 0.3);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
        }

        /* Phần Đồ họa (Bên phải) */
        .graphic-section {
            flex: 1.2;
            position: relative;
            /* Mô phỏng gradient fluid từ hình ảnh */
            background:
                radial-gradient(circle at 20% 0%, #f7e6ca 0%, transparent 40%),
                radial-gradient(circle at 80% 100%, #5ba2d7 0%, transparent 50%),
                radial-gradient(circle at 50% 50%, #1e336b 0%, #1c2b59 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px;
            color: white;
        }

        /* Thanh điều hướng giả lập */
        .nav-mockup {
            position: absolute;
            top: 30px;
            right: 40px;
            display: flex;
            gap: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            align-items: center;
            opacity: 0.8;
        }
        .nav-btn {
            background: var(--btn-color);
            padding: 6px 15px;
            border-radius: 15px;
        }

        .graphic-content h1 {
            font-size: 55px;
            font-weight: 800;
            margin: 0 0 15px 0;
            letter-spacing: -1px;
        }

        .graphic-content p {
            font-size: 13px;
            line-height: 1.6;
            opacity: 0.8;
            max-width: 300px;
        }
    </style>
</head>
<body>

    <div class="card-container">
        <div class="form-section">
            <div class="logo">
                <div class="logo-icon"></div>
                <span>Template<br>Design</span>
            </div>

            <div class="icon-circle">
                <svg viewBox="0 0 24 24">
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>
                </svg>
            </div>

            <div class="form-title">Nhập mã OTP</div>

            <%-- Thông báo OTP đã gửi đến email --%>
            <%
                String emailGui = null;
                // Lấy email từ session (đăng ký hoặc quên mật khẩu)
                if (session.getAttribute("email") != null) {
                    emailGui = (String) session.getAttribute("email");
                } else if (session.getAttribute("forgotPasswordEmail") != null) {
                    emailGui = (String) session.getAttribute("forgotPasswordEmail");
                }
                if (emailGui != null && !emailGui.isEmpty()) {
                    // Che bớt email: abc***@gmail.com
                    String emailAn = emailGui;
                    int atIndex = emailGui.indexOf("@");
                    if (atIndex > 3) {
                        emailAn = emailGui.substring(0, 3) + "***" + emailGui.substring(atIndex);
                    } else if (atIndex > 0) {
                        emailAn = emailGui.substring(0, 1) + "***" + emailGui.substring(atIndex);
                    }
            %>
            <div class="email-notice">
                <p>📧 Mã OTP đã được gửi đến<br><span class="email-address"><%= emailAn %></span></p>
            </div>
            <% } %>

            <%-- Thông báo lỗi khi OTP sai --%>
            <%
                String loi = (String) request.getAttribute("loi");
                boolean coLoi = (loi != null && !loi.isEmpty());
                if (coLoi) {
            %>
            <div class="error-alert">
                <p>⚠️ <%= loi %></p>
            </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/xacnhanotp" method="post">
                <div class="otp-container">
                    <input type="number" name="otp1" min="0" max="9" required class="<%= coLoi ? "input-error" : "" %>">
                    <input type="number" name="otp2" min="0" max="9" required class="<%= coLoi ? "input-error" : "" %>">
                    <input type="number" name="otp3" min="0" max="9" required class="<%= coLoi ? "input-error" : "" %>">
                    <input type="number" name="otp4" min="0" max="9" required class="<%= coLoi ? "input-error" : "" %>">
                    <input type="number" name="otp5" min="0" max="9" required class="<%= coLoi ? "input-error" : "" %>">
                    <input type="number" name="otp6" min="0" max="9" required class="<%= coLoi ? "input-error" : "" %>">
                </div>
                <button type="submit" class="submit-btn">Xác nhận</button>
            </form>
        </div>

        <div class="graphic-section">
            <div class="nav-mockup">
                <span>About</span>
                <span>Download</span>
                <span>Pricing</span>
                <span class="nav-btn">Sign In</span>
            </div>

            <div class="graphic-content">
                <h1>Welcome.</h1>
                <p>Vui lòng kiểm tra email hoặc tin nhắn điện thoại để lấy mã xác thực gồm 6 chữ số và nhập vào ô trống bên cạnh để tiếp tục.</p>
            </div>
        </div>
    </div>

    <script>
        const inputs = document.querySelectorAll('.otp-container input');

        inputs.forEach((input, index) => {
            // Tự động xóa class lỗi khi người dùng nhập lại
            input.addEventListener('focus', function() {
                this.classList.remove('input-error');
            });

            input.addEventListener('input', function() {
                if (this.value.length > 1) {
                    this.value = this.value.slice(0, 1);
                }
                if (this.value !== '' && index < inputs.length - 1) {
                    inputs[index + 1].focus();
                }
            });

            input.addEventListener('keydown', function(e) {
                if (e.key === 'Backspace' && this.value === '' && index > 0) {
                    inputs[index - 1].focus();
                }
            });
        });

        // Auto-focus ô đầu tiên khi load trang
        if (inputs.length > 0) {
            inputs[0].focus();
        }
    </script>
</body>
</html>
<%@ page pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký hệ thống</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Montserrat', sans-serif;
            background-color: #273155;
            background-image: url(/image.png);
            background-size: cover;
            background-repeat: no-repeat;
        }

        /* Scrollbar ẩn cho form panel */
        .form-panel::-webkit-scrollbar {
            width: 4px;
        }
        .form-panel::-webkit-scrollbar-track {
            background: transparent;
        }
        .form-panel::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }

        /* Placeholder styling */
        ::placeholder {
            color: #94a3b8;
            font-weight: 500;
            font-size: 12px;
            letter-spacing: 0.3px;
        }

        input:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 30px white inset !important;
        }

        /* Focus ring animation */
        .input-field {
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .input-field:focus {
            border-color: #273155;
            box-shadow: 0 0 0 3px rgba(39, 49, 85, 0.1);
        }

        /* Button hover animation */
        .btn-primary {
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(39, 49, 85, 0.35);
        }
        .btn-primary:active {
            transform: translateY(0);
        }

        /* Link hover effects */
        .register-link {
            transition: all 0.3s ease;
        }
        .register-link:hover {
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        /* Fade in animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .animate-fade-in {
            animation: fadeInUp 0.5s ease-out forwards;
        }

        /* Error/Success message styling */
        .error-msg {
            color: #dc2626;
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 8px;
            padding: 6px 12px;
            font-size: 11px;
            font-style: normal;
            display: block;
            text-align: center;
        }
        .success-msg {
            color: #16a34a;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 8px;
            padding: 6px 12px;
            font-size: 11px;
            font-style: normal;
            display: block;
            text-align: center;
        }

        /* Divider */
        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            height: 1px;
            background: #e2e8f0;
        }
    </style>
</head>

<script>
    function validatePassword() {
        var password = document.getElementById("password").value;
        var confirm = document.getElementById("confirm_password").value;
        var errorMsg = document.getElementById("passwordError");

        // Loại bỏ khoảng trắng đầu và cuối để kiểm tra
        var trimmedPassword = password.trim();
        var trimmedConfirm = confirm.trim();

        // Kiểm tra mật khẩu trống
        if (trimmedPassword.length === 0) {
            errorMsg.innerHTML = "⚠️ Mật khẩu không được để trống!";
            errorMsg.className = "error-msg";
            return false;
        }

        // Kiểm tra độ dài (8-16 ký tự)
        if (trimmedPassword.length < 8 || trimmedPassword.length > 16) {
            errorMsg.innerHTML = "⚠️ Mật khẩu phải có độ dài từ 8 đến 16 ký tự!";
            errorMsg.className = "error-msg";
            return false;
        }

        // Kiểm tra không chứa khoảng trắng
        if (trimmedPassword.includes(" ")) {
            errorMsg.innerHTML = "⚠️ Mật khẩu không được chứa khoảng trắng!";
            errorMsg.className = "error-msg";
            return false;
        }

        // Kiểm tra mật khẩu xác nhận
        if (trimmedPassword !== trimmedConfirm) {
            errorMsg.innerHTML = "⚠️ Mật khẩu xác nhận không khớp!";
            errorMsg.className = "error-msg";
            return false;
        }

        // Hợp lệ, xóa thông báo lỗi
        errorMsg.innerHTML = "";
        errorMsg.className = "";
        return true;
    }

    function togglePassword(id, btn) {
        var input = document.getElementById(id);
        var show = btn.querySelector('.eye-show');
        var hide = btn.querySelector('.eye-hide');
        if (input.type === 'password') {
            input.type = 'text';
            show.classList.add('hidden');
            hide.classList.remove('hidden');
        } else {
            input.type = 'password';
            show.classList.remove('hidden');
            hide.classList.add('hidden');
        }
    }
</script>

<body class="flex items-center justify-center min-h-screen p-4 sm:p-8">

    <div class="flex w-full max-w-[1050px] bg-white rounded-3xl overflow-hidden shadow-2xl animate-fade-in"
         style="min-height: 640px;">

        <!-- ===== LEFT PANEL: FORM ===== -->
        <div class="form-panel w-full md:w-[44%] px-8 py-7 flex flex-col relative z-10 bg-white overflow-y-auto">

            <!-- Header -->
            <div class="mb-5">
                <div class="flex items-center gap-2 mb-4 text-[#1f284f] font-bold text-sm tracking-wide">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="2" y="6" width="14" height="14" rx="4" fill="#1f284f"/>
                        <rect x="8" y="2" width="14" height="14" rx="4" fill="#1f284f" fill-opacity="0.5"/>
                    </svg>
                    Đăng Ký
                </div>

                <div class="flex justify-center">
                    <div class="w-14 h-14 rounded-full bg-gradient-to-br from-[#273155] to-[#3d4f7c] flex items-center justify-center text-white shadow-lg">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                    </div>
                </div>
            </div>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dangky" method="post"
                  onsubmit="return validatePassword()" class="flex flex-col space-y-3">

                <input type="hidden" name="role_id" value="3">

                <!-- Họ và tên -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                    </div>
                    <input type="text" name="fullname" value="${param.fullname}" required placeholder="Họ và tên"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm rounded-xl focus:border-[#273155] block pl-10 py-2.5 outline-none">
                </div>

                <!-- Username -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2"></path>
                        </svg>
                    </div>
                    <input type="text" name="username" value="${param.username}" required placeholder="Username"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm rounded-xl focus:border-[#273155] block pl-10 py-2.5 outline-none">
                </div>

                <!-- Số điện thoại -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path>
                        </svg>
                    </div>
                    <input type="tel" name="phone" value="${param.phone}" required placeholder="Số điện thoại"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm rounded-xl focus:border-[#273155] block pl-10 py-2.5 outline-none">
                </div>

                <!-- Email -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                        </svg>
                    </div>
                    <input type="email" name="email" value="${param.email}" required placeholder="Email"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm rounded-xl focus:border-[#273155] block pl-10 py-2.5 outline-none">
                </div>

                <!-- Mật khẩu -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                        </svg>
                    </div>
                    <input type="password" name="password" id="password" required placeholder="Mật khẩu (8-16 ký tự)"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm rounded-xl focus:border-[#273155] block pl-10 pr-10 py-2.5 outline-none">
                    <button type="button" onclick="togglePassword('password', this)"
                            class="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-[#273155]">
                        <svg class="eye-show w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        <svg class="eye-hide w-4 h-4 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3l18 18M10.584 10.587a2 2 0 002.828 2.83M9.363 5.365A9.466 9.466 0 0112 5c4.478 0 8.268 2.943 9.542 7a10.39 10.39 0 01-1.563 2.94M6.228 6.227A10.45 10.45 0 002.458 12c1.274 4.057 5.065 7 9.542 7a9.46 9.46 0 004.635-1.227"></path>
                        </svg>
                    </button>
                </div>

                <!-- Xác nhận mật khẩu -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                        </svg>
                    </div>
                    <input type="password" name="confirm_password" id="confirm_password" required placeholder="Xác nhận mật khẩu"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm rounded-xl focus:border-[#273155] block pl-10 pr-10 py-2.5 outline-none">
                    <button type="button" onclick="togglePassword('confirm_password', this)"
                            class="absolute inset-y-0 right-0 pr-4 flex items-center text-gray-400 hover:text-[#273155]">
                        <svg class="eye-show w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                        </svg>
                        <svg class="eye-hide w-4 h-4 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3l18 18M10.584 10.587a2 2 0 002.828 2.83M9.363 5.365A9.466 9.466 0 0112 5c4.478 0 8.268 2.943 9.542 7a10.39 10.39 0 01-1.563 2.94M6.228 6.227A10.45 10.45 0 002.458 12c1.274 4.057 5.065 7 9.542 7a9.46 9.46 0 004.635-1.227"></path>
                        </svg>
                    </button>
                </div>

                <!-- Password Error -->
                <div id="passwordError" class="text-center"></div>

                <!-- Server Error/Success Messages -->
                <% if (request.getAttribute("loi") != null && !((String)request.getAttribute("loi")).isEmpty()) { %>
                    <div class="error-msg"><%= request.getAttribute("loi") %></div>
                <% } %>
                <% if (request.getAttribute("thongbao") != null && !((String)request.getAttribute("thongbao")).isEmpty()) { %>
                    <div class="success-msg"><%= request.getAttribute("thongbao") %></div>
                <% } %>

                <!-- Điều khoản checkbox -->
                <label class="flex items-center cursor-pointer gap-2 pt-1">
                    <input type="checkbox" required class="w-4 h-4 text-[#273155] bg-gray-100 border-gray-300 rounded focus:ring-[#273155] accent-[#273155]">
                    <span class="text-xs font-medium text-gray-500">Tôi đồng ý với <a href="#" class="text-[#273155] font-semibold hover:underline">điều khoản sử dụng</a></span>
                </label>

                <!-- Nút đăng ký -->
                <button type="submit" class="btn-primary w-full text-white bg-gradient-to-r from-[#273155] to-[#3d4f7c] hover:from-[#1f284f] hover:to-[#334170] font-bold rounded-xl text-sm px-5 py-3 text-center tracking-wide shadow-md">
                    Đăng ký khách hàng
                </button>

                <!-- Đã có tài khoản -->
                <p class="text-center text-xs text-gray-500 pt-1">
                    Đã có tài khoản?
                    <a href="${pageContext.request.contextPath}/dangnhap" class="text-[#273155] font-bold hover:underline">Đăng nhập ngay</a>
                </p>
            </form>

            <!-- Đăng ký loại tài khoản khác -->
            <div class="mt-4 pt-3">
                <p class="divider text-[10px] font-semibold text-gray-400 uppercase tracking-widest mb-3">
                    Hoặc đăng ký với vai trò
                </p>
                <div class="flex gap-3">
                    <a href="${pageContext.request.contextPath}/dangky-shop"
                       class="register-link flex-1 text-center border-2 border-gray-200 hover:border-[#1976D2] hover:text-[#1976D2] text-gray-500 font-bold rounded-xl text-[11px] py-2.5 tracking-wide bg-gray-50/50">
                        🏪 Shop
                    </a>
                    <a href="${pageContext.request.contextPath}/dangky-shipper"
                       class="register-link flex-1 text-center border-2 border-gray-200 hover:border-[#4CAF50] hover:text-[#4CAF50] text-gray-500 font-bold rounded-xl text-[11px] py-2.5 tracking-wide bg-gray-50/50">
                        🛵 Shipper
                    </a>
                </div>
            </div>
        </div>

        <!-- ===== RIGHT PANEL: DECORATIVE ===== -->
        <div class="hidden md:flex md:w-[56%] relative overflow-hidden bg-[#223f7c] items-center justify-center">
            <!-- Gradient blobs -->
            <div class="absolute -top-[10%] -right-[10%] w-[80%] h-[80%] bg-[#f4dcb7] rounded-full mix-blend-screen filter blur-[80px] opacity-90"></div>
            <div class="absolute -bottom-[20%] -left-[10%] w-[90%] h-[90%] bg-[#5ba0d0] rounded-full mix-blend-screen filter blur-[100px] opacity-80"></div>
            <div class="absolute top-[20%] left-[20%] w-[60%] h-[120%] bg-[#1c2c5c] rounded-full mix-blend-multiply filter blur-[70px] transform -rotate-45"></div>

            <!-- Nav icon -->
            <nav class="absolute top-0 w-full flex justify-end px-10 py-8 z-20">
                <button>
                    <svg class="w-5 h-5 text-white opacity-70 hover:opacity-100 transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
                </button>
            </nav>

            <!-- Welcome text -->
            <div class="relative z-20 px-14 text-center">
                <h1 class="text-white text-5xl lg:text-6xl font-extrabold tracking-tight leading-tight mb-4">
                    Welcome<br>Guest
                </h1>
                <p class="text-white/60 text-sm font-medium max-w-xs mx-auto">
                    Tạo tài khoản để trải nghiệm mua sắm tuyệt vời cùng chúng tôi
                </p>
            </div>
        </div>

    </div>
</body>
</html>
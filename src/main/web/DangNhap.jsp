<%@ page pageEncoding="utf-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống</title>
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
            font-size: 13px;
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
            text-transform: uppercase;
        }
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(39, 49, 85, 0.35);
        }
        .btn-primary:active {
            transform: translateY(0);
        }

        /* Link hover effects */
        .custom-link {
            transition: all 0.3s ease;
        }
        .custom-link:hover {
            color: #273155;
            text-decoration: underline;
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
            animation: shake 0.4s ease-out;
        }
        .error-msg-block {
            color: #dc2626;
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 13px;
            font-style: normal;
            font-weight: 600;
            display: block;
            text-align: center;
            margin-bottom: 16px;
            animation: shake 0.4s ease-out;
        }
        .success-msg {
            color: #16a34a;
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 13px;
            font-style: normal;
            font-weight: 600;
            display: block;
            text-align: center;
            margin-bottom: 16px;
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
    </style>
</head>

<body class="flex items-center justify-center min-h-screen p-4 sm:p-8">

    <div class="flex w-full max-w-[1050px] bg-white rounded-3xl overflow-hidden shadow-2xl animate-fade-in"
         style="min-height: 550px; max-height: 600px;">

        <!-- ===== LEFT PANEL: FORM ===== -->
        <div class="form-panel w-full md:w-[44%] px-8 py-10 flex flex-col justify-center relative z-10 bg-white overflow-y-auto">

            <!-- Header -->
            <div class="mb-8">
                <div class="flex items-center gap-2 mb-6 text-[#1f284f] font-bold text-sm tracking-wide">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="2" y="6" width="14" height="14" rx="4" fill="#1f284f"/>
                        <rect x="8" y="2" width="14" height="14" rx="4" fill="#1f284f" fill-opacity="0.5"/>
                    </svg>
                    Đăng Nhập
                </div>

                <div class="flex justify-center">
                    <div class="w-16 h-16 rounded-full bg-gradient-to-br from-[#273155] to-[#3d4f7c] flex items-center justify-center text-white shadow-lg">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Server Error/Success Messages -->
            <%
                String loi = (String) request.getAttribute("loi");
                if (loi != null && !loi.trim().isEmpty()) {
            %>
                <div class="error-msg-block">⚠️ <%= loi %></div>
            <% } %>

            <%
                String thongbao = (String) request.getAttribute("thongbao");
                if (thongbao != null && !thongbao.trim().isEmpty()) {
            %>
                <div class="success-msg">✅ <%= thongbao %></div>
            <% } %>

            <!-- Form -->
            <form action="${pageContext.request.contextPath}/dangnhap" method="post" onsubmit="return validateLogin()" class="flex flex-col space-y-4">

                <!-- Username -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H5a2 2 0 00-2 2v9a2 2 0 002 2h14a2 2 0 002-2V8a2 2 0 00-2-2h-5m-4 0V5a2 2 0 114 0v1m-4 0a2 2 0 104 0m-5 8a2 2 0 100-4 2 2 0 000 4zm0 0c1.306 0 2.417.835 2.83 2M9 14a3.001 3.001 0 00-2.83 2M15 11h3m-3 4h2"></path>
                        </svg>
                    </div>
                    <input type="text" name="username" value="${param.username}" required placeholder="Tên đăng nhập"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none">
                </div>

                <!-- Mật khẩu -->
                <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                        <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                        </svg>
                    </div>
                    <input type="password" name="password" id="password" required placeholder="Mật khẩu"
                           class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 pr-10 py-3.5 outline-none">
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

                <!-- Password client-side error -->
                <div id="loginPasswordError" class="text-center"></div>

                <!-- Quên mật khẩu link -->
                <div class="flex justify-end pt-1">
                    <a href="${pageContext.request.contextPath}/quenmatkhau" class="custom-link text-xs font-semibold text-gray-500">
                        Quên mật khẩu?
                    </a>
                </div>

                <!-- Nút đăng nhập -->
                <button type="submit" class="btn-primary w-full text-white bg-gradient-to-r from-[#273155] to-[#3d4f7c] hover:from-[#1f284f] hover:to-[#334170] font-bold rounded-xl text-sm px-5 py-3.5 text-center tracking-wide shadow-md mt-2">
                    Đăng Nhập
                </button>

                <!-- Chưa có tài khoản -->
                <div class="text-center pt-4 border-t border-gray-100 mt-6">
                    <p class="text-sm text-gray-500 font-medium">
                        Chưa có tài khoản?
                        <a href="${pageContext.request.contextPath}/dangky" class="custom-link text-[#273155] font-bold">Đăng ký ngay</a>
                    </p>
                </div>
            </form>
        </div>

        <script>
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

            function validateLogin() {
                var password = document.getElementById("password").value;
                var errorMsg = document.getElementById("loginPasswordError");

                var trimmedPassword = password.trim();

                if (trimmedPassword.length === 0) {
                    errorMsg.innerHTML = "⚠️ Mật khẩu không được để trống!";
                    errorMsg.className = "error-msg";
                    return false;
                }

                if (trimmedPassword.length < 8 || trimmedPassword.length > 16) {
                    errorMsg.innerHTML = "⚠️ Mật khẩu phải có độ dài từ 8 đến 16 ký tự!";
                    errorMsg.className = "error-msg";
                    return false;
                }

                if (trimmedPassword.includes(" ")) {
                    errorMsg.innerHTML = "⚠️ Mật khẩu không được chứa khoảng trắng!";
                    errorMsg.className = "error-msg";
                    return false;
                }

                errorMsg.innerHTML = "";
                errorMsg.className = "";
                return true;
            }
        </script>

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
                    Welcome<br>Back
                </h1>
                <p class="text-white/60 text-sm font-medium max-w-xs mx-auto">
                    Đăng nhập để tiếp tục trải nghiệm và quản lý tài khoản của bạn
                </p>
            </div>
        </div>

    </div>
</body>
</html>

<%@ page pageEncoding="utf-8"%>
<%
    boolean resetStep = "reset".equals(request.getAttribute("step"));
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= resetStep ? "Đặt lại mật khẩu" : "Quên mật khẩu" %></title>
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
                <div class="flex items-center gap-2 mb-6 text-[#1f284f] font-bold text-sm tracking-wide uppercase">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <rect x="2" y="6" width="14" height="14" rx="4" fill="#1f284f"/>
                        <rect x="8" y="2" width="14" height="14" rx="4" fill="#1f284f" fill-opacity="0.5"/>
                    </svg>
                    <%= resetStep ? "Đặt Lại Mật Khẩu" : "Quên Mật Khẩu" %>
                </div>

                <div class="flex justify-center">
                    <div class="w-16 h-16 rounded-full bg-gradient-to-br from-[#273155] to-[#3d4f7c] flex items-center justify-center text-white shadow-lg">
                        <svg class="w-8 h-8" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 1 3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 6c1.66 0 3 1.34 3 3 0 1.3-.84 2.42-2 2.83V17h-2v-4.17c-1.16-.41-2-1.53-2-2.83 0-1.66 1.34-3 3-3z"/>
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
            <script>
                function validateResetPassword() {
                    var password = document.getElementById("newPassword").value;
                    var confirm = document.getElementById("confirmPassword").value;
                    var errorMsg = document.getElementById("resetPasswordError");

                    var trimmedPassword = password.trim();
                    var trimmedConfirm = confirm.trim();

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

                    if (trimmedPassword !== trimmedConfirm) {
                        errorMsg.innerHTML = "⚠️ Mật khẩu xác nhận không khớp!";
                        errorMsg.className = "error-msg";
                        return false;
                    }

                    errorMsg.innerHTML = "";
                    errorMsg.className = "";
                    return true;
                }
            </script>
            <% if (!resetStep) { %>
                <!-- Form gửi OTP -->
                <form action="${pageContext.request.contextPath}/quenmatkhau" method="post" class="flex flex-col space-y-4">
                    <input type="hidden" name="action" value="sendOtp">

                    <!-- Email -->
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path>
                            </svg>
                        </div>
                        <input type="email" name="email" required placeholder="Email đã đăng ký"
                               class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none">
                    </div>

                    <!-- Nút Gửi OTP -->
                    <button type="submit" class="btn-primary w-full text-white bg-gradient-to-r from-[#273155] to-[#3d4f7c] hover:from-[#1f284f] hover:to-[#334170] font-bold rounded-xl text-sm px-5 py-3.5 text-center tracking-wide shadow-md mt-2">
                        GỬI OTP
                    </button>
                </form>
            <% } else { %>
                <!-- Form reset password -->
                <form action="${pageContext.request.contextPath}/quenmatkhau" method="post" onsubmit="return validateResetPassword()" class="flex flex-col space-y-4">
                    <input type="hidden" name="action" value="reset">

                    <!-- OTP -->
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
                            </svg>
                        </div>
                        <input type="text" name="otp" placeholder="Mã OTP 6 số" maxlength="6" pattern="[0-9]{6}" inputmode="numeric" required
                               class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-bold rounded-xl focus:border-[#273155] block py-3.5 outline-none tracking-[10px] text-center" style="padding-left: 20px;">
                    </div>

                    <!-- Mật khẩu mới -->
                    <div>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                                </svg>
                            </div>
                            <input type="password" id="passwordInput" name="password" placeholder="Mật khẩu mới (8–16 ký tự)" required
                                   class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none">
                        </div>

                        <span id="passwordError" class="hidden text-red-500 text-xs font-semibold mt-1 pl-1 block"></span>

                        <input type="password" name="password" id="newPassword" placeholder="Mật khẩu mới (8-16 ký tự)" required
                               class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none">
 

                        <input type="password" id="passwordInput" name="password" placeholder="Mật khẩu mới (8–16 ký tự)" required
                               class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none"
                               oninput="validatePassword()">
                        <span id="passwordError" class="hidden text-red-600 text-xs font-semibold mt-1 block pl-1"></span>
                    </div>

                    <!-- Xác nhận mật khẩu -->
                    <div>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                                <svg class="w-4 h-4 text-[#273155] opacity-60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
                                </svg>
                            </div>
                            <input type="password" id="confirmPasswordInput" name="confirm_password" placeholder="Xác nhận mật khẩu" required
                                   class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none">
                        </div>
                        <span id="confirmPasswordError" class="hidden text-red-500 text-xs font-semibold mt-1 pl-1 block"></span>
                        <input type="password" name="confirm_password" id="confirmPassword" placeholder="Xác nhận mật khẩu" required
                               class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none">
                         <input type="password" id="confirmPasswordInput" name="confirm_password" placeholder="Xác nhận mật khẩu" required
                               class="input-field w-full border-2 border-gray-200 text-gray-800 text-sm font-medium rounded-xl focus:border-[#273155] block pl-10 py-3.5 outline-none"
                               oninput="validateConfirm()">
                        <span id="confirmError" class="hidden text-red-600 text-xs font-semibold mt-1 block pl-1"></span>
                    </div>

                    <!-- Password client-side error -->
                    <div id="resetPasswordError" class="text-center"></div>

                    <!-- Nút Đổi mật khẩu -->
                    <button type="submit" class="btn-primary w-full text-white bg-gradient-to-r from-[#273155] to-[#3d4f7c] hover:from-[#1f284f] hover:to-[#334170] font-bold rounded-xl text-sm px-5 py-3.5 text-center tracking-wide shadow-md mt-2">
                        ĐỔI MẬT KHẨU
                    </button>
                </form>

                <script>
                    (function() {
                        var pwdInput = document.getElementById('passwordInput');
                        var cfmInput = document.getElementById('confirmPasswordInput');
                        var pwdError = document.getElementById('passwordError');
                        var cfmError = document.getElementById('confirmPasswordError');

                        function validatePassword(val) {
                            if (val.length === 0) return null;
                            if (/\s/.test(val)) return 'Mật khẩu không được chứa khoảng trống!';
                            if (val.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự!';
                            if (val.length > 16) return 'Mật khẩu không được vượt quá 16 ký tự!';
                            return null;
                        }

                        function showError(el, msg) {
                            if (msg) {
                                el.textContent = '⚠️ ' + msg;
                                el.classList.remove('hidden');
                            } else {
                                el.textContent = '';
                                el.classList.add('hidden');
                            }
                        }

                        pwdInput.addEventListener('input', function() {
                            showError(pwdError, validatePassword(this.value));
                            if (cfmInput.value.length > 0) {
                                showError(cfmError, this.value !== cfmInput.value ? 'Mật khẩu xác nhận không khớp!' : null);
                            }
                        });

                        cfmInput.addEventListener('input', function() {
                            showError(cfmError, this.value.length > 0 && pwdInput.value !== this.value ? 'Mật khẩu xác nhận không khớp!' : null);
                        });

                        pwdInput.closest('form').addEventListener('submit', function(e) {
                            var pwd = pwdInput.value;
                            var pwdMsg = validatePassword(pwd);
                            showError(pwdError, pwdMsg);

                            var cfmMsg = null;
                            if (!pwdMsg && cfmInput.value !== pwd) {
                                cfmMsg = 'Mật khẩu xác nhận không khớp!';
                            }
                            showError(cfmError, cfmMsg);

                            if (pwdMsg || cfmMsg) {
                                e.preventDefault();
                            }
                        });
                    })();

                function validatePassword() {
                    var val = document.getElementById('passwordInput').value;
                    var err = document.getElementById('passwordError');
                    if (val.indexOf(' ') !== -1) {
                        err.textContent = '⚠ Mật khẩu không được chứa khoảng trắng.';
                        err.classList.remove('hidden');
                    } else if (val.length > 0 && (val.length < 8 || val.length > 16)) {
                        err.textContent = '⚠ Mật khẩu phải từ 8 đến 16 ký tự.';
                        err.classList.remove('hidden');
                    } else {
                        err.textContent = '';
                        err.classList.add('hidden');
                    }
                    validateConfirm();
                }

                function validateConfirm() {
                    var pw = document.getElementById('passwordInput').value;
                    var cf = document.getElementById('confirmPasswordInput').value;
                    var err = document.getElementById('confirmError');
                    if (cf.length > 0 && pw !== cf) {
                        err.textContent = '⚠ Mật khẩu xác nhận không khớp.';
                        err.classList.remove('hidden');
                    } else {
                        err.textContent = '';
                        err.classList.add('hidden');
                    }
                }

                document.querySelector('form[action*="quenmatkhau"]').addEventListener('submit', function(e) {
                    var pw = document.getElementById('passwordInput').value;
                    if (pw.indexOf(' ') !== -1 || pw.length < 8 || pw.length > 16) {
                        e.preventDefault();
                        validatePassword();
                        return;
                    }
                    var cf = document.getElementById('confirmPasswordInput').value;
                    if (pw !== cf) {
                        e.preventDefault();
                        validateConfirm();
                    }
                });
                </script>
            <% } %>

            <!-- Quay lại đăng nhập -->
            <div class="text-center pt-4 border-t border-gray-100 mt-6">
                <a href="${pageContext.request.contextPath}/dangnhap" class="custom-link text-[#273155] text-sm font-bold">
                    ← Quay lại đăng nhập
                </a>
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
                    <%= resetStep ? "Reset<br>Password" : "Forgot<br>Password" %>
                </h1>
                <p class="text-white/60 text-sm font-medium max-w-xs mx-auto">
                    <%= resetStep ? "Nhập mã OTP 6 số và mật khẩu mới để hoàn tất việc khôi phục tài khoản." : "Nhập địa chỉ email của bạn để nhận mã xác thực OTP và tạo mật khẩu mới." %>
                </p>
            </div>
        </div>

    </div>
</body>
</html>
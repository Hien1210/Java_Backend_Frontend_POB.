package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.AccountDAO;
import org.example.daos.AccountDAOImpl;
import org.example.utils.EmailUtil;
import org.mindrot.jbcrypt.BCrypt;

import javax.mail.MessagingException;
import java.io.IOException;
import java.util.Random;
import java.time.LocalDateTime;


@WebServlet("/dangky")
public class DangKyServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {


        AccountDAO dao = new AccountDAOImpl();

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirm_password");
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");


        //Loại bỏ khoảng trắng đầu và cuối
        password = password.trim();
        confirmPassword = confirmPassword.trim();

        //Kiểm tra mật khẩu không được để trống sau khi trim
        if (password.isEmpty()) {
            req.setAttribute("loi", "Mật khẩu không được để trống!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        //Kiểm tra độ dài mật khẩu (8-16 ký tự)
        if (password.length() < 8 || password.length() > 16) {
            req.setAttribute("loi", "Mật khẩu phải có độ dài từ 8 đến 16 ký tự!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 0b. Kiểm tra mật khẩu không chứa khoảng trắng
        if (password.contains(" ")) {
            req.setAttribute("loi", "Mật khẩu không được chứa khoảng trắng!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }


        // 1. Mật khẩu không khớp
        if (!password.equals(confirmPassword)) {
            req.setAttribute("loi", "Mật khẩu không khớp!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return; // ← BẮT BUỘC có return
        }

        // 2. Email đã tồn tại
        if (dao.tonTaiEmail(email)) {
            req.setAttribute("loi", "Email đã được đăng ký!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return; // ← BẮT BUỘC có return
        }

        // 3. Username đã tồn tại
        if (dao.tonTaiUsername(username)) {
            req.setAttribute("loi", "Username đã được đăng ký!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return; // ← BẮT BUỘC có return
        }

        // 4. Hash password
        String mkMaHoa = BCrypt.hashpw(password, BCrypt.gensalt(12));

        // 5. Tạo OTP — dùng SecureRandom thay vì Random
        String otp = String.format("%06d",
                new java.security.SecureRandom().nextInt(1000000));

        // 6. Gửi email OTP
        try {
            String htmlContent = buildOtpEmail(otp, email);
            EmailUtil.sendEmail(email, "🔐 Xác nhận đăng ký tài khoản POB", htmlContent);
            System.out.println("📧 Email OTP đã gửi đến: " + email);
        } catch (MessagingException e) {
            System.out.println("❌ Lỗi gửi email: " + e.getMessage());
            req.setAttribute("loi", "Không thể gửi email, vui lòng thử lại!");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }


        // 7. Lưu thông tin vào SESSION để dùng sau khi xác nhận OTP
        //    CHƯA lưu vào DB — đợi OTP đúng mới lưu
        HttpSession session = req.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("username", username);
        session.setAttribute("password", mkMaHoa);
        session.setAttribute("fullname", fullname);
        session.setAttribute("phone", phone);
        session.setAttribute("email", email);
        session.setAttribute("registerRoleId", 3L);

        resp.sendRedirect(req.getContextPath() + "/xacnhanotp");
    }

        private String buildOtpEmail (String otp, String email){
            return """
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Xác nhận OTP</title>
                    </head>
                    <body style="margin:0;padding:0;font-family:'Segoe UI',Arial,sans-serif;background:#f4f7fb;">
                        <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%%" style="max-width:600px;margin:40px auto;background:#ffffff;border-radius:16px;box-shadow:0 8px 32px rgba(0,0,0,0.08);overflow:hidden;">
                            <tr>
                                <td style="background:linear-gradient(135deg,#1a1a2e,#273053);padding:32px 40px;text-align:center;">
                                    <h1 style="color:#ffffff;font-size:24px;font-weight:700;margin:0;letter-spacing:1px;">🍔 POB</h1>
                                    <p style="color:rgba(255,255,255,0.6);font-size:13px;margin:6px 0 0;letter-spacing:2px;">HỆ THỐNG ĐẶT HÀNG</p>
                                </td>
                            </tr>
                            <tr>
                                <td style="padding:40px 40px 30px;">
                                    <h2 style="color:#1a1a2e;font-size:20px;font-weight:600;margin:0 0 8px;">Xác nhận đăng ký</h2>
                                    <p style="color:#666;font-size:15px;line-height:1.6;margin:0 0 24px;">
                                        Chào bạn,<br>
                                        Vui lòng nhập mã OTP dưới đây để hoàn tất đăng ký tài khoản POB.
                                    </> 
                                    <div style="background:#f8f9fc;border-radius:12px;padding:28px;text-align:center;border:1px dashed #d1d5e5;margin-bottom:24px;">
                                        <div style="font-size:11px;color:#888;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:8px;">Mã xác thực (OTP)</div>
                                        <div style="font-size:36px;font-weight:800;color:#273053;letter-spacing:8px;font-family:'Courier New',monospace;">%s</div>
                                        <div style="font-size:12px;color:#999;margin-top:10px;">⏳ Hiệu lực trong <strong>5 phút</strong></div>
                                    </div>
                    
                                    <div style="background:#f0fdf4;border-radius:8px;padding:14px 18px;border-left:4px solid #20d489;margin-bottom:24px;">
                                        <p style="color:#166534;font-size:13px;margin:0;">📧 Email đăng ký: <strong>%s</strong></p>
                                    </div>
                    
                                    <p style="color:#888;font-size:13px;line-height:1.6;margin:0 0 8px;">
                                        Nếu bạn không yêu cầu đăng ký, vui lòng bỏ qua email này.
                                    </p>
                                    <p style="color:#aaa;font-size:12px;margin:0;">
                                        Mã OTP có hiệu lực trong 5 phút. Không chia sẻ mã này với bất kỳ ai.
                                    </p>
                                </td>
                            </tr>
                            <tr>
                                <td style="background:#f8f9fc;padding:20px 40px;text-align:center;border-top:1px solid #e9ecef;">
                                    <p style="color:#999;font-size:12px;margin:0;">
                                        © 2025 POB - Hệ thống đặt hàng<br>
                                        <span style="color:#bbb;">Email này được gửi tự động, vui lòng không trả lời.</span>
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </body>
                    </html>
                    """.formatted(otp, email);

    }
}

package org.example.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.models.Account;

import java.io.IOException;

/**
 * AuthFilter bảo vệ khu vực /admin/*
 * - role 1 (Super Admin): chỉ vào được /admin/super_admin/** (trang tổng quan,
 * duyệt shop,...)
 * - role 2 (Shop Owner): vào được /admin/trangcuahang.jsp và các trang quản lý
 * shop
 *
 * Phân quyền chi tiết hơn theo sub-path:
 * /admin/super_admin/** → chỉ role 1
 * /admin/** → role 1 hoặc role 2
 */
@WebFilter(urlPatterns = "/admin/*")
public class AuthFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        System.out.println("=== AuthFilter ===");
        System.out.println("URL: " + req.getRequestURI());

        // ✅ LẤY SESSION ĐÚNG CÁCH
        HttpSession session = req.getSession(false);
        Account acc = null;

        if (session != null) {
            Object obj = session.getAttribute("account");
            System.out.println("Session attribute 'account': " + obj);
            if (obj instanceof Account) {
                acc = (Account) obj;
                System.out.println("Account role: " + acc.getRoleId());
            }
        }

        // Chưa đăng nhập → về trang đăng nhập
        if (acc == null) {
            System.out.println("Chưa đăng nhập, redirect về /dangnhap");
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        String uri = req.getRequestURI();

        // /admin/** → cho phép role 1 (Super Admin) VÀ role 2 (Shop Owner)
        if (uri.contains("/admin/")) {
            if (acc.getRoleId() == 1 || acc.getRoleId() == 2) {
                System.out.println("Cho phép truy cập /admin/");
                chain.doFilter(request, response);
                return;
            } else {
                System.out.println("Từ chối: role " + acc.getRoleId() + " không có quyền");
                resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "Bạn không có quyền truy cập khu vực quản lý này!");
                return;
            }
        }

        chain.doFilter(request, response);
    }




    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
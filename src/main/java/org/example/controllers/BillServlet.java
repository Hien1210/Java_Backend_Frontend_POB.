package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.models.BillView;
import org.example.models.Order;
import org.example.utils.BillUtil;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Hiển thị hóa đơn (bill) của một hoặc nhiều đơn hàng vừa được tạo từ /checkout,
 * hoặc xem/in lại hóa đơn của một đơn hàng đã có (?orderId=).
 */
@WebServlet("/bill")
public class BillServlet extends HttpServlet {
    private static final String VIEW = "/hoaDon.jsp";

    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        List<Long> orderIds = parseOrderIds(req);
        if (orderIds.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=not_found");
            return;
        }

        List<BillView> bills = new ArrayList<>();
        for (Long orderId : orderIds) {
            Order order = orderDAO.findById(orderId);
            if (order == null) {
                continue;
            }
            bills.add(BillUtil.build(order));
        }

        if (bills.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=not_found");
            return;
        }

        req.setAttribute("bills", bills);
        req.getRequestDispatcher(VIEW).forward(req, resp);
    }

    private List<Long> parseOrderIds(HttpServletRequest req) {
        List<Long> ids = new ArrayList<>();
        String raw = req.getParameter("orderIds");
        if (raw == null || raw.isBlank()) {
            raw = req.getParameter("orderId");
        }
        if (raw == null || raw.isBlank()) {
            return ids;
        }

        for (String part : raw.split(",")) {
            try {
                String trimmed = part.trim();
                if (!trimmed.isEmpty()) {
                    ids.add(Long.parseLong(trimmed));
                }
            } catch (NumberFormatException ignored) {
                // bo qua id khong hop le
            }
        }
        return ids;
    }
}

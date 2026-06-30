package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.daos.ShopDAO;
import org.example.daos.ShopDAOImpl;
import org.example.models.Account;
import org.example.models.Order;
import org.example.models.Shop;
import org.example.utils.BillUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Shop owner bam "Xem hoa don" cho cac don hang thuoc shop cua minh: danh sach don hang +
 * xem/in hoa don chi tiet, dung chung BillUtil voi luong checkout cua khach hang (/checkout, /bill).
 */
@WebServlet("/shop/bills")
public class ShopBillServlet extends HttpServlet {
    private static final String LIST_VIEW = "/shop/Quanlybill.jsp";
    private static final String DETAIL_VIEW = "/shop/HoaDonShop.jsp";

    private final OrderDAO orderDAO = new OrderDAOImpl();
    private final ShopDAO shopDAO = new ShopDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");
        if (account == null || account.getRoleId() != 2) {
            resp.sendRedirect(req.getContextPath() + "/dangnhap");
            return;
        }

        Shop shop = shopDAO.selectShopByOwnerId(account.getId());
        if (shop == null) {
            req.setAttribute("loi", "Ban chua co cua hang! Vui long dang ky shop.");
            req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
            return;
        }
        req.setAttribute("currentShop", shop);
        session.setAttribute("currentShop", shop);

        String action = req.getParameter("action");
        if ("view".equals(action)) {
            showBill(req, resp, shop);
            return;
        }

        String keyword = normalize(req.getParameter("q"));
        String dateFilter = normalize(req.getParameter("date"));
        String statusFilter = normalize(req.getParameter("status")).toUpperCase(Locale.ROOT);
        String methodFilter = normalize(req.getParameter("method")).toUpperCase(Locale.ROOT);

        List<Order> orders = filterOrders(orderDAO.findByShopId(shop.getId()), keyword, dateFilter, statusFilter, methodFilter);

        req.setAttribute("orderList", orders);
        req.setAttribute("q", keyword);
        req.setAttribute("dateFilter", dateFilter);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("methodFilter", methodFilter);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private List<Order> filterOrders(List<Order> orders, String keyword, String dateFilter, String statusFilter, String methodFilter) {
        List<Order> result = new ArrayList<>();
        String kw = keyword.toLowerCase(Locale.ROOT);

        for (Order o : orders) {
            if (!kw.isEmpty()) {
                String haystack = (("#" + o.getId()) + " " + o.getReceiverName() + " " + o.getReceiverPhone()).toLowerCase(Locale.ROOT);
                if (!haystack.contains(kw)) continue;
            }
            if (!dateFilter.isEmpty()) {
                if (o.getCreatedAt() == null) continue;
                LocalDate created = o.getCreatedAt().toLocalDate();
                if (!created.toString().equals(dateFilter)) continue;
            }
            if (!statusFilter.isEmpty() && !"ALL".equals(statusFilter)) {
                if ("CANCELLED".equals(statusFilter)) {
                    if (!"CANCELLED".equalsIgnoreCase(o.getStaTus())) continue;
                } else {
                    String paymentStatus = o.getPaymentStatus() == null ? "UNPAID" : o.getPaymentStatus().toUpperCase(Locale.ROOT);
                    if ("CANCELLED".equalsIgnoreCase(o.getStaTus())) continue;
                    if (!statusFilter.equals(paymentStatus)) continue;
                }
            }
            if (!methodFilter.isEmpty() && !"ALL".equals(methodFilter)) {
                if (!methodFilter.equals(normalizePaymentMethod(o.getPaymentMethod()))) continue;
            }
            result.add(o);
        }
        return result;
    }

    /** COD/null/bất kỳ giá trị khác BANK, PAYOS đều coi là tiền mặt tại quầy. */
    private String normalizePaymentMethod(String paymentMethod) {
        String value = paymentMethod == null ? "" : paymentMethod.trim().toUpperCase(Locale.ROOT);
        if ("BANK".equals(value) || "PAYOS".equals(value)) {
            return value;
        }
        return "COD";
    }

    private void showBill(HttpServletRequest req, HttpServletResponse resp, Shop shop) throws ServletException, IOException {
        Long orderId = parseId(req.getParameter("id"));
        Order order = orderId == null ? null : orderDAO.findById(orderId);

        if (order == null || order.getShopId() != shop.getId()) {
            resp.sendRedirect(req.getContextPath() + "/shop/bills?error=not_found");
            return;
        }

        if ("modal".equals(req.getParameter("as"))) {
            List<Order> orders = filterOrders(orderDAO.findByShopId(shop.getId()), "", "", "", "");
            req.setAttribute("orderList", orders);
            req.setAttribute("bill", BillUtil.build(order));
            req.setAttribute("modalMode", "readonly");
            req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
            return;
        }

        req.setAttribute("bill", BillUtil.build(order));
        req.getRequestDispatcher(DETAIL_VIEW).forward(req, resp);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private Long parseId(String value) {
        try {
            String normalized = value == null ? "" : value.trim();
            return normalized.isEmpty() ? null : Long.parseLong(normalized);
        } catch (Exception e) {
            return null;
        }
    }
}

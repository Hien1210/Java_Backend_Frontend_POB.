package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.OrderDAO;
import org.example.daos.OrderDAOImpl;
import org.example.models.Order;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Locale;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private static final String LIST_VIEW = "/orderDanhSach.jsp";
    private static final String FORM_VIEW = "/orderThemSua.jsp";

    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = normalize(req.getParameter("action"));

        switch (action) {
            case "new":
                req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            case "delete":
                deleteOrder(req, resp);
                break;
            case "list":
            default:
                listOrders(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = normalize(req.getParameter("action"));

        switch (action) {
            case "update":
                updateOrder(req, resp);
                break;
            case "create":
            default:
                createOrder(req, resp);
                break;
        }
    }

    private void listOrders(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Order> orders = orderDAO.getAll();
        req.setAttribute("orderList", orders);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=not_found");
            return;
        }

        Order order = orderDAO.findById(id);
        if (order == null) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=not_found");
            return;
        }

        req.setAttribute("order", order);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private void createOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Order order = readOrder(req);
        String error = validateOrder(order);
        if (error != null) {
            fail(req, resp, error, order);
            return;
        }

        boolean created = orderDAO.create(order);
        if (!created) {
            fail(req, resp, "Loi tao don hang", order);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/orders?success=created");
    }

    private void updateOrder(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null || orderDAO.findById(id) == null) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=not_found");
            return;
        }

        Order order = readOrder(req);
        order.setId(id);
        String error = validateOrder(order);
        if (error != null) {
            fail(req, resp, error, order);
            return;
        }

        boolean updated = orderDAO.update(order);
        if (!updated) {
            fail(req, resp, "Loi cap nhat don hang", order);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/orders?success=updated");
    }

    private void deleteOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = parseId(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=not_found");
            return;
        }

        boolean deleted = orderDAO.delete(id);
        String result = deleted ? "success=deleted" : "error=not_found";
        resp.sendRedirect(req.getContextPath() + "/orders?" + result);
    }

    private Order readOrder(HttpServletRequest req) {
        Order order = new Order();
        order.setUserId(parseLong(req.getParameter("userId")));
        order.setShopId(parseLong(req.getParameter("shopId")));
        order.setShipperId(parseLong(req.getParameter("shipperId")));
        order.setReceiverName(normalize(req.getParameter("receiverName")));
        order.setReceiverPhone(normalize(req.getParameter("receiverPhone")));
        order.setShippingAddress(normalize(req.getParameter("shippingAddress")));
        order.setTotalPrice(parseDouble(req.getParameter("totalPrice")));
        order.setDeliveryFee(parseDouble(req.getParameter("deliveryFee")));
        order.setPaymentMethod(normalize(req.getParameter("paymentMethod")));
        order.setStaTus(normalizeStatus(req.getParameter("status")));
        order.setEstimatedDeliveryTime(parseDateTime(req.getParameter("estimatedDeliveryTime")));
        return order;
    }

    private String validateOrder(Order order) {
        if (order.getUserId() <= 0) {
            return "User ID khong hop le";
        }
        if (order.getShopId() <= 0) {
            return "Shop ID khong hop le";
        }
        if (order.getReceiverName().isBlank()) {
            return "Ten nguoi nhan khong duoc de trong";
        }
        if (order.getReceiverPhone().isBlank()) {
            return "So dien thoai nguoi nhan khong duoc de trong";
        }
        if (order.getShippingAddress().isBlank()) {
            return "Dia chi giao hang khong duoc de trong";
        }
        if (order.getTotalPrice() == null || order.getTotalPrice() < 0) {
            return "Tong tien khong hop le";
        }
        if (order.getDeliveryFee() != null && order.getDeliveryFee() < 0) {
            return "Phi giao hang khong hop le";
        }
        return null;
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String error, Order order)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("order", order);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private Long parseId(HttpServletRequest req) {
        try {
            String value = normalize(req.getParameter("id"));
            return value.isEmpty() ? null : Long.parseLong(value);
        } catch (Exception e) {
            return null;
        }
    }

    private long parseLong(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0 : Long.parseLong(normalized);
        } catch (Exception e) {
            return 0;
        }
    }

    private Double parseDouble(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0D : Double.parseDouble(normalized);
        } catch (Exception e) {
            return null;
        }
    }

    private LocalDateTime parseDateTime(String value) {
        String normalized = normalize(value);
        if (normalized.isEmpty()) {
            return null;
        }
        try {
            return LocalDateTime.parse(normalized);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    private String normalizeStatus(String value) {
        String status = normalize(value);
        return status.isBlank() ? "PENDING" : status.toUpperCase(Locale.ROOT);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}

package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.OrderDetailDAO;
import org.example.daos.OrderDetailDAOImpl;
import org.example.models.OrderDetail;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-details")
public class OrderDetailServlet extends HttpServlet {
    private static final String LIST_VIEW = "/orderDetailDanhSach.jsp";
    private static final String FORM_VIEW = "/orderDetailThemSua.jsp";

    private final OrderDetailDAO dao = new OrderDetailDAOImpl();

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
                deleteDetail(req, resp);
                break;
            default:
                listDetails(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = normalize(req.getParameter("action"));

        if ("update".equals(action)) {
            updateDetail(req, resp);
        } else {
            createDetail(req, resp);
        }
    }

    private void listDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<OrderDetail> details = dao.getAll();
        req.setAttribute("orderDetailList", details);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        OrderDetail detail = id == null ? null : dao.findById(id);
        if (detail == null) {
            resp.sendRedirect(req.getContextPath() + "/order-details?error=not_found");
            return;
        }

        req.setAttribute("orderDetail", detail);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private void createDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        OrderDetail detail = readDetail(req);
        String error = validateDetail(detail);
        if (error != null) {
            fail(req, resp, error, detail);
            return;
        }

        if (!dao.create(detail)) {
            fail(req, resp, "Loi tao chi tiet don hang", detail);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/order-details?success=created");
    }

    private void updateDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null || dao.findById(id) == null) {
            resp.sendRedirect(req.getContextPath() + "/order-details?error=not_found");
            return;
        }

        OrderDetail detail = readDetail(req);
        detail.setId(id);
        String error = validateDetail(detail);
        if (error != null) {
            fail(req, resp, error, detail);
            return;
        }

        if (!dao.update(detail)) {
            fail(req, resp, "Loi cap nhat chi tiet don hang", detail);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/order-details?success=updated");
    }

    private void deleteDetail(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = parseId(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/order-details?error=not_found");
            return;
        }

        boolean deleted = dao.delete(id);
        resp.sendRedirect(req.getContextPath() + "/order-details?" + (deleted ? "success=deleted" : "error=not_found"));
    }

    private OrderDetail readDetail(HttpServletRequest req) {
        OrderDetail detail = new OrderDetail();
        detail.setOrderId(parseLong(req.getParameter("orderId")));
        detail.setProductId(parseLong(req.getParameter("productId")));
        detail.setProductSizeId(parseLong(req.getParameter("productSizeId")));
        detail.setQuantity(parseInt(req.getParameter("quantity")));
        detail.setPrice(parseDouble(req.getParameter("price")));
        return detail;
    }

    private String validateDetail(OrderDetail detail) {
        if (detail.getOrderId() <= 0) return "Order ID khong hop le";
        if (detail.getProductId() <= 0) return "Product ID khong hop le";
        if (detail.getProductSizeId() <= 0) return "Product Size ID khong hop le";
        if (detail.getQuantity() <= 0) return "So luong phai lon hon 0";
        if (detail.getPrice() < 0) return "Gia khong hop le";
        return null;
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String error, OrderDetail detail)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("orderDetail", detail);
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

    private int parseInt(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0 : Integer.parseInt(normalized);
        } catch (Exception e) {
            return 0;
        }
    }

    private double parseDouble(String value) {
        try {
            String normalized = normalize(value);
            return normalized.isEmpty() ? 0D : Double.parseDouble(normalized);
        } catch (Exception e) {
            return -1D;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}

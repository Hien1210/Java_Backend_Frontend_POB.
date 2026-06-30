package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.OrderLogDAO;
import org.example.daos.OrderLogDAOImpl;
import org.example.models.OrderLog;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-logs")
public class OrderLogServlet extends HttpServlet {
    private static final String LIST_VIEW = "/orderLogDanhSach.jsp";
    private static final String FORM_VIEW = "/orderLogThemSua.jsp";
    private final OrderLogDAO dao = new OrderLogDAOImpl();

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
                deleteLog(req, resp);
                break;
            default:
                listLogs(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = normalize(req.getParameter("action"));
        if ("update".equals(action)) {
            updateLog(req, resp);
        } else {
            createLog(req, resp);
        }
    }

    private void listLogs(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<OrderLog> logs = dao.getAll();
        req.setAttribute("orderLogList", logs);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        OrderLog log = id == null ? null : dao.findById(id);
        if (log == null) {
            resp.sendRedirect(req.getContextPath() + "/order-logs?error=not_found");
            return;
        }
        req.setAttribute("orderLog", log);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private void createLog(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        OrderLog log = readLog(req);
        String error = validateLog(log);
        if (error != null) {
            fail(req, resp, error, log);
            return;
        }
        if (!dao.create(log)) {
            fail(req, resp, "Loi tao lich su don hang", log);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/order-logs?success=created");
    }

    private void updateLog(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null || dao.findById(id) == null) {
            resp.sendRedirect(req.getContextPath() + "/order-logs?error=not_found");
            return;
        }
        OrderLog log = readLog(req);
        log.setId(id);
        String error = validateLog(log);
        if (error != null) {
            fail(req, resp, error, log);
            return;
        }
        if (!dao.update(log)) {
            fail(req, resp, "Loi cap nhat lich su don hang", log);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/order-logs?success=updated");
    }

    private void deleteLog(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = parseId(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/order-logs?error=not_found");
            return;
        }
        boolean deleted = dao.delete(id);
        resp.sendRedirect(req.getContextPath() + "/order-logs?" + (deleted ? "success=deleted" : "error=not_found"));
    }

    private OrderLog readLog(HttpServletRequest req) {
        OrderLog log = new OrderLog();
        log.setOrderId(parseLong(req.getParameter("orderId")));
        log.setChangedBy(parseLong(req.getParameter("changedBy")));
        log.setOldStatus(normalize(req.getParameter("oldStatus")));
        log.setNewStatus(normalize(req.getParameter("newStatus")));
        log.setNote(normalize(req.getParameter("note")));
        return log;
    }

    private String validateLog(OrderLog log) {
        if (log.getOrderId() <= 0) return "Order ID khong hop le";
        if (log.getChangedBy() <= 0) return "Nguoi thay doi khong hop le";
        if (log.getNewStatus().isBlank()) return "Trang thai moi khong duoc de trong";
        return null;
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String error, OrderLog log)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("orderLog", log);
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

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}

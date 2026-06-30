package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.CartItemDAO;
import org.example.daos.CartItemDAOImpl;
import org.example.models.CartItem;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart-items")
public class CartItemServlet extends HttpServlet {
    private static final String LIST_VIEW = "/cartItemDanhSach.jsp";
    private static final String FORM_VIEW = "/cartItemThemSua.jsp";

    private final CartItemDAO dao = new CartItemDAOImpl();

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
                deleteItem(req, resp);
                break;
            default:
                listItems(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = normalize(req.getParameter("action"));

        if ("update".equals(action)) {
            updateItem(req, resp);
        } else {
            createItem(req, resp);
        }
    }

    private void listItems(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<CartItem> items = dao.getAll();
        req.setAttribute("cartItemList", items);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        CartItem item = id == null ? null : dao.findById(id);
        if (item == null) {
            resp.sendRedirect(req.getContextPath() + "/cart-items?error=not_found");
            return;
        }

        req.setAttribute("cartItem", item);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private void createItem(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        CartItem item = readItem(req);
        String error = validateItem(item);
        if (error != null) {
            fail(req, resp, error, item);
            return;
        }

        if (!dao.create(item)) {
            fail(req, resp, "Loi tao chi tiet gio hang", item);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart-items?success=created");
    }

    private void updateItem(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null || dao.findById(id) == null) {
            resp.sendRedirect(req.getContextPath() + "/cart-items?error=not_found");
            return;
        }

        CartItem item = readItem(req);
        item.setId(id);
        String error = validateItem(item);
        if (error != null) {
            fail(req, resp, error, item);
            return;
        }

        if (!dao.update(item)) {
            fail(req, resp, "Loi cap nhat chi tiet gio hang", item);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart-items?success=updated");
    }

    private void deleteItem(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = parseId(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/cart-items?error=not_found");
            return;
        }

        boolean deleted = dao.delete(id);
        resp.sendRedirect(req.getContextPath() + "/cart-items?" + (deleted ? "success=deleted" : "error=not_found"));
    }

    private CartItem readItem(HttpServletRequest req) {
        CartItem item = new CartItem();
        item.setCartId(parseLong(req.getParameter("cartId")));
        item.setProductId(parseLong(req.getParameter("productId")));
        item.setProductSizeId(parseLong(req.getParameter("productSizeId")));
        item.setQuantity(parseInt(req.getParameter("quantity")));
        return item;
    }

    private String validateItem(CartItem item) {
        if (item.getCartId() <= 0) return "Cart ID khong hop le";
        if (item.getProductId() <= 0) return "Product ID khong hop le";
        if (item.getProductSizeId() <= 0) return "Product Size ID khong hop le";
        if (item.getQuantity() <= 0) return "So luong phai lon hon 0";
        return null;
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String error, CartItem item)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("cartItem", item);
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

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}

package org.example.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.daos.CartDAO;
import org.example.daos.CartDAOImpl;
import org.example.models.Cart;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final String LIST_VIEW = "/DanhSachGioHang.jsp";
    private static final String FORM_VIEW = "/themSuaGioHang.jsp";

    private final CartDAO cartDAO = new CartDAOImpl();

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
                deleteCart(req, resp);
                break;
            case "list":
            default:
                listCarts(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = normalize(req.getParameter("action"));

        switch (action) {
            case "update":
                updateCart(req, resp);
                break;
            case "create":
            default:
                createCart(req, resp);
                break;
        }
    }

    private void listCarts(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Cart> carts = cartDAO.getAll();
        req.setAttribute("cartList", carts);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=not_found");
            return;
        }

        Cart cart = cartDAO.findById(id);
        if (cart == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=not_found");
            return;
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private void createCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cart cart = readCart(req);
        String error = validateCart(cart);
        if (error != null) {
            fail(req, resp, error, cart);
            return;
        }

        if (cart.getCreatedAt() == null) {
            cart.setCreatedAt(LocalDateTime.now());
        }

        boolean created = cartDAO.create(cart);
        if (!created) {
            fail(req, resp, "Loi tao gio hang", cart);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart?success=created");
    }

    private void updateCart(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = parseId(req);
        Cart existingCart = id == null ? null : cartDAO.findById(id);
        if (existingCart == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=not_found");
            return;
        }

        Cart cart = readCart(req);
        cart.setId(id);
        if (cart.getCreatedAt() == null) {
            cart.setCreatedAt(existingCart.getCreatedAt());
        }
        String error = validateCart(cart);
        if (error != null) {
            fail(req, resp, error, cart);
            return;
        }

        boolean updated = cartDAO.update(cart);
        if (!updated) {
            fail(req, resp, "Loi cap nhat gio hang", cart);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/cart?success=updated");
    }

    private void deleteCart(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long id = parseId(req);
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/cart?error=not_found");
            return;
        }

        boolean deleted = cartDAO.delete(id);
        String result = deleted ? "success=deleted" : "error=not_found";
        resp.sendRedirect(req.getContextPath() + "/cart?" + result);
    }

    private Cart readCart(HttpServletRequest req) {
        Cart cart = new Cart();
        cart.setUserId(parseLong(req.getParameter("userId")));
        cart.setCreatedAt(parseDateTime(req.getParameter("createdAt")));
        return cart;
    }

    private String validateCart(Cart cart) {
        if (cart.getUserId() <= 0) {
            return "User ID khong hop le";
        }
        return null;
    }

    private void fail(HttpServletRequest req, HttpServletResponse resp, String error, Cart cart)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        req.setAttribute("cart", cart);
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

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}

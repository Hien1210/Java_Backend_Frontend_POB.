package org.example.utils;

import org.example.daos.*;
import org.example.models.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Dung chung de dung hoa don (BillView) tu mot Order, dung o ca BillServlet (khach hang xem
 * hoa don sau khi checkout) va ShopBillServlet (shop xem/in hoa don cua don hang thuoc shop minh).
 */
public final class BillUtil {
    private static final OrderDetailDAO orderDetailDAO = new OrderDetailDAOImpl();
    private static final OrderDetailToppingDAO orderDetailToppingDAO = new OrderDetailToppingDAOImpl();
    private static final ProductDAO productDAO = new ProductDAOImpl();
    private static final ProductSizeDAO productSizeDAO = new ProductSizeDAOImpl();
    private static final ToppingDAO toppingDAO = new ToppingDAOImpl();
    private static final ShopDAO shopDAO = new ShopDAOImpl();

    private BillUtil() {
    }

    public static BillView build(Order order) {
        Shop shop = shopDAO.selectShopById(order.getShopId());
        String shopName = shop == null ? ("Shop #" + order.getShopId()) : shop.getShopName();

        List<BillLine> lines = new ArrayList<>();
        double subtotal = 0;
        for (OrderDetail detail : orderDetailDAO.findByOrderId(order.getId())) {
            Product product = productDAO.findById(detail.getProductId());
            ProductSize size = productSizeDAO.findById(detail.getProductSizeId());

            String productName = product == null ? ("San pham #" + detail.getProductId()) : product.getProductName();
            String sizeName = size == null ? "" : size.getSizeName();

            List<BillToppingLine> toppingLines = new ArrayList<>();
            double toppingsTotal = 0;
            for (OrderDetailTopping ot : orderDetailToppingDAO.findByOrderDetailId(detail.getId())) {
                Topping topping = toppingDAO.findById(ot.getToppingId());
                String toppingName = topping == null ? ("Topping #" + ot.getToppingId()) : topping.getToppingName();
                double toppingLineTotal = ot.getPrice() * ot.getQuantity();
                toppingsTotal += toppingLineTotal;
                toppingLines.add(new BillToppingLine(toppingName, ot.getQuantity(), ot.getPrice(), toppingLineTotal));
            }

            double lineTotal = detail.getPrice() * detail.getQuantity() + toppingsTotal;
            subtotal += lineTotal;

            lines.add(new BillLine(productName, sizeName, detail.getQuantity(), detail.getPrice(), lineTotal, toppingLines));
        }

        return new BillView(order, shopName, lines, subtotal);
    }
}

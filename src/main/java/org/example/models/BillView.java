package org.example.models;

import java.util.List;

public class BillView {
    private final Order order;
    private final String shopName;
    private final List<BillLine> lines;
    private final double subtotal;

    public BillView(Order order, String shopName, List<BillLine> lines, double subtotal) {
        this.order = order;
        this.shopName = shopName;
        this.lines = lines;
        this.subtotal = subtotal;
    }

    public Order getOrder() { return order; }
    public String getShopName() { return shopName; }
    public List<BillLine> getLines() { return lines; }
    public double getSubtotal() { return subtotal; }
}

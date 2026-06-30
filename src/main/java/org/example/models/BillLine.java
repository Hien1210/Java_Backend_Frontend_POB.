package org.example.models;

import java.util.Collections;
import java.util.List;

public class BillLine {
    private final String productName;
    private final String sizeName;
    private final int quantity;
    private final double price;
    private final double lineTotal;
    private final List<BillToppingLine> toppings;

    public BillLine(String productName, String sizeName, int quantity, double price, double lineTotal) {
        this(productName, sizeName, quantity, price, lineTotal, Collections.emptyList());
    }

    public BillLine(String productName, String sizeName, int quantity, double price, double lineTotal,
                     List<BillToppingLine> toppings) {
        this.productName = productName;
        this.sizeName = sizeName;
        this.quantity = quantity;
        this.price = price;
        this.lineTotal = lineTotal;
        this.toppings = toppings == null ? Collections.emptyList() : toppings;
    }

    public String getProductName() { return productName; }
    public String getSizeName() { return sizeName; }
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }
    public double getLineTotal() { return lineTotal; }
    public List<BillToppingLine> getToppings() { return toppings; }
}

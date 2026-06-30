package org.example.models;

public class BillToppingLine {
    private final String toppingName;
    private final int quantity;
    private final double price;
    private final double lineTotal;

    public BillToppingLine(String toppingName, int quantity, double price, double lineTotal) {
        this.toppingName = toppingName;
        this.quantity = quantity;
        this.price = price;
        this.lineTotal = lineTotal;
    }

    public String getToppingName() { return toppingName; }
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }
    public double getLineTotal() { return lineTotal; }
}

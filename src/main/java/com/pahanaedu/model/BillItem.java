package com.pahanaedu.model;

public class BillItem {
    private int itemId;
    private String itemName; // for display
    private int qty;
    private double unitPrice;
    private double lineDiscount; // per line
    private double subTotal;

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }
    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }
    public double getLineDiscount() { return lineDiscount; }
    public void setLineDiscount(double lineDiscount) { this.lineDiscount = lineDiscount; }
    public double getSubTotal() { return subTotal; }
    public void setSubTotal(double subTotal) { this.subTotal = subTotal; }
}

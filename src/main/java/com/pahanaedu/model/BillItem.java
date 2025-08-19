package com.pahanaedu.model;

public class BillItem {
    private int billItemId;
    private int billId;
    private Integer itemId;
    private String itemName;
    private double unitPrice;
    private int qty;
    private double lineTotal;

    public int getBillItemId() { return billItemId; }
    public void setBillItemId(int billItemId) { this.billItemId = billItemId; }

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public Integer getItemId() { return itemId; }
    public void setItemId(Integer itemId) { this.itemId = itemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public int getQty() { return qty; }
    public void setQty(int qty) { this.qty = qty; }

    public double getLineTotal() { return lineTotal; }
    public void setLineTotal(double lineTotal) { this.lineTotal = lineTotal; }

    public double getSubTotal() { return lineTotal; }
}

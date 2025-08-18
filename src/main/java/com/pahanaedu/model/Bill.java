package com.pahanaedu.model;

import java.util.ArrayList;
import java.util.List;

public class Bill {
    private int billId;
    private Integer customerId;
    private Integer createdBy;
    private double grossTotal;
    private double discount;     // AMOUNT (Rs.) -> persisted to DB
    private double discountPct;  // PERCENT (%)  -> UI / calc only
    private double netTotal;
    private String notes;
    private final List<BillItem> items = new ArrayList<>();

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }
    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
    public double getGrossTotal() { return grossTotal; }
    public void setGrossTotal(double grossTotal) { this.grossTotal = grossTotal; }

    // amount (Rs.)
    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    // percent (%)
    public double getDiscountPct() { return discountPct; }
    public void setDiscountPct(double discountPct) { this.discountPct = discountPct; }

    public double getNetTotal() { return netTotal; }
    public void setNetTotal(double netTotal) { this.netTotal = netTotal; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public List<BillItem> getItems() { return items; }
}

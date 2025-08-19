//package com.pahanaedu.model;
//
//import java.time.LocalDateTime;
//import java.util.ArrayList;
//import java.util.List;
//
//public class Bill {
//    private int billId;
//    private String billNo;
//    private LocalDateTime billDate;
//    private Integer customerId;
//    private Integer createdBy;
//
//    private double subTotal;
//    private double discountAmt;   // flat rupee discount
//    private double netTotal;
//    private double paidAmount;
//    private String paymentMethod;
//
//    // NEW: optional notes so PdfReceiptUtil can read it
//    private String notes;
//
//    private List<BillItem> items = new ArrayList<>();
//
//    public int getBillId() { return billId; }
//    public void setBillId(int billId) { this.billId = billId; }
//
//    public String getBillNo() { return billNo; }
//    public void setBillNo(String billNo) { this.billNo = billNo; }
//
//    public LocalDateTime getBillDate() { return billDate; }
//    public void setBillDate(LocalDateTime billDate) { this.billDate = billDate; }
//
//    public Integer getCustomerId() { return customerId; }
//    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
//
//    public Integer getCreatedBy() { return createdBy; }
//    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }
//
//    public double getSubTotal() { return subTotal; }
//    public void setSubTotal(double subTotal) { this.subTotal = subTotal; }
//
//    public double getDiscountAmt() { return discountAmt; }
//    public void setDiscountAmt(double discountAmt) { this.discountAmt = discountAmt; }
//
//    public double getNetTotal() { return netTotal; }
//    public void setNetTotal(double netTotal) { this.netTotal = netTotal; }
//
//    public double getPaidAmount() { return paidAmount; }
//    public void setPaidAmount(double paidAmount) { this.paidAmount = paidAmount; }
//
//    public String getPaymentMethod() { return paymentMethod; }
//    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
//
//    public List<BillItem> getItems() { return items; }
//    public void setItems(List<BillItem> items) { this.items = items; }
//
//    // -------- Compatibility getters for PdfReceiptUtil --------
//    /** “Gross” before discount; in our model it’s the same as subTotal. */
//    public double getGrossTotal() { return subTotal; }
//
//    /** Flat discount amount (Rs). */
//    public double getDiscount() { return discountAmt; }
//
//    /** Derived percentage for display (safe for 0). */
//    public double getDiscountPct() { return subTotal <= 0 ? 0 : (discountAmt * 100.0 / subTotal); }
//
//    public String getNotes() { return notes; }
//    public void setNotes(String notes) { this.notes = notes; }
//}



package com.pahanaedu.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Bill {
    private int billId;
    private String billNo;
    private LocalDateTime billDate;
    private Integer customerId;
    private int createdBy;
    private double subTotal;
    private double discountAmt;
    private double netTotal;
    private double paidAmount;
    private String paymentMethod = "CASH";
    private String notes;

    private List<BillItem> items = new ArrayList<>();

    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }
    public String getBillNo() { return billNo; }
    public void setBillNo(String billNo) { this.billNo = billNo; }
    public LocalDateTime getBillDate() { return billDate; }
    public void setBillDate(LocalDateTime billDate) { this.billDate = billDate; }
    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    public double getSubTotal() { return subTotal; }
    public void setSubTotal(double subTotal) { this.subTotal = subTotal; }
    public double getDiscountAmt() { return discountAmt; }
    public void setDiscountAmt(double discountAmt) { this.discountAmt = discountAmt; }
    public double getNetTotal() { return netTotal; }
    public void setNetTotal(double netTotal) { this.netTotal = netTotal; }
    public double getPaidAmount() { return paidAmount; }
    public void setPaidAmount(double paidAmount) { this.paidAmount = paidAmount; }
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    public List<BillItem> getItems() { return items; }
    public void setItems(List<BillItem> items) { this.items = items; }
}

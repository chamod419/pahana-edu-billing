package com.pahanaedu.service;

import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;

import java.sql.SQLException;
import java.util.List;

public class BillingService {
    private final BillingDAO dao = new BillingDAO();

    public int startBill(Integer customerId, int userId) throws SQLException {
        return dao.createDraft(customerId, userId);
    }

    public void addItem(int billId, int itemId, int qty) throws SQLException {
        dao.addLine(billId, itemId, qty);
        dao.recomputeTotals(billId);
    }

    public void removeLine(int billItemId, int billId) throws SQLException {
        dao.removeLine(billItemId);
        dao.recomputeTotals(billId);
    }

    public void finalizeBill(int billId, double discountAmt, String method) throws SQLException {
        dao.applyDiscountAndMethod(billId, discountAmt, method);
    }

    public Bill get(int billId) throws SQLException { return dao.getBill(billId); }

    public void cancel(int billId) throws SQLException { dao.cancelBill(billId); }
}

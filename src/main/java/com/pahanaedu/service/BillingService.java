package com.pahanaedu.service;

import com.pahanaedu.dao.BillingDAO;
import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.model.Item;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.Optional;

public class BillingService {
    private final ItemDAO itemDAO = new ItemDAO();
    private final BillingDAO billingDAO = new BillingDAO();

    public Bill ensureCart(Bill cart, int userId) {
        if (cart == null) cart = new Bill();
        if (cart.getCreatedBy() == null) cart.setCreatedBy(userId);
        recalc(cart);
        return cart;
    }

    public String addItem(Bill cart, int itemId, int qty) {
        if (qty <= 0) return "Qty must be greater than 0";
        Optional<Item> opt = itemDAO.findById(itemId);
        if (opt.isEmpty()) return "Item not found";
        Item src = opt.get();

        for (BillItem bi : cart.getItems()) {
            if (bi.getItemId() == itemId) {
                bi.setQty(bi.getQty() + qty);
                bi.setSubTotal((bi.getQty() * bi.getUnitPrice()) - bi.getLineDiscount());
                recalc(cart);
                return null;
            }
        }

        BillItem bi = new BillItem();
        bi.setItemId(src.getItemId());
        bi.setItemName(src.getName());
        bi.setQty(qty);
        bi.setUnitPrice(src.getUnitPrice());
        bi.setLineDiscount(0);
        bi.setSubTotal(qty * src.getUnitPrice());
        cart.getItems().add(bi);

        recalc(cart);
        return null;
    }

    public String updateQty(Bill cart, int itemId, int qty) {
        if (qty <= 0) return "Qty must be greater than 0";
        for (BillItem bi : cart.getItems()) {
            if (bi.getItemId() == itemId) {
                bi.setQty(qty);
                bi.setSubTotal((qty * bi.getUnitPrice()) - bi.getLineDiscount());
                recalc(cart);
                return null;
            }
        }
        return "Item not in cart";
    }

    public void removeItem(Bill cart, int itemId) {
        Iterator<BillItem> it = cart.getItems().iterator();
        while (it.hasNext()) {
            if (it.next().getItemId() == itemId) { it.remove(); break; }
        }
        recalc(cart);
    }

    /** Set discount as PERCENT (0..100). Amount gets computed from gross. */
    public void applyDiscount(Bill cart, double discountPct) {
        if (discountPct < 0) discountPct = 0;
        if (discountPct > 100) discountPct = 100;
        cart.setDiscountPct(discountPct);
        recalc(cart);
    }

    public void recalc(Bill cart) {
        double gross = 0;
        for (BillItem bi : cart.getItems()) gross += bi.getSubTotal();
        gross = round2(gross);

        double discountAmt = round2(gross * (cart.getDiscountPct() / 100.0));
        double net = round2(gross - discountAmt);
        if (net < 0) net = 0;

        cart.setGrossTotal(gross);
        cart.setDiscount(discountAmt); // amount saved to DB
        cart.setNetTotal(net);
    }

    public int save(Bill cart, int customerId, int createdBy, String notes, boolean decreaseStock) throws SQLException {
        cart.setCustomerId(customerId);
        cart.setCreatedBy(createdBy);
        cart.setNotes(notes);
        recalc(cart); // ensure amounts are consistent

        int billId = billingDAO.insertBill(cart);
        for (BillItem bi : cart.getItems()) {
            billingDAO.insertBillItem(billId, bi);
            if (decreaseStock) billingDAO.decreaseStock(bi.getItemId(), bi.getQty());
        }
        return billId;
    }

    private double round2(double v){ return Math.round(v * 100.0) / 100.0; }
}

package com.pahanaedu.service;

import com.pahanaedu.dao.ItemDAO;
import com.pahanaedu.model.Item;

import java.util.List;
import java.util.Optional;

public class ItemService {
    private final ItemDAO dao = new ItemDAO();

    public List<Item> list() { return dao.findAll(); }
    public Optional<Item> get(int id) { return dao.findById(id); }
    public Optional<Item> findBillable(int id) { return dao.findBillableById(id); }

    public boolean save(Item i) {
        if (i.getItemId() == 0) return dao.insert(i);
        return dao.update(i);
    }

    public DeleteResult deleteSafe(int id) {
        int uses = dao.countUsageInBills(id);
        if (uses > 0) return DeleteResult.IN_USE;
        if (uses < 0) return DeleteResult.ERROR;
        return dao.delete(id) ? DeleteResult.OK : DeleteResult.ERROR;
    }
}

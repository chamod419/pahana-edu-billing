package com.pahanaedu.service;

import com.pahanaedu.dao.CustomerDAO;
import com.pahanaedu.model.Customer;

import java.util.List;
import java.util.Optional;

public class CustomerService {
    private final CustomerDAO dao = new CustomerDAO();

    public List<Customer> list() { return dao.findAll(); }
    public List<Customer> search(String q) { return (q==null || q.isBlank()) ? dao.findAll() : dao.search(q); }
    public Optional<Customer> get(int id) { return dao.findById(id); }

    public boolean save(Customer c) {
        if (c.getCustomerId() == 0) return dao.insert(c);
        return dao.update(c);
    }

    public boolean delete(int id) { return dao.delete(id); }
}

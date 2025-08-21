package com.pahanaedu.service;

import com.pahanaedu.dao.DashboardDAO;

public class DashboardService {
    private final DashboardDAO dao = new DashboardDAO();

    // Admin
    public int totalCustomers(){ return dao.getTotalCustomers(); }
    public int activeItems(){ return dao.getActiveItems(); }
    public int todayBills(){ return dao.getTodayBillsCount(); }
    public double todayRevenue(){ return dao.getTodayRevenue(); }

    // Staff
    public int todayBillsByUser(int userId){ return dao.getTodayBillsCountByUser(userId); }
    public double todayRevenueByUser(int userId){ return dao.getTodayRevenueByUser(userId); }
    public int todayCustomersServedByUser(int userId){ return dao.getTodayCustomersServedByUser(userId); }
}

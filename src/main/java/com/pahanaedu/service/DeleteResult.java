package com.pahanaedu.service;

public enum DeleteResult {
    OK,       // deleted
    IN_USE,   // referenced by bill_items
    ERROR     // unexpected SQL error
}

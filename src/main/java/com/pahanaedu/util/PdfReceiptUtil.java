package com.pahanaedu.util;

import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.kernel.pdf.canvas.draw.SolidLine;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.LineSeparator;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.HorizontalAlignment;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import com.pahanaedu.model.Bill;
import com.pahanaedu.model.BillItem;
import com.pahanaedu.model.Customer;

import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class PdfReceiptUtil {

    /** ~80mm paper width in points (72pt/inch). */
    private static final float PAGE_WIDTH_PT = 226.8f;
    private static final float MARGIN = 10f;

    public static byte[] buildReceiptPdf(Bill bill, Customer customer) {
        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

            PdfWriter writer = new PdfWriter(baos);
            PdfDocument pdf = new PdfDocument(writer);
            PageSize roll = new PageSize(PAGE_WIDTH_PT, PageSize.A4.getHeight()); // tall enough
            Document doc = new Document(pdf, roll);
            doc.setMargins(MARGIN, MARGIN, MARGIN, MARGIN);

            // Header
            Paragraph brand = new Paragraph("PahanaEdu")
                    .setTextAlignment(TextAlignment.CENTER)
                    .setBold().setFontSize(12);
            Paragraph title = new Paragraph("Receipt")
                    .setTextAlignment(TextAlignment.CENTER)
                    .setFontSize(9).setMarginTop(0).setMarginBottom(4);

            String custLine = (customer != null)
                    ? String.format("%s (%s)", nz(customer.getName()), nz(customer.getAccountNumber()))
                    : "-";
            String topMeta = "Bill #" + bill.getBillId() +
                    "  |  " + DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm").format(LocalDateTime.now()) +
                    "\nCustomer: " + custLine;

            Paragraph meta = new Paragraph(topMeta).setFontSize(8).setTextAlignment(TextAlignment.LEFT);

            doc.add(brand);
            doc.add(title);
            doc.add(new LineSeparator(new SolidLine(1)));
            doc.add(meta);
            doc.add(new LineSeparator(new SolidLine(0.5f)));

            // Items
            float[] cols = { 70, 30, 40, 50 }; // Name, Qty, Unit, Subtotal
            Table t = new Table(UnitValue.createPointArray(cols)).useAllAvailableWidth();
            addHeader(t, "Item", "Qty", "Unit", "Subtotal");

            for (BillItem bi : bill.getItems()) {
                t.addCell(cellLeft(bi.getItemName(), false));
                t.addCell(cellRight(String.valueOf(bi.getQty()), false));
                t.addCell(cellRight(fmt(bi.getUnitPrice()), false));
                t.addCell(cellRight(fmt(bi.getSubTotal()), false));
            }
            doc.add(t);

            // Totals
            doc.add(new LineSeparator(new SolidLine(0.5f)));

            Table tot = new Table(UnitValue.createPointArray(new float[]{100, 90}))
                    .setHorizontalAlignment(HorizontalAlignment.RIGHT)
                    .setWidth(UnitValue.createPointValue(190));

            tot.addCell(kv("Gross", fmt(bill.getGrossTotal())));
            double pct = bill.getDiscountPct(); // percent shown; amount saved in bill.getDiscount()
            String dlabel = (pct > 0) ? "Discount (" + trimZeros(pct) + "%)" : "Discount";
            tot.addCell(kv(dlabel, fmt(bill.getDiscount())));
            tot.addCell(kvBold("Net Total", fmt(bill.getNetTotal())));

            doc.add(tot);

            if (!nz(bill.getNotes()).isEmpty()) {
                doc.add(new Paragraph("Notes: " + bill.getNotes())
                        .setFontSize(8).setMarginTop(6));
            }

            doc.add(new LineSeparator(new SolidLine(0.5f)));
            doc.add(new Paragraph("Thank you!")
                    .setTextAlignment(TextAlignment.CENTER)
                    .setFontSize(9)
                    .setMarginTop(6));

            doc.close();
            return baos.toByteArray();
        } catch (Exception e) {
            throw new RuntimeException("Failed to build PDF", e);
        }
    }

    private static void addHeader(Table t, String... headers) {
        for (String h : headers) {
            t.addCell(new Cell().add(new Paragraph(h).setBold())
                    .setBorder(Border.NO_BORDER)
                    .setFontSize(8)
                    .setFontColor(ColorConstants.BLACK)
                    .setBackgroundColor(ColorConstants.LIGHT_GRAY));
        }
    }

    private static Cell cellLeft(String text, boolean bold) {
        Paragraph p = new Paragraph(nz(text)).setFontSize(8);
        if (bold) p.setBold();
        return new Cell().add(p).setTextAlignment(TextAlignment.LEFT).setBorder(Border.NO_BORDER);
    }
    private static Cell cellRight(String text, boolean bold) {
        Paragraph p = new Paragraph(nz(text)).setFontSize(8);
        if (bold) p.setBold();
        return new Cell().add(p).setTextAlignment(TextAlignment.RIGHT).setBorder(Border.NO_BORDER);
    }
    private static Cell kv(String k, String v) {
        Cell c = new Cell(1,2).setBorder(Border.NO_BORDER);
        c.add(new Paragraph(k).setFontSize(8));
        Paragraph pv = new Paragraph(v).setTextAlignment(TextAlignment.RIGHT).setFontSize(8);
        c.add(pv);
        return c;
    }
    private static Cell kvBold(String k, String v) {
        Cell c = new Cell(1,2).setBorder(Border.NO_BORDER);
        c.add(new Paragraph(k).setBold().setFontSize(10));
        Paragraph pv = new Paragraph(v).setBold().setTextAlignment(TextAlignment.RIGHT).setFontSize(10);
        c.add(pv);
        return c;
    }

    private static String fmt(double v){ return "Rs. " + String.format("%.2f", v); }
    private static String trimZeros(double v){
        String s = String.format("%.2f", v);
        return s.endsWith(".00") ? s.substring(0, s.length()-3) : s;
    }
    private static String nz(String s){ return (s==null) ? "" : s; }
}

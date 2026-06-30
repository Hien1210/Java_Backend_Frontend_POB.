package org.example.models;

import java.util.ArrayList;
import java.util.List;

public class ShopDashboardStats {
    private double doanhThuHomNay;
    private double doanhThuTuanNay;
    private double doanhThuThangNay;

    private int tongDon;
    private int donHoanThanh;
    private int donHuy;
    private int donChoXuLy;

    private int tongSanPham;
    private int tongTopping;

    private List<TopProduct> topSanPhamBanChay = new ArrayList<>();
    private List<RevenueByDay> doanhThu7NgayQua = new ArrayList<>();

    public double getDoanhThuHomNay() {
        return doanhThuHomNay;
    }

    public void setDoanhThuHomNay(double doanhThuHomNay) {
        this.doanhThuHomNay = doanhThuHomNay;
    }

    public double getDoanhThuTuanNay() {
        return doanhThuTuanNay;
    }

    public void setDoanhThuTuanNay(double doanhThuTuanNay) {
        this.doanhThuTuanNay = doanhThuTuanNay;
    }

    public double getDoanhThuThangNay() {
        return doanhThuThangNay;
    }

    public void setDoanhThuThangNay(double doanhThuThangNay) {
        this.doanhThuThangNay = doanhThuThangNay;
    }

    public int getTongDon() {
        return tongDon;
    }

    public void setTongDon(int tongDon) {
        this.tongDon = tongDon;
    }

    public int getDonHoanThanh() {
        return donHoanThanh;
    }

    public void setDonHoanThanh(int donHoanThanh) {
        this.donHoanThanh = donHoanThanh;
    }

    public int getDonHuy() {
        return donHuy;
    }

    public void setDonHuy(int donHuy) {
        this.donHuy = donHuy;
    }

    public int getDonChoXuLy() {
        return donChoXuLy;
    }

    public void setDonChoXuLy(int donChoXuLy) {
        this.donChoXuLy = donChoXuLy;
    }

    public int getTongSanPham() {
        return tongSanPham;
    }

    public void setTongSanPham(int tongSanPham) {
        this.tongSanPham = tongSanPham;
    }

    public int getTongTopping() {
        return tongTopping;
    }

    public void setTongTopping(int tongTopping) {
        this.tongTopping = tongTopping;
    }

    public List<TopProduct> getTopSanPhamBanChay() {
        return topSanPhamBanChay;
    }

    public void setTopSanPhamBanChay(List<TopProduct> topSanPhamBanChay) {
        this.topSanPhamBanChay = topSanPhamBanChay;
    }

    public List<RevenueByDay> getDoanhThu7NgayQua() {
        return doanhThu7NgayQua;
    }

    public void setDoanhThu7NgayQua(List<RevenueByDay> doanhThu7NgayQua) {
        this.doanhThu7NgayQua = doanhThu7NgayQua;
    }

    public static class TopProduct {
        private long productId;
        private String productName;
        private int soLuongDaBan;
        private double doanhThu;

        public TopProduct() {
        }

        public TopProduct(long productId, String productName, int soLuongDaBan, double doanhThu) {
            this.productId = productId;
            this.productName = productName;
            this.soLuongDaBan = soLuongDaBan;
            this.doanhThu = doanhThu;
        }

        public long getProductId() {
            return productId;
        }

        public void setProductId(long productId) {
            this.productId = productId;
        }

        public String getProductName() {
            return productName;
        }

        public void setProductName(String productName) {
            this.productName = productName;
        }

        public int getSoLuongDaBan() {
            return soLuongDaBan;
        }

        public void setSoLuongDaBan(int soLuongDaBan) {
            this.soLuongDaBan = soLuongDaBan;
        }

        public double getDoanhThu() {
            return doanhThu;
        }

        public void setDoanhThu(double doanhThu) {
            this.doanhThu = doanhThu;
        }
    }

    public static class RevenueByDay {
        private String ngay;
        private double doanhThu;

        public RevenueByDay() {
        }

        public RevenueByDay(String ngay, double doanhThu) {
            this.ngay = ngay;
            this.doanhThu = doanhThu;
        }

        public String getNgay() {
            return ngay;
        }

        public void setNgay(String ngay) {
            this.ngay = ngay;
        }

        public double getDoanhThu() {
            return doanhThu;
        }

        public void setDoanhThu(double doanhThu) {
            this.doanhThu = doanhThu;
        }
    }
}

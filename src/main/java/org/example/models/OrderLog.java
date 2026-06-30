package org.example.models;

public class OrderLog {
    private long id;
    private long orderId;
    private long changedBy;
    private String oldStatus;
    private String newStatus;
    private String note;

    public OrderLog() {
    }

    public OrderLog(long id, long orderId, long changedBy, String oldStatus, String newStatus, String note) {
        this.id = id;
        this.orderId = orderId;
        this.changedBy = changedBy;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.note = note;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public long getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(long changedBy) {
        this.changedBy = changedBy;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    @Override
    public String toString() {
        return "OrderLog{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", changedBy=" + changedBy +
                ", oldStatus='" + oldStatus + '\'' +
                ", newStatus='" + newStatus + '\'' +
                ", note='" + note + '\'' +
                '}';
    }
}

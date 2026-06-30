package org.example.models;

public class ToppingCategory {
    private long id;
    private long shopId;
    private String name;
    private String description;
    private boolean isDeleted;

    public ToppingCategory() {
    }

    public ToppingCategory(long id, long shopId, String name, String description, boolean isDeleted) {
        this.id = id;
        this.shopId = shopId;
        this.name = name;
        this.description = description;
        this.isDeleted = isDeleted;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getShopId() {
        return shopId;
    }

    public void setShopId(long shopId) {
        this.shopId = shopId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }
}

package org.example.models;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class UserProfile {
    private long id;
    private long accountId;
    private LocalDate dateOfBirth;
    private String gender;          // MALE | FEMALE | OTHER
    private Long defaultAddressId;  // FK sang User_Addresses (nullable)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public UserProfile() {}

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public Long getDefaultAddressId() { return defaultAddressId; }
    public void setDefaultAddressId(Long defaultAddressId) { this.defaultAddressId = defaultAddressId; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}

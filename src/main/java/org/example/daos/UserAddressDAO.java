package org.example.daos;

import org.example.models.UserAddress;

import java.util.List;

public interface UserAddressDAO {
    List<UserAddress> findByAccountId(long accountId);
    UserAddress findById(long id);
    boolean create(UserAddress address);
    boolean update(UserAddress address);
    boolean delete(long id);
    boolean setDefault(long addressId, long accountId);
}

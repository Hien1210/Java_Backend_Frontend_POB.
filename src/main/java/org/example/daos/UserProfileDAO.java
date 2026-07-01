package org.example.daos;

import org.example.models.UserProfile;

public interface UserProfileDAO {
    UserProfile findByAccountId(long accountId);
    boolean save(UserProfile profile); // upsert
}

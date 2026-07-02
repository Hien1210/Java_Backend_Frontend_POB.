package org.example.daos;

import org.example.models.Notification;

import java.util.List;

public interface NotificationDAO {
    List<Notification> findByAccountId(long accountId);
    int countUnread(long accountId);
    boolean markAsRead(long notificationId, long accountId);
    boolean markAllAsRead(long accountId);
    boolean create(Notification notification);
}

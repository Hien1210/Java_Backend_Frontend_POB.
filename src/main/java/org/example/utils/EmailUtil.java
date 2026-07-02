package org.example.utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    private static final String host = "smtp.gmail.com";
    private static final String port = "587";
    private static final String username = "phungbaobao5372@gmail.com";
    private static final String password = "xqoglltpyildrebo";


    public static void sendEmail(String toAddress, String subject, String body) throws MessagingException, java.io.UnsupportedEncodingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(username));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
        message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
        message.setContent(body, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}
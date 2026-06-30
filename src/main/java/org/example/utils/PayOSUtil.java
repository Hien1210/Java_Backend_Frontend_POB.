package org.example.utils;

import org.json.JSONObject;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;

/**
 * Gọi API cổng thanh toán PayOS (https://payos.vn) bằng client_key/api_key/check_sum_key
 * cấu hình riêng cho từng Shop (xem {@code Shops.client_key/api_key/check_sum_key}).
 * Không dùng SDK chính thức (chưa có trong Maven Central nội bộ) — gọi REST API thuần qua
 * {@link HttpClient} và tự build/verify chữ ký HMAC-SHA256 theo tài liệu PayOS.
 */
public class PayOSUtil {

    private static final String API_BASE = "https://api-merchant.payos.vn";
    private static final HttpClient HTTP = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();

    private PayOSUtil() {
    }

    public static final class PaymentLinkResult {
        public final boolean success;
        public final String checkoutUrl;
        public final String qrCode;
        public final String paymentLinkId;
        public final String errorMessage;

        private PaymentLinkResult(boolean success, String checkoutUrl, String qrCode, String paymentLinkId, String errorMessage) {
            this.success = success;
            this.checkoutUrl = checkoutUrl;
            this.qrCode = qrCode;
            this.paymentLinkId = paymentLinkId;
            this.errorMessage = errorMessage;
        }
    }

    /**
     * Tạo link thanh toán QR PayOS cho 1 đơn hàng.
     *
     * @param amount số tiền VNĐ, phải là số nguyên (PayOS không nhận số thập phân).
     * @param description tối đa 25 ký tự theo quy định PayOS.
     */
    public static PaymentLinkResult createPaymentLink(String clientId, String apiKey, String checksumKey,
                                                        long orderCode, long amount, String description,
                                                        String returnUrl, String cancelUrl) {
        try {
            String signature = signCreatePaymentRequest(checksumKey, amount, cancelUrl, description, orderCode, returnUrl);

            JSONObject body = new JSONObject();
            body.put("orderCode", orderCode);
            body.put("amount", amount);
            body.put("description", description);
            body.put("returnUrl", returnUrl);
            body.put("cancelUrl", cancelUrl);
            body.put("signature", signature);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_BASE + "/v2/payment-requests"))
                    .timeout(Duration.ofSeconds(15))
                    .header("Content-Type", "application/json")
                    .header("x-client-id", clientId)
                    .header("x-api-key", apiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(body.toString(), StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> response = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            JSONObject json = new JSONObject(response.body());

            String code = json.optString("code", "");
            if (!"00".equals(code)) {
                return new PaymentLinkResult(false, null, null, null, json.optString("desc", "Tao link thanh toan PayOS that bai"));
            }

            JSONObject data = json.getJSONObject("data");
            return new PaymentLinkResult(true, data.optString("checkoutUrl", null), data.optString("qrCode", null),
                    data.optString("paymentLinkId", null), null);
        } catch (Exception e) {
            e.printStackTrace();
            return new PaymentLinkResult(false, null, null, null, "Loi ket noi PayOS: " + e.getMessage());
        }
    }

    /**
     * Trạng thái xác thực server-to-server (gọi lại API PayOS bằng orderCode), KHÔNG tin tưởng
     * trực tiếp query string trên returnUrl vì client có thể tự sửa.
     *
     * @return "PAID", "PENDING", "CANCELLED", "EXPIRED" hoặc null nếu lỗi/không xác định được.
     */
    public static String getPaymentStatus(String clientId, String apiKey, long orderCode) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(API_BASE + "/v2/payment-requests/" + orderCode))
                    .timeout(Duration.ofSeconds(15))
                    .header("x-client-id", clientId)
                    .header("x-api-key", apiKey)
                    .GET()
                    .build();

            HttpResponse<String> response = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            JSONObject json = new JSONObject(response.body());

            if (!"00".equals(json.optString("code", ""))) {
                return null;
            }
            JSONObject data = json.getJSONObject("data");
            return data.optString("status", null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /** Chữ ký cho request tạo link thanh toán: HMAC-SHA256 trên amount/cancelUrl/description/orderCode/returnUrl (thứ tự cố định theo PayOS). */
    private static String signCreatePaymentRequest(String checksumKey, long amount, String cancelUrl, String description,
                                                     long orderCode, String returnUrl) throws Exception {
        String data = "amount=" + amount
                + "&cancelUrl=" + cancelUrl
                + "&description=" + description
                + "&orderCode=" + orderCode
                + "&returnUrl=" + returnUrl;
        return hmacSha256Hex(checksumKey, data);
    }

    /**
     * Verify chữ ký webhook PayOS gửi lên: HMAC-SHA256 trên các field của object "data"
     * sắp xếp theo thứ tự alphabet của tên field, dạng key1=value1&key2=value2...
     */
    public static boolean verifyWebhookSignature(String checksumKey, JSONObject data, String signature) {
        try {
            TreeMap<String, Object> sorted = new TreeMap<>();
            for (String key : data.keySet()) {
                sorted.put(key, data.get(key));
            }
            List<String> parts = new ArrayList<>();
            for (var entry : sorted.entrySet()) {
                Object value = entry.getValue();
                parts.add(entry.getKey() + "=" + (value == null || value == JSONObject.NULL ? "" : value.toString()));
            }
            String dataStr = String.join("&", parts);
            String expected = hmacSha256Hex(checksumKey, dataStr);
            return expected.equalsIgnoreCase(signature);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String hmacSha256Hex(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}

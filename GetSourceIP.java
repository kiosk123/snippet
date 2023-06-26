// https://www.google.com/search?q=%EC%8B%A4%EC%A0%9C+client+ip&oq=%EC%8B%A4%EC%A0%9C+client+ip&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQRRg90gEINDkzNGowajSoAgCwAgA&sourceid=chrome&ie=UTF-8
// 실제 클라이언트 ip 가져오기
public static String getUserIP() {
    ServletRequestAttributes attr = (ServletRequestAttributes)RequestContextHolder.getRequestAttributes();
    HttpServletRequest req = (attr != null ? attr.getRequest() : null);
    String ip = null;
    if (req != null) {
        ip = req.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = req.getRemoteAddr();
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = "0.0.0.0"; // NOPMD
        }
    } else {
        try {
            ip = Inet4Address.getLocalHost().getHostAddress();
        } catch (Exception e) {
            ip = "0.0.0.0"; // NOPMD
        }
    }
    return ip;
}

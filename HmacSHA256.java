import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class HmacSHA256 {

	public static void main(String[] args) {
		String secretKey = "ADE51C527CCC42D9A1615A7FE616F686";
		getHmacSHA256(secretKey, "My name is John");

	}
	
	public static String getHmacSHA256(String secretKey, String data) {
	    String hash = null;
	    try {
	        Mac sha256HMAC = Mac.getInstance("HmacSHA256");
	        byte[] b64 = Base64.getUrlDecoder().decode(secretKey.getBytes("UTF-8"));
	        SecretKeySpec keySpec = new SecretKeySpec(b64, "HmacSHA256");
	        sha256HMAC.init(keySpec);
	        byte[] dofinal = sha256HMAC.doFinal(data.getBytes("UTF-8"));
	        hash = Base64.getUrlEncoder().withoutPadding().encodeToString(dofinal);
	        System.out.println(hash);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return hash;
	}
}

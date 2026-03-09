public with sharing class RazorpayController {
 
    @AuraEnabled
    public static String createOrder(Integer amount){
 
        String keyId = 'rzp_test_SP36FXAp8bh3OK';
        String keySecret = 'kHwitoRWR2eoBEaymOQtmpAQ';
 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.razorpay.com/v1/orders');
        req.setMethod('POST');
 
        String auth = EncodingUtil.base64Encode(
            Blob.valueOf(keyId + ':' + keySecret)
        );
 
        req.setHeader('Authorization','Basic ' + auth);
        req.setHeader('Content-Type','application/json');
 
        String body = '{"amount":'+amount+',"currency":"INR","payment_capture":1}';
 
        req.setBody(body);
 
        Http http = new Http();
        HttpResponse res = http.send(req);
 
        return res.getBody();
    }
 
}
public with sharing class Utility {

    public static String xWWWFormURLEncode(Map<String, Object> payLoadMap) {
        String encodedString = payLoadMap.isEmpty() ? null : '';
        List<String> keyList = new List<String>(payLoadMap.keySet());
        for (integer i = 0; i < payLoadMap.size(); i++) {
            if (payLoadMap.get(keyList[i]) instanceOf Map<String,Object>) {
                encodedString += xWWWFormURLEncodeNestedObject(keyList[i], (Map<String,Object>)payLoadMap.get(keyList[i]));
            } else {
                encodedString += keyList[i];
                encodedString += '=' + EncodingUtil.urlEncode(payLoadMap.get(keyList[i]).toString(), 'UTF-8');
            }

            if (i < payLoadMap.size() - 1) {
                encodedString += '&';
            }
        }
        return encodedString;
    }

        private static String xWWWFormURLEncodeNestedObject(String objectName, Map<String, Object> payLoadMap) {
        String encodedString = payLoadMap.isEmpty() ? null : '';
        List<String> keyList = new List<String>(payLoadMap.keySet());
        for (integer i = 0; i < payLoadMap.size(); i++) {
            if (payLoadMap.get(keyList[i]) == null) continue;
            encodedString += objectName + '[';
            encodedString += keyList[i];
            encodedString += ']';
            encodedString += '=' + EncodingUtil.urlEncode(payLoadMap.get(keyList[i]).toString(), 'UTF-8');
            if (i < payLoadMap.size() - 1) {
                encodedString += '&';
            }
        }
        return encodedString;
    }
}
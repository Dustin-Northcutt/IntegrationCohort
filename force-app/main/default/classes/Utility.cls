public with sharing class Utility {

    public static String xWWWFormURLEncode(Map<String, Object> payLoadMap) {
        String encodedString; 
        if (payLoadMap.isEmpty()) {
            return encodedString;
        } else {
            encodedString = '';
        }
        
        List<String> keyList = new List<String>(payLoadMap.keySet());
        for (integer i = 0; i < payLoadMap.size(); i++) {         
            String encodedStringValue;
            if (payLoadMap.get(keyList[i]) instanceOf Map<String,Object>) {
                encodedStringValue = xWWWFormURLEncodeNestedObject(keyList[i], (Map<String,Object>)payLoadMap.get(keyList[i]));
                if (String.isBlank(encodedStringValue)) continue;
            } else {
                if (payLoadMap.get(keyList[i]) == null || String.isBlank(payLoadMap.get(keyList[i]).toString())) continue;
                encodedStringValue = keyList[i];
                encodedStringValue += '=' + EncodingUtil.urlEncode(payLoadMap.get(keyList[i]).toString(), 'UTF-8');
            }
            encodedStringValue += '&';
            encodedString += encodedStringValue;
            
        }
        if (encodedString.endsWith('&')) {
            encodedString = encodedString.removeEnd('&');
        }
        return encodedString;
    }

        private static String xWWWFormURLEncodeNestedObject(String objectName, Map<String, Object> payLoadMap) {
        String encodedString = payLoadMap.isEmpty() ? null : '';
        List<String> keyList = new List<String>(payLoadMap.keySet());
        for (integer i = 0; i < payLoadMap.size(); i++) {
            if (String.isBlank((String)payLoadMap.get(keyList[i]))) continue;
            encodedString += objectName + '[';
            encodedString += keyList[i];
            encodedString += ']';
            encodedString += '=' + EncodingUtil.urlEncode(payLoadMap.get(keyList[i])?.toString(), 'UTF-8');
            if (i < payLoadMap.size() - 1) {
                encodedString += '&';
            }
        }
        return encodedString;
    }
}
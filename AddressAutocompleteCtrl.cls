public with sharing class AddressAutocompleteCtrl {
    private static final String KEY = 'key=' + 'key';
    private static final String AUTOCOMPLETE_BASE_URL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?types=address';
    private static final String DETAILS_BASE_URL = 'https://maps.googleapis.com/maps/api/place/details/json?fields=address_components';

    @AuraEnabled
    public static String getSuggestions(String input, String sessionToken, String language) {
        String url = String.join(new List<String>{
                AUTOCOMPLETE_BASE_URL, getLanguage(language), getInput(input), getSessionToken(sessionToken), KEY
        }, '&');
        return getResponse(url);
    }

    @AuraEnabled
    public static String getPlaceDetails(String placeId, String sessionToken, String language) {
        String url = String.join(new List<String>{
                DETAILS_BASE_URL, getLanguage(language), getPlaceId(placeId), getSessionToken(sessionToken), KEY
        }, '&');
        return getResponse(url);
    }

    private static String getSessionToken(String token) {
        return 'sessiontoken=' + EncodingUtil.urlEncode(token, 'UTF-8');
    }

    private static String getLanguage(String language) {
        return 'language=' + EncodingUtil.urlEncode(language, 'UTF-8');
    }

    private static String getPlaceId(String placeId) {
        return 'placeid=' + EncodingUtil.urlEncode(placeId, 'UTF-8');
    }

    private static String getInput(String input) {
        return 'input=' + EncodingUtil.urlEncode(input, 'UTF-8');
    }

    public static String getResponse(String strURL) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        res = h.send(req);
        String responseBody = res.getBody();
        return responseBody;
    }
}

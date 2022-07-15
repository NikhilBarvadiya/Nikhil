Map<String, dynamic> environment = {
  "serverConfig": {
    'apiUrl': 'http://admin.fastwhistle.com:3500/v3/',
    'baseUrl': 'http://admin.fatwhistle.com:3500',
    'apiVersion': 'v1',
    'accessToken': '292105248cc4118ee8f2ccb0a97cd54d',
    'playStoreURL': 'https://play.google.com/store/apps/details?id=com.appName',
    'appStoreURL': 'https://apps.apple.com/us/app/itunes-connect/id8978990',
    'appDownloadURL': 'https://staging.carerockets.com/redirect/app-download',
    // http://admin.fastwhistle.com:3500/v3/site/manager/login
  },
  "advanceConfig": {
    "defaultLanguage": "en",
    "defaultCurrency": {
      "symbol": "₹",
      "decimalDigits": 0,
      "symbolBeforeTheNumber": true,
      "currency": "INR",
      "currencyCode": "INR",
    },
    "isMultiLanguages": false,
  },
  "loginSetting": {
    "IsRequiredLogin": false,
    "showAppleLogin": false, // Nitin
    "showFacebook": false, // Nitin
    "showSMSLogin": false, // Nitin
    "showGoogleLogin": false, // Nitin
    "showPhoneNumberWhenRegister": true,
    "requirePhoneNumberWhenRegister": true,

    /// For Facebook login.
    "facebookAppId": "430258564493822",
    "facebookLoginProtocolScheme": "fb430258564493822",
  },
  "imagesbaseUrl": "https://fastwhistle.s3.amazonaws.com/"
};

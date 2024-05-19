class AppLink {
  //Test
  static const String test = 'https://jsonplaceholder.typicode.com/posts';
// server App
  static const String server = 'https://ejaz.applab.qa/api/ejaz/v1';

  static const String imageststatic =
      'https://ejaz.applab.qa/api/ejaz/v1/Book/getBooks';//https://ejaz-api.azurewebsites.net  (Azure server with credential --whsini@hbku.edu.qa--)

//========================== Image ============================
  static const String imagestCategories = '$imageststatic/categories';
  static const String imagestItems = '$imageststatic/items';
// =============================================================
//function update token
  static const String updatetoken = '$server/Account/updateFirebaseToken';
//function checklogin
  static const String checklogin = '$server/Account/isUserExist';
  static const String login = '$server/Account/OAuthFree';
  static const String signup = '$server/Account/registerOAuthFree';
  static const String updatepassword = '$server/Account/UpdatePassword';
  static const String forgetpassword = '$server/Account/updateForgotPassword';
  static const String getbook =
      '$server/Book/getBooks?search=&status=active&pageSize=1000&orderBy=Title&orderAs=DESC'; //?search=&status=active&pageSize=50&orderBy=Title&orderAs=DESC
  static const String category = '$server/Category/getCategories';
  static const String authors = '$server/Author/getAuthors';
  //**************** Api link for getsubscritipn ******************/
  static const String getsubscritipn = '$server/Subscription/getSubscriptions';
  static const String getejazcollection =
      '$server/BookCollection/getBookCollections';
  static const String getejazcollectionById =
      '$server/BookCollection/getBookCollection/';
  //**************** Api link for updateprofile ******************/
  static const String updateprofile = '$server/Profile/updateProfile';
  //**************** Api link for doPayment ******************/
  static const String paymentdo = '$server/Payment/doPayment';
   //**************** Api link for GiftEjaz ******************/
  static const String giftejaz = '$server/Payment/giftPayment';
  //**************** Api link for Banner/getBanners ******************/
  static const String banner = '$server/Banner/getBanners';
 //**************** Api link for Banner/getBanners ******************/
  static const String suggest = '$server/Book/suggestBook';
//  static const String getbook =
  //   'https://gist.githubusercontent.com/JohannesMilke/d53fbbe9a1b7e7ca2645db13b995dc6f/raw/eace0e20f86cdde3352b2d92f699b6e9dedd8c70/books.json';
}

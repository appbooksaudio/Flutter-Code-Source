import UIKit
import Flutter
import FirebaseCore
import Firebase
import FirebaseAuth
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
   private var textField = UITextField()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
   //  self.window.makeSecure() //Add this line
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
 override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
    }
   //Auth
// override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//            let firebaseAuth = Auth.auth()
//            firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
//  }
 override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           let firebaseAuth = Auth.auth()
           if (firebaseAuth.canHandleNotification(userInfo)){
               print(userInfo)
               return
           }
 }




     // <Add>
//override func applicationWillResignActive(
//    _ application: UIApplication
//  ) {
//    self.window.isHidden = true;
//  }
//  override func applicationDidBecomeActive(
//    _ application: UIApplication
//  ) {
//    self.window.isHidden = false;
//  }
 
}
//And this extension
extension UIWindow {
func makeSecure() {
    let field = UITextField()
    field.isSecureTextEntry = true
    self.addSubview(field)
    field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.layer.superlayer?.addSublayer(field.layer)
    field.layer.sublayers?.first?.addSublayer(self.layer)
  }
}

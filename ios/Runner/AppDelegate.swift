import UIKit
import Flutter
import Firebase
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let gcmMessageIDKey = "gcm.message_id"
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
 [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
      // [START set_messaging_delegate]
          Messaging.messaging().delegate = self
          // [END set_messaging_delegate]
    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: { _, _ in }
            )
          } else {
            let settings: UIUserNotificationSettings =
              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
          }

          application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions:
  launchOptions)
  }
  override func application(_ application: UIApplication,
  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

   Messaging.messaging().apnsToken = deviceToken
   print("Token: \(deviceToken)")
   super.application(application,
   didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
 }
    
}
extension AppDelegate: MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")

    let dataDict: [String: String] = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: dataDict
    )
      let url = URL(string: "https://httpbin.org/post")!
      var request = URLRequest(url: url)
      request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      request.httpMethod = "POST"
      let parameters: [String: String] = [
          "Token": fcmToken ?? "",
      ]
      do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }

      
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard
              let data = data,
              let response = response as? HTTPURLResponse,
              error == nil
          else {                                                               // check for fundamental networking error
              print("error", error ?? URLError(.badServerResponse))
              return
          }
          
          guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
              print("statusCode should be 2xx, but is \(response.statusCode)")
              print("response = \(response)")
              return
          }
          
          // do whatever you want with the `data`, e.g.:
          
          
      }

      task.resume()
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }

  // [END refresh_token]
    
    
}


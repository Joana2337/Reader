
import UIKit
import CloudKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Initialize CloudKit
        checkCloudKitAvailability()
        return true
    }
    
    private func checkCloudKitAvailability() {
        // First check if iCloud is enabled on the device
        let status = FileManager.default.ubiquityIdentityToken != nil
        
        guard status else {
            print("iCloud is not enabled on this device")
            return
        }
        
        // Then check CloudKit availability
        CKContainer.default().accountStatus { [weak self] (accountStatus, error) in
            DispatchQueue.main.async {
                self?.handleCloudKitAccountStatus(accountStatus, error: error)
            }
        }
    }
    
    private func handleCloudKitAccountStatus(_ accountStatus: CKAccountStatus, error: Error?) {
        switch accountStatus {
        case .available:
            print("CloudKit is available")
            // Initialize your CloudKit container here if needed
        case .noAccount:
            print("No iCloud account found")
        case .restricted:
            print("iCloud account is restricted")
        case .couldNotDetermine:
            if let error = error {
                print("Could not determine iCloud status: \(error.localizedDescription)")
            }
        case .temporarilyUnavailable:
            print("iCloud account temporarily unavailable")
        @unknown default:
            print("Unknown iCloud account status")
        }
    }
}

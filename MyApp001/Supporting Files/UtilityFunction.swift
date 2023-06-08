import Foundation
import UIKit



let API = "https://kontests.net/api/v1/all"



class UtilityFunction: NSObject {
    func showAlert(vc: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okeyButton = UIAlertAction(title: "OK", style: .default,handler: nil)
        alert.addAction(okeyButton)
        vc.present(alert, animated: true, completion: nil)
    }
}



struct Competition: Codable {
    let name: String
    let startTime: String
    let endTime: String

    enum CodingKeys: String, CodingKey {
        case name
        case startTime = "start_time"
        case endTime = "end_time"
    }
}

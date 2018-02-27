import UIKit

class VerificationResultViewController: UIViewController {
    
    @IBOutlet var successIndication: UILabel! = UILabel()
    
    var message: String?
    
    override func viewDidLoad() {
        if let resultToDisplay = message {
            successIndication.text = resultToDisplay
        } else {
            successIndication.text = "Something went wrong!"
        }
        super.viewDidLoad()
    }
}

import UIKit

class VerificationStartViewController: UIViewController {
    @IBOutlet var phoneNumberField: UITextField! = UITextField()
    
    @IBAction func sendVerification() {
        if let phoneNumber = phoneNumberField.text {
            AuthyAPI.sendVerificationCode(phoneNumber)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? VerificationCheckViewController {
            dest.phoneNumber = phoneNumberField.text
        }
    }
}

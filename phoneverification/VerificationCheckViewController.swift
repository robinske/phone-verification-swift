import UIKit

class VerificationCheckViewController: UIViewController {
    
    @IBOutlet var codeField: UITextField! = UITextField()
    @IBOutlet var errorLabel: UILabel! = UILabel()
    
    var phoneNumber: String?
    var resultMessage: String?
    
    @IBAction func validateCode() {
        self.errorLabel.text = nil // reset
        if let code = codeField.text {
            AuthyAPI.validateVerificationCode(self.phoneNumber!, code) { checked in
                if (checked.success) {
                    self.resultMessage = checked.message
                    self.performSegue(withIdentifier: "checkResultSegue", sender: nil)
                } else {
                    self.errorLabel.text = checked.message
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkResultSegue",
            let dest = segue.destination as? VerificationResultViewController {
                dest.message = resultMessage
        }
    }
}

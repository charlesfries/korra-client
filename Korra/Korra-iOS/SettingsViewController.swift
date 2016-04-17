
import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet var serverIP: UITextField!
    
    override func viewDidLoad() {
        serverIP.text = "0.0.0.0"
    }

}
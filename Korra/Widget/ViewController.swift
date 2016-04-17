
import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var serverIP = "10.46.1.179"
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    @IBOutlet var allLightsIntensity: UISlider!
    
    @IBAction func allLightsOn(sender: AnyObject) {
        updatePower("Desk", flag: true)
        updatePower("Tall", flag: true)
    }
    @IBAction func allLightsOff(sender: AnyObject) {
        updatePower("Desk", flag: false)
        updatePower("Tall", flag: false)
    }
    
    func updatePower(var device: String, flag: Bool) {
        if (device == "Desk") {
            device = "desk"
        } else if (device == "Tall") {
            device = "tall"
        }
        
        var flagger: String
        if (flag) {
            flagger = "On"
        } else {
            flagger = "Off"
        }
        
        makeReq("http://\(serverIP)/dashboard.php?s=\(device)Lamp\(flagger)")
    }
    
    func updateIntensity(var device: String, intensity: Int) {
        if (device == "Desk") {
            device = "desk"
        } else if (device == "Tall") {
            device = "tall"
        }
        makeReq("http://\(serverIP)/dashboard.php?s=\(device)LampIntensity&intensity=\(intensity)")
    }
    
    func makeReq(url: String) {
        activity.startAnimating()
        let url = NSURL(string: url)
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.activity.stopAnimating()
        }
    }
    
    
    
    
        
    override func viewDidLoad() {
        self.preferredContentSize = CGSizeMake(0, 49);
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
}
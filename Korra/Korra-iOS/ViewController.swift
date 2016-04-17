
import UIKit

class ViewController: UITableViewController {
    
    var serverIP = "10.46.1.179"
    
    @IBOutlet var activity: UIActivityIndicatorView!
    
    @IBOutlet var allLightsIntensity: UISlider!
    
    @IBOutlet var deskLampIntensity: UISlider!
    
    @IBOutlet var tallLampIntensity: UISlider!
    
    // All Lights
    @IBAction func allLightsOn(sender: AnyObject) {
        updatePower("Desk", flag: true)
        updatePower("Tall", flag: true)
    }
    @IBAction func allLightsOff(sender: AnyObject) {
        updatePower("Desk", flag: false)
        updatePower("Tall", flag: false)
    }
    @IBAction func allLightsUpdateIntensity(sender: AnyObject) {
        updateIntensity("Desk", intensity: Int(allLightsIntensity.value*100))
        updateIntensity("Tall", intensity: Int(allLightsIntensity.value*100))
    }
    
    // Desk Lamp
    @IBAction func deskLampOn(sender: AnyObject) {
        updatePower("Desk", flag: true)
    }
    @IBAction func deskLampOff(sender: AnyObject) {
        updatePower("Desk", flag: false)
    }
    @IBAction func deskLampUpdateIntensity(sender: AnyObject) {
        updateIntensity("Desk", intensity: Int(deskLampIntensity.value*100))
    }
    
    // Tall Lamp
    @IBAction func tallLampOn(sender: AnyObject) {
        updatePower("Tall", flag: true)
    }
    @IBAction func tallLampOff(sender: AnyObject) {
        updatePower("Tall", flag: false)
    }
    @IBAction func tallLampUpdateIntensity(sender: AnyObject) {
        updateIntensity("Tall", intensity: Int(tallLampIntensity.value*100))
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

}
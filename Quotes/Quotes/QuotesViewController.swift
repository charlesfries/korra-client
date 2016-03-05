
import Cocoa
import WebKit

public extension NSColor {
    func getHexString() -> String {
        let red = Int(round(self.redComponent * 0xFF))
        let grn = Int(round(self.greenComponent * 0xFF))
        let blu = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "%02X%02X%02X", red, grn, blu)
        return hexString as String
    }
}

class QuotesViewController: NSViewController {
    
    //@IBOutlet var webView: WebView!
    @IBOutlet weak var progress: NSProgressIndicator!
    
    @IBOutlet weak var deskLampColor: NSColorWell!
    @IBOutlet weak var deskLampIntensity: NSSlider!
    
    @IBOutlet weak var tallLampColor: NSColorWell!
    
    // Triggers //////////////////////////////////////////////////
    
    override func viewDidLoad() {
        /*let url = NSURL(string: "http://10.46.1.179/dashboard.php")
        let request = NSURLRequest(URL: url!)
        webView.mainFrame.loadRequest(request)*/
    }
    
    override func viewDidAppear() {
        
        deskLampColor.color = getRandomColor()
        tallLampColor.color = getRandomColor()
    }
    
    // Server Functions //////////////////////////////////////////////////
    
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
        
        makeReq("http://10.46.1.179/dashboard.php?s=\(device)Lamp\(flagger)")
    }
    
    func updateColor(var device: String, color: NSColor) {
        if (device == "Desk") {
            device = "desk"
        } else if (device == "Tall") {
            device = "tall"
        }
        makeReq("http://10.46.1.179/dashboard.php?s=\(device)LampColor&color=\(color.getHexString())")
    }
    
    func updateIntensity(var device: String, intensity: Int) {
        if (device == "Desk") {
            device = "desk"
        } else if (device == "Tall") {
            device = "tall"
        }
        makeReq("http://10.46.1.179/dashboard.php?s=\(device)LampIntensity&intensity=\(intensity)")
    }
    
    // Class Functions //////////////////////////////////////////////////
    
    func makeReq(url: String) {
        progress.startAnimation(self)
        let url = NSURL(string: url)
        let request = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.progress.stopAnimation(self)
        }
    }
    
    func getRandomColor() -> NSColor {
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return NSColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    // IBActions //////////////////////////////////////////////////
    
    @IBAction func deskLampOn(sender: AnyObject) {
        updatePower("Desk", flag: true)
    }
    @IBAction func deskLampOff(sender: AnyObject) {
        updatePower("Desk", flag: false)
    }
    @IBAction func deskLampUpdateColor(sender: AnyObject) {
        updateColor("Desk", color: deskLampColor.color)
    }
    @IBAction func deskLampUpdateIntensity(sender: AnyObject) {
        updateIntensity("Desk", intensity: deskLampIntensity.integerValue)
    }
    
    @IBAction func tallLampOn(sender: AnyObject) {
        updatePower("Tall", flag: true)
    }
    @IBAction func tallLampOff(sender: AnyObject) {
        updatePower("Tall", flag: false)
    }
    @IBAction func tallLampUpdateColor(sender: AnyObject) {
        updateColor("Tall", color: deskLampColor.color)
    }
    @IBAction func tallLampUpdateIntensity(sender: AnyObject) {
        updateIntensity("Tall", intensity: deskLampIntensity.integerValue)
    }
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.sharedApplication().terminate(sender)
    }
}
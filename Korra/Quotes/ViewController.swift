
import Cocoa
import WebKit

class QuotesViewController: NSViewController {
    
    @IBOutlet weak var deskLampColor: NSColorWell!
    @IBOutlet weak var tallLampColor: NSColorWell!
    @IBOutlet weak var allLightsColor: NSColorWell!
    
    @IBOutlet weak var deskLampIntensity: NSSlider!
    @IBOutlet weak var tallLampIntensity: NSSlider!
    @IBOutlet weak var allLightsIntensity: NSSlider!
    
    @IBOutlet weak var progress: NSProgressIndicator!
    
    override func viewDidAppear() {
        deskLampColor.color = getRandomColor()
        tallLampColor.color = getRandomColor()
        allLightsColor.color = getRandomColor()
    }
    
    // Actions
    
    // Desk Lamp
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
    
    // Tall Lamp
    @IBAction func tallLampOn(sender: AnyObject) {
        updatePower("Tall", flag: true)
    }
    @IBAction func tallLampOff(sender: AnyObject) {
        updatePower("Tall", flag: false)
    }
    @IBAction func tallLampUpdateColor(sender: AnyObject) {
        updateColor("Tall", color: tallLampColor.color)
    }
    @IBAction func tallLampUpdateIntensity(sender: AnyObject) {
        updateIntensity("Tall", intensity: tallLampIntensity.integerValue)
    }
    
    // All Lights
    @IBAction func allLightsOn(sender: AnyObject) {
        updatePower("Desk", flag: true)
        updatePower("Tall", flag: true)
    }
    @IBAction func allLightsOff(sender: AnyObject) {
        updatePower("Desk", flag: false)
        updatePower("Tall", flag: false)
    }
    @IBAction func allLightsUpdateColor(sender: AnyObject) {
        updateColor("Desk", color: allLightsColor.color)
        updateColor("Tall", color: allLightsColor.color)
    }
    @IBAction func allLightsUpdateIntensity(sender: AnyObject) {
        updateIntensity("Desk", intensity: allLightsIntensity.integerValue)
        updateIntensity("Tall", intensity: allLightsIntensity.integerValue)
    }
    @IBAction func allLightsStrobe(sender: AnyObject) {
        makeReq("http://10.46.1.179/controller.php?s=query")
    }
    
    // Other
    @IBAction func quit(sender: NSButton) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    // Server Communication
    
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
    
    // Internal Functions
    
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
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        return NSColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}



public extension NSColor {
    func getHexString() -> String {
        let red = Int(round(self.redComponent * 0xFF))
        let grn = Int(round(self.greenComponent * 0xFF))
        let blu = Int(round(self.blueComponent * 0xFF))
        let hexString = NSString(format: "%02X%02X%02X", red, grn, blu)
        return hexString as String
    }
}

public class EventMonitor {
    private var monitor: AnyObject?
    private let mask: NSEventMask
    private let handler: NSEvent? -> ()
    
    public init(mask: NSEventMask, handler: NSEvent? -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handler: handler)
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}

import Cocoa
import WebKit

class QuotesViewController: NSViewController {
    
    @IBOutlet var webView: WebView!
    
    override func viewDidLoad() {
        
        let url = NSURL(string: "http://10.46.1.179/dashboard.php")
        let request = NSURLRequest(URL: url!)
        webView.mainFrame.loadRequest(request)
    }
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.sharedApplication().terminate(sender)
    }
}
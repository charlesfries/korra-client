
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  
  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(20) // -2
  let popover = NSPopover()
  var eventMonitor: EventMonitor?

  func applicationDidFinishLaunching(notification: NSNotification) {
    if let button = statusItem.button {
      button.image = NSImage(named: "Cool")
      button.action = Selector("togglePopover:")
    }

    popover.contentViewController = QuotesViewController(nibName: "Main", bundle: nil)

    eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
      if self.popover.shown {
        self.closePopover(event)
      }
    }
    eventMonitor?.start()
  }

  func togglePopover(sender: AnyObject?) {
    if popover.shown {
      closePopover(sender)
    } else {
      showPopover(sender)
    }
  }

  func showPopover(sender: AnyObject?) {
    if let button = statusItem.button {
      popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
    }
    eventMonitor?.start()
  }

  func closePopover(sender: AnyObject?) {
    popover.performClose(sender)
    eventMonitor?.stop()
  }
}
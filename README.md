# Citrix ITM Radar Runner for Apple OS X and iOS

### Quick Start

 * Copy either the Objective-C or Swift files to your project.
 * Add the CocoaPod. "RadarKit" or "RadarKit/ObjC"
 * Create an instance of the RadarKit class.
 * Call the start method with your zoneId and customerId.
 * Call didReceiveMemoryWarning from your delegate of the same name.

### Swift

Step by step guide for Xcode 8 and Swift. We'll create the simplest possible
application with the Radar client embedded.

 * Create a new iOS project as a "Single View Application". Give it a name and
   make sure the language option is set to "Swift".

 * Add the CocoaPod to your `Podfile` and `pod install`.

       use_frameworks!
       pod 'RadarKit'

 * Edit the ViewController class. Add the four lines containing "radarkit" so
   it looks like the code below. You will need to use your real zone ID and
   customer ID for this to actually send data, but it's ok to test with 00000.

       import RadarKit

       class ViewController: UIViewController {

           let radarkit = RadarKit()

           override func viewDidLoad() {
               super.viewDidLoad()
               radarkit.start(forZoneId: 1, customerId: 00000)
           }

           override func didReceiveMemoryWarning() {
               super.didReceiveMemoryWarning()
               radarkit.didReceiveMemoryWarning()
           }
       }

 * Run the program. You are done.

### Objective-C

Step by step guide for Xcode 8 and Objective-C. We'll create the simplest
possible application with the Radar client embedded.

 * Create a new iOS project as a "Single View Application". Give it a name and
   make sure the language option is set to "Objective-C".

* Add the CocoaPod to your `Podfile` and `pod install`.

       pod 'RadarKit/ObjC'

 * Edit "ViewController.m". Add the five lines containing "radarkit" so
   it looks like the code below. You will need to use your real zone ID and
   customer ID for this to actually send data, but it's ok to test with 00000.

        #import "ViewController.h"
        #import "RadarKit.h"

        @interface ViewController ()
        { @private RadarKit *radarkit; }
        @end

        @implementation ViewController

        - (void)viewDidLoad {
            [super viewDidLoad];
            radarkit = [RadarKit new];
            [radarkit startForZoneId:1 customerId:00000];
        }

        - (void)didReceiveMemoryWarning {
            [super didReceiveMemoryWarning];
            [radarkit didReceiveMemoryWarning];
        }

        @end

 * Run the program. You are done.

### Using the API

`radarkit.start` may be called repeatedly. Every time you call this a new probing
session will run. Be aware that there is a waiting period between sessions
(currently 1 minute, subject to change).

`radarkit.didReceiveMemoryWarning` will free up all but a few bytes of memory. Note
that after calling this there is startup cost the next time `start` is called.

### Notes

All this does is load our radar tag in a WebView with a little bit of throttling.
Because WebView is a UI element you must call the API on the UI thread.

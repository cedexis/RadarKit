RadarKit
========

A Cedexis Radar client for iOS.

## Installation with CocoaPods

RadarKit is available on [CocoaPods](http://www.cocoapods.org). Add the following to your `Podfile`:

    pod 'RadarKit'

## Installation with the .framework file

1. Download the latest framework file from the [Releases section](https://github.com/cedexis/RadarKit/releases).
2. Unzip the file by double-clicking on it.
3. Drag the RadarKit.framework file and drop it into your project.
4. In XCode, select your project's name > Build Phases > Link Binary With Libraries > Add the CoreTelephony.framework (this is a dependency).

## Manual installation

The first step is to add the RadarKit project into your own project. There are two principle ways to do that:

1. Downloading the code from Github.
2. Using a git submodule.

### Downloading from Github

You can download the code directly from Gitbug.  From your project's' root directory:

```bash
$ mkdir -p Vendor/RadarKit
$ curl -L https://github.com/cedexis/RadarKit/tarball/master | tar xz --strip 1 -C Vendor/RadarKit
```

### Using a git submodule

A good alternative to directly downloading the RadarKit source code is to use a git submodule.  This has the
advantage of helping you to keep abreast of changes to the library.

From within your project:

```bash
$ git submodule add https://github.com/cedexis/RadarKit.git Vendor/RadarKit
```

### Add RadarKit to Your Project

1. Add the RadarKit xcodeproj file to your Xcode project using Finder.

2. Select the _Build Phases_ tab of the project build target you're working with.

3. Expand the _Target Dependencies_ section.  Click the plus button and add the RadarKit project.

4. Under the _Link Binary With Libraries_ section, click the plus button and add libRadarKit.a.

5. Choose the _Build Settings_ tab.  Make sure _All_ is selected at the top.

6. Add Vendor/RadarKit to the _Header Search Path_.

7. Add -all_load and -ObjC to _Other Linker Flags_.

## Usage: Executing Radar Sessions

A typical Radar session downloads at most a few dozen files in a span of about 10 seconds.

Choose a specific point in your application code when you would like to execute a Radar session.
At the top of the implementation file, add:

```Objective-C
#import <RadarKit/RadarKit.h>
```

Then at the exact point where you'd like to _schedule_ a Radar session, add the following code:

```Objective-C
CDXRadar *radar = [[CDXRadar alloc] initWithZoneId:1 
                                        customerId:XXXXX // <-- Replace this with your own Cedexis customer ID.
];
[radar runInBackground];
```

By default, RadarKit only measures probes set up with HTTPS URLs.  If you need to measure probes having HTTP URLs, there is an alternate initialization that includes a *protocol* argument, which should be set to "http":

```Objective-C
CDXRadar *radar = [[CDXRadar alloc] initWithZoneId:1 
                                        customerId:XXXXX // <-- Replace this with your own Cedexis customer ID.
                                          protocol:@"http"
];
```
If you'd like to execute code when the Radar session is finished, you can use:

```Objective-C
[radar runInBackgroundWithCompletionHandler:^(NSError *error) {
    if (error) {
        // Handle the error here
    } else {
        // Your code here
    }
}];
```

To make RadarKit log all activity to the console, including errors and successful messages, add the following before executing the `runInBackground` method:

```Objective-C
radar.isVerbose = YES;
```

If you need to cancel the Radar session for whatever reason, you can do the following:

```Objective-C
CDXRadarSession *session = [radar runInBackground];
[session cancel]; // Add this line at the exact point you'd like the session to stop
```

Be sure to supply your own Cedexis zone and customer IDs as arguments to the Radar class's
runForZone:AndCustomerId method.

If you don't know these, they can be obtained from the Cedexis portal at the following URL:
https://portal.cedexis.com/ui/radar/tag. This page lists the standard Cedexis Radar
JavaScript tag. Your zone ID and customer ID are embedded in the URL found in the tag.
For example, if the tag shows the URL `//radar.cedexis.com/1/12345/radar.js`, then your
zone ID is `1` and your customer ID is `12345`.

## Sample Application

There is a trivial example application demonstrating this integration technique availabile
at [SimpleRadarKitDemo](https://github.com/cedexis/SimpleRadarKitDemo).

## Credits

We'd like to give credit to Sam Soffes. The steps above for integrating third-party libraries
come from his [S.S. Toolkit](http://sstoolk.it/) site.


# RadarKit

A Cedexis Radar client for iOS.

## Simple Integration

The first step is to add the RadarKit project into your own project.  There are two principle ways to do that:

1. downloading the code from Github
2. using a git submodule.

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

## Executing Radar Sessions

A typical Radar session downloads at most a few dozen files in a span of about 10 seconds.

Choose a specific point in your application code when you would like to execute a Radar session.
At the top of the implementation file, add:

```Objective-C
#import <RadarKit/RadarKit.h>
```

Then at the exact point where you'd like to _schedule_ a Radar session, add the following code:

```Objective-C
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [[[Radar alloc] init]
        runForZoneId:1
       AndCustomerId:10660 // <-- Replace this with your own Cedexis customer ID.
    ];
});

```

That's basically all there is to it.

This code causes the Radar client to be executed as a concurrent task of default priority.
If you prefer, you can replace the `DISPATCH_QUEUE_PRIORITY_DEFAULT` argument with one of
the other options in order to cause Radar to run at a higher or lower priority.  See
[dispatch_queue_priority_t](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html#//apple_ref/doc/constant_group/dispatch_queue_priority_t).

Be sure to supply your own Cedexis zone and customer IDs as arguments to the Radar class's
runForZone:AndCustomerId method.

If you don't know these, they can be obtained from the Cedexis portal at the following URL:
https://portal.cedexis.com/ui/radar/tag.  This page lists the standard Cedexis Radar
JavaScript tag.  Your zone ID and customer ID are embedded in the URL found in the tag.
For example, if the tag shows the URL `//radar.cedexis.com/1/12345/radar.js`, then your
zone ID is `1` and your customer ID is `12345`.

## Sample Application

There is a trivial example application demonstrating this integration technique availabile
at [SimpleRadarKitDemo](https://github.com/cedexis/SimpleRadarKitDemo).

## Credits

I want to give credit to Sam Soffes.  The steps above for integrating third-party libraries
come from his [S.S. Toolkit](http://sstoolk.it/) site.


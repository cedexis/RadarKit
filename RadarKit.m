// Copyright 2018 Citrix Systems, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import "RadarKit.h"
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

// 4 is the client profile for iOS (Objective-C)
const int CLIENT_PROFILE = 4;
// The profile version expresses the version of the Radar runner code used to invoke the webview
const int CLIENT_PROFILE_VERSION = 2;

@interface RadarKit()
{
@private
    NSMutableArray *commands;
    WKWebView *webView;
    NSDate *hibernateUntil;
    Boolean radarLoaded;
}
@end

@implementation RadarKit

- (id)init {
    commands = [NSMutableArray new];
    hibernateUntil = [NSDate new];
    return self;
}

- (void)startForZoneId:(int)zoneId customerId:(int)customerId {
    [commands addObject:[NSString stringWithFormat:@"cedexis.start(%d,%d,%d,%d);",
                         zoneId, customerId, CLIENT_PROFILE, CLIENT_PROFILE_VERSION]];
    [self process];
}

- (void)didReceiveMemoryWarning {
    [self unload];
}

- (void)process {
    if ([NSDate.date compare:hibernateUntil] == NSOrderedAscending) {
        [commands removeAllObjects];
        return;
    }
    if (webView == nil) {
        webView = [WKWebView new];
        webView.navigationDelegate = self;
        NSURL *url = [NSURL URLWithString:@"https://radar.cedexis.com/0/0/radar.html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
    }
    if (radarLoaded) {
        while([commands count]) {
            NSString *command = [commands objectAtIndex:0];
            [webView evaluateJavaScript:command completionHandler:nil];
            [commands removeObjectAtIndex:0];
        }
    }
}

- (void)unload {
    if (webView != nil) {
        webView.navigationDelegate = nil;
        webView = nil;
        radarLoaded = false;
    }
}

// When anything bad happens we shut down for one hour.
// Typically, this would happen when not connected to the internet.
- (void)hibernate {
    [self unload];
    [commands removeAllObjects];
    hibernateUntil = [NSDate.date dateByAddingTimeInterval:(60*60)];
}


// Called when the navigation is complete.
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    radarLoaded = true;
    [self process];
}

// Called when an error occurs during navigation.
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hibernate];
}

// Called when an error occurs while the web view is loading content.
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self hibernate];
}

// Called when the web view’s web content process is terminated.
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self hibernate];
}

@end

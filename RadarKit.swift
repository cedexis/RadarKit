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

import Foundation
import WebKit

public class RadarKit : NSObject, WKNavigationDelegate {

    public func start(forZoneId: Int, customerId: Int) {
        commands.append("cedexis.start(\(zoneId),\(customerId),\(clientProfile),\(clientProfileVersion));");
        process()
    }

    public func didReceiveMemoryWarning() {
        unload()
    }

    private var webView: WKWebView?
    private var radarLoaded = false
    // 1 is the client profile for iOS (Swift)
    private let clientProfile = 1
    // The profile version expresses the version of the Radar runner code used
    // to invoke the webview
    private let clientProfileVersion = 1
    private var commands: [String] = []
    private var hibernateUntil = Date()

    private func process() {
        if (Date() < hibernateUntil) {
            commands.removeAll()
            return
        }
        if (webView == nil) {
            webView = WKWebView ();
            webView!.navigationDelegate = self
            let url = URL (string: "https://radar.cedexis.com/0/0/radar.html");
            let request = URLRequest(url: url!);
            webView!.load(request);
        }
        if (radarLoaded) {
            commands.forEach({ (command) in
                webView!.evaluateJavaScript(command)
            })
            commands.removeAll()
        }
    }

    private func unload() {
        if (webView != nil) {
            webView!.navigationDelegate = nil
            webView = nil
            radarLoaded = false
        }
    }

    // When anything bad happens we shut down for one hour.
    // Typically, this would happen when not connected to the internet.
    private func hibernate() {
        unload()
        commands.removeAll()
        hibernateUntil = Date() + 60 * 60;
    }

    // Called when the navigation is complete.
    public func webView(_: WKWebView, didFinish: WKNavigation!) {
        radarLoaded = true
        process()
    }

    // Called when an error occurs during navigation.
    public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) {
        hibernate()
    }

    // Called when an error occurs while the web view is loading content.
    public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        hibernate()
    }

    // Called when the web view’s web content process is terminated.
    public func webViewWebContentProcessDidTerminate(_: WKWebView) {
        hibernate()
    }

}

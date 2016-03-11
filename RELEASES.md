# RELEASES

## 0.4.3

* Update Podspec.

## 0.4.2

* Fix project reference to RadarKit-Prefix.pch.

## 0.4.1

* Fix compiler warning.

## 0.4.0

* Refactored for simpler object ownership and reduced memory usage.

## 0.2.2

* Use radar protocol on reports

## 0.2.1

* Send network type headers on reports.

## 0.2.0

* Allow throughput measurements on WiFi only.
* Provide ability to stop a Radar session.
* Add basic unit tests.

## 0.1.2

* Add target to compile the library into a .framework file.
* Add HeaderDoc comments into the CDXRadar header.

## 0.1.1

* Prefix classes with CDX.
* Separate initialization from execution.
* Use asynchronous requests to execute without blocking the main thread.
* Make NSLog statements optional with the isVerbose property. Default to NO.
* Use nullability qualifiers to facilitate Swift usage.
* Use NSURLSession instead of NSURLConnection.
* Make library available on CocoaPods.
* Convention-related refactors.
* Bug fixes.

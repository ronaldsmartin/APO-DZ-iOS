![App Logo](https://raw.githubusercontent.com/ronaldsmartin/APO-DZ-iOS/master/APO-DZ/Images.xcassets/AppIcon.appiconset/Icon-Small@2x.png) APO-DZ for iOS
====================================

_This is the iPhone version's repo. You can find the [Android version's repository here](https://github.com/ronaldsmartin/APO-DZ-Android)._

The APO app was built as a native mobile interface so that brothers could quickly check their service hour progress, report/sign up for/create events on the public calendars, and (most helpfully, so we hear) easily find and contact other members of our chapter. The backend lives in the Google cloud; databases are in Google Sheets with modification via Google Forms, and multiple calendars are hosted on Google Calendar.

_Screenshots for this version (1.3.1 - currently in beta) [can be found here](https://github.com/ronaldsmartin/APO-DZ-iOS/tree/master/Screenshots/v1.3.1)._

**NOTE:** The remote repository for active development already lives in BitBucket. Periodically we will scrape stable builds  and open source them here.



## Download
This app is currently available for iPhones (iOS 7.0+) and Android devices (4.0+). You can download them from the respective app stores, but keep in mind that the app is password-locked to protect user privacy.

[![Get it on the App Store](https://linkmaker.itunes.apple.com/htmlResources/assets/en_us//images/web/linkmaker/badge_appstore-lrg.svg)](https://itunes.apple.com/us/app/apo-dz/id862246150?mt=8&uo=4)
[![Get it on Google Play](http://developer.android.com/images/brand/en_generic_rgb_wo_45.png)](https://play.google.com/store/apps/details?id=org.upennapo.app)


For more info on this version, check out [app webpage for the Android version](http://ronaldsmartin.github.io/APO-DZ-Android/).

## Running It
After downloading or forking, you'll need to:

1. add the [Facebook SDK for iOS](https://developers.facebook.com/docs/ios/) to your frameworks and finish setting it up.
2. make your own backend for the app
3. create a file URLs.m that implements the required Strings in URLs.h

The last two items are covered more in depth in the [Android repo's wiki](https://github.com/ronaldsmartin/APO-DZ-Android/wiki).

## Contact
For app-related queries, feel free to contact us at developer@upennapo.org.

## Dependencies and Credits
* [Facebook SDK](https://developers.facebook.com/docs/ios/)
* Tab Icons by Iconbeast - http://www.iconbeast.com/

A full list of contributors can be found on the [project site](http://ronaldsmartin.github.io/APO-DZ-Android/).

### Our Chapter
The Delta Zeta chapter is based at the University of Pennsylvania. Please visit us at [upennapo.org](upennapo.org) for more information.

CustomNavigation
================

Custom Height Navigation Bar with a Custom Navigation Controller


Some of the things you loose by using this custom navigation bar and controller:

* Many methods you may have come to expect from UINavigationController
* In Xcode 4.6 custom segues do not cause pushed views to inherit container size (this works in Xcode 5)
* Navbar in storyboard will always be the natural size, not the custom size
* Won't be able to see simulated navigation bar in view controller layout, you'll have to plan your layout based on you knowledge of how tall the navbar will be.
* Can't use toggle between 3.5/4.0 inch screens in storyboard to test autolayout
* No support for navigation prompts (will require some layout updating, may not be able to be made to work at all)
* Support for interface rotations (landscape / portrait)
* Automatic toolbar support
* Many delegate methods
* Automatic integration with tab controllers
* Automatic bottom bar hiding
* As is with standard bar items, the adjustment to vertical positioning causes some glitches in the navigation bar push/pop animations

Some iOS 7 problems:

* Work will have to be done to make it support the under the status bar style and translucency
* Automatic support for swipe back gesture
* Work will have to be done to make title and buttons properly positioned on iOS 7 (which will likely break iOS 6 support)
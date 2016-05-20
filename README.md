# iOS_MapExercise

What this is
------------
A simple iOS application which uses Parse, MapKit, and CoreLocation.  This is a project written in 
Objective-C.  Long press on the map to drop a pin. The pin's latitude and longitude of the pin is
fetched, then reverse geolocated to grab the closest address of that pin.  The latitude, longitude,
and address is then stored into an object model, which can be posted to the Parse API using the 
"Save Location" button.  Saved locations can then be viewed by opening the TableView using the 
"My Locations" button. This project implements MVC (Model View Controller) architecture.

Installing 
----------
- If you don't have CocoaPods, install it ($ sudo gem install cocoapods)
- Run pod install on project directory to install Parse CocoaPods.
- Open the .xcworkspace file with Xcode.  Enjoy

Work by 
----------
Josh O'Connor 2016

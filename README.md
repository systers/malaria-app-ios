# Malaria Prevention App Project

Malaria Prevention for iOS devices. This project is part of Peace Corps project to aid the Volunteer in sustaining life-saving malaria prevention tactics over their 2+ years of service using mobile devices. The central repository for discussion is [malaria-app-readme](https://github.com/PeaceCorps/malaria-app-readme)

The malaria-app-readme repository is intended to be the central repo for discussions, decision making, and feedback about the project goals and features so that the user experience across platforms is uniform.

Please keep all discussion regarding features that will be cross-platform on that repository, and code-specific discussion on this one.

## Application Description

Peace Corps is looking to build a mobile app that will aid the Volunteer in sustaining life-saving malaria prevention tactics over their 2+ years of service. Prevention is focused on sustained use of preventive medications, which are taken either daily or weekly, depending on the medicine. The application will feature a reminder system; an ability to indicate that medication was taken on time or missed; the ability for the volunteer to track their usage history; a trip indicator to help remind volunteers to pack certain supplies to prevent malaria if they leave their home village; and an Info Hub that will provide accurate information about Malaria and the medications they are taking. 

### Contact Information:

Patrick Choquette - Director of the Office of Innovation
pchoquette@peacecorps.gov

Matthew McAllister - Special Assistant in the Office of Innovation
mmcallister@peacecorps.gov

## Development

### Installation

1. Install CocoaPods:
```sh
sudo gem install cocoapods
```

2. Setup cocoapods environment:
```sh
pod setup
````

3. In same folder as Podfile:
```sh
pod install
```

4. Open malaria-ios.xcworkspace

### How to regenerate docs:

1. Install jazzy (https://github.com/Realm/jazzy):
```sh
sudo gem install jazzy
````

2. Generate documentation:
```sh
jazzy -c --skip-undocumented —-min-acl internal -m Malaria_Prevention_App
```

3. Open docs/index.html

### Troubleshooting:
If the build fails because pod modules are not identified:

1. In the project settings, find the target "Malaria Prevention App".
2. Under "Linked Frameworks and Libraries," add Pods/Pods.xcodeproj


### How to handle dependencies:

Dependencies must, as possible, be managed using CocoaPods. And use swift as preference.

Existing dependencies taken from Podfile: 

- 'Alamofire', '~> 3.1.4'
- 'SwiftyJSON', '~> 2.3.1'
- 'Charts', '~> 2.1.6'
- 'CVCalendar', '~> 1.2.8'
- 'SimpleCircleProgressView', '~> 1.0.3'
- 'HorizontalProgressView', '~> 0.9.5'
- 'PickerSwift', '~> 0.9.3'
- 'DoneToolbarSwift', '~> 1.0.0'
- 'GoogleMaps', '~> 1.11'
- 'Fabric', '~> 1.6.7'
- 'Crashlytics', '~> 3.7.1'
//
//  AppDelegate.h
//  invite
//
//  Created by Ajay CQL on 04/09/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *isFb;

@property(strong,nonatomic)CLLocationManager *locationManager;
@end


//
//  AppDelegate.m
//  invite
//
//  Created by Ajay CQL on 04/09/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@import GooglePlaces;
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [LocationManager sharedInstance];
    [GMSPlacesClient provideAPIKey:@"AIzaSyAjmQCXap3ojWcBk4N7pxwz1hHbJHSH1LA"];
   [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"ChatNotify" object:nil];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"deviceToken: %@", deviceToken);
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"DeviceToken"];
}
-(void)userNotificationCenter:(UNUserNotificationCenter* )center didReceiveNotificationResponse:(UNNotificationResponse* )response withCompletionHandler:(void(^)())completionHandler{
    
    NSDictionary *userDict = response.notification.request.content.userInfo;
    NSInteger notificationCode = [[userDict objectForKey:@"notification_code"]integerValue];
    
    if(notificationCode == 6){
        [self performSelector:@selector(loadviewforchat:)
                   withObject:[userDict objectForKey:@"body"] afterDelay:0.0];
    }
    else if (notificationCode == 5){
        [self performSelector:@selector(loadviewforgroupchat:)
                   withObject:[userDict objectForKey:@"body"] afterDelay:0.0];
    }
    
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification"  object:nil];
    }
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
}
#pragma mark
#pragma mark move to chat
-(void)loadviewforchat :(NSDictionary *)dict{
     if (GET_USER_ID) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveToChatVC" object:dict];
    }
}
-(void)loadviewforgroupchat :(NSDictionary *)dict{
    if (GET_USER_ID) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moveTogroupChatVC" object:dict];
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    
    if ([_isFb isEqualToString:@"True"]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:source
                                                           annotation:annotation];
    }
    else {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:source
                                          annotation:annotation];
    }    return NO;
}


//-(BOOL)application:(UIApplication *)application
//           openURL:(NSURL *)url
// sourceApplication:(NSString *)sourceApplication
//        annotation:(id)annotation {
//
//    if ([_isFb isEqualToString:@"True"]) {
//        return [[FBSDKApplicationDelegate sharedInstance] application:application
//                                                              openURL:url
//                                                    sourceApplication:sourceApplication
//                                                           annotation:annotation];
//    }
//    else {
//        return [[GIDSignIn sharedInstance] handleURL:url
//                                   sourceApplication:sourceApplication
//                                          annotation:annotation];
//    }
//}


@end

//
//  Macro.h
//  GuestBox
//
//  Created by AJ on 2/7/17.
//  Copyright © 2017 Team. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#import "MRProgress.h"
#import "CommonEnum.h"


#endif /* Macro_h */

#define SCREEN_SIZE             [[UIScreen mainScreen]bounds].size

//>>    APIs
#define appURL                  @"http://202.164.42.226/staging/invite/"
#define appNAME                 @"INvite"

#define INTERNET_ERROR          @"Network Connection Seems to be Disabled!"
#define IMAGE_URL         @"http://192.168.1.46/staging/groverapp/app/webroot/img/product/"
// >>>>>>>> Color Macros --- DefaultColorForAPP

#define RED     214.0f
#define GREEN   4.0f
#define BLUE    17.0f

#define UIColorFromRGBAlpha(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

// >>>>> Screen width and OS

#define _is_IPHONE4             ([[UIScreen mainScreen] bounds].size.height == 480.0)
#define _is_IPHONE5             ([[UIScreen mainScreen] bounds].size.height == 568.0)
#define _is_IPHONE6             ([[UIScreen mainScreen] bounds].size.height == 667.0)
#define _is_IPHONE6_Plus        ([[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_OS_8_OR_LATER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

//------ Progress Bar

#define SHOW_PROGRESS(v)    [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] title:v mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES]
#define HIDE_PROGRESS       [MRProgressOverlayView dismissAllOverlaysForView:[[UIApplication sharedApplication] keyWindow] animated:YES]


#define SHOW_PROGRESS_WITH_STATUS(v) [MRProgressOverlayView showOverlayAddedTo:[[UIApplication sharedApplication] keyWindow] title:v mode:MRProgressOverlayViewModeDeterminateHorizontalBar animated:YES];

#define SHOW_NETWORK_ERROR(Msg, ViewController) [TSMessage showNotificationInViewController:ViewController title:Msg subtitle:nil type:TSMessageNotificationTypeError];

//------ Activity Indicator
#define SHOW_ACTIVITE_INDICATOR [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
#define HIDE_ACTIVITE_INDICATOR [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

// --->>>>>>>> ShowAlert

#define ALERTVIEW(TITLE,MSG,VC)   [Util showalert:TITLE :MSG onView:VC];
#define SHOW_CUSTOM_ALERT(TITLE,MSG,VC) [[CustomVW sharedInstance] showCustomAlertWithTitle:TITLE MessageStr:MSG ViewCont:VC];

// >>>>>>>>>>> FontFamily

#define FONT_Bold(v)        [UIFont fontWithName:@"AvenirNext-Bold"       size:v]
#define FONT_Medium(v)      [UIFont fontWithName:@"AvenirNext-Medium"     size:v]
#define FONT_Light(v)       [UIFont fontWithName:@"AvenirNext-Regular"    size:v]
#define FONT_Semibold(v)    [UIFont fontWithName:@"AvenirNext-DemiBold"   size:v]

// >>>>>>>>>>> User id

#define GET_USER_ID [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"]
#define SET_USER_ID(userId) [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
#define GET_USER_TYPE [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserType"]
#define AUTH_TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"]
#define SET_AUTH_TOKEN(auth_token) [[NSUserDefaults standardUserDefaults] setObject:auth_token forKey:@"auth_token"];

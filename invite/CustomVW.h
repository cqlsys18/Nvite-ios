//
//  CustomVW.h
//  You Me FX
//
//  Created by Ajay CQL on 13/02/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomAlertDelegates

@optional
-(void)alertOkButtonClicked:(NSString *)response;

@end

@interface CustomVW : NSObject

@property (nonatomic,strong) id delegate;

-(void )showCustomAlertWithTitle :(NSString *)titleStr MessageStr:(NSString *)errorMsg ViewCont:(UIViewController *)cont;
+ (instancetype)sharedInstance;

@property (nonatomic, strong) UIView *Mainview ;
@end

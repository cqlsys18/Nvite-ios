//
//  CustomVW.m
//  You Me FX
//
//  Created by Ajay CQL on 13/02/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "CustomVW.h"

@implementation CustomVW
@synthesize delegate;

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(void )showCustomAlertWithTitle :(NSString *)titleStr MessageStr:(NSString *)errorMsg ViewCont:(UIViewController *)cont {
    
    
    _Mainview    =[[UIView alloc] init];
    _Mainview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    [cont.view addSubview:_Mainview];
    _Mainview.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint *_MainviewLeft = [NSLayoutConstraint
                                         constraintWithItem:_Mainview
                                         attribute:NSLayoutAttributeLeft
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:cont.view
                                         attribute:NSLayoutAttributeLeft
                                         multiplier:1.0
                                         constant:0];
    NSLayoutConstraint *_MainviewRight = [NSLayoutConstraint
                                          constraintWithItem:_Mainview
                                          attribute:NSLayoutAttributeRight
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:cont.view
                                          attribute:NSLayoutAttributeRight
                                          multiplier:1.0
                                          constant:0];
    NSLayoutConstraint *_MainviewTop = [NSLayoutConstraint
                                        constraintWithItem:_Mainview
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:cont.view
                                        attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                        constant:0];
    NSLayoutConstraint *_MainviewBottom = [NSLayoutConstraint
                                           constraintWithItem:_Mainview
                                           attribute:NSLayoutAttributeBottom
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:cont.view
                                           attribute:NSLayoutAttributeBottom
                                           multiplier:1.0
                                           constant:0];
    
    
    [cont.view addConstraint:_MainviewLeft];
    [cont.view addConstraint:_MainviewRight];
    [cont.view addConstraint:_MainviewTop];
    [cont.view addConstraint:_MainviewBottom];
    
    
    UIView *Subview   =[[UIView alloc]init];
    
    [_Mainview addSubview:Subview];
    Subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *SubviewX = [NSLayoutConstraint
                                    constraintWithItem:Subview
                                    attribute:NSLayoutAttributeCenterX
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:_Mainview
                                    attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0
                                    constant:0];
    NSLayoutConstraint *SubviewY = [NSLayoutConstraint
                                    constraintWithItem:Subview
                                    attribute:NSLayoutAttributeCenterY
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:_Mainview
                                    attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                    constant:0];
    NSLayoutConstraint *SubviewLeft = [NSLayoutConstraint
                                       constraintWithItem:Subview
                                       attribute:NSLayoutAttributeLeft
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:cont.view
                                       attribute:NSLayoutAttributeLeft
                                       multiplier:1.0
                                       constant:35];
    NSLayoutConstraint *_SubviewRight = [NSLayoutConstraint
                                         constraintWithItem:Subview
                                         attribute:NSLayoutAttributeRight
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:cont.view
                                         attribute:NSLayoutAttributeRight
                                         multiplier:1.0
                                         constant:-35];
    
    [_Mainview addConstraint:SubviewX];
    [_Mainview addConstraint:SubviewY];
    [cont.view addConstraint:SubviewLeft];
    [cont.view addConstraint:_SubviewRight];
    
    
    Subview.backgroundColor     = [UIColor whiteColor];
    Subview.layer.cornerRadius  = 15;
    Subview.clipsToBounds       = YES;
    
    UIButton *OkBTN  =[[UIButton alloc] init];
    
    [Subview addSubview:OkBTN];
    OkBTN.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint *OkBTNBotom = [NSLayoutConstraint
                                      constraintWithItem:OkBTN
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:Subview
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0
                                      constant:-20];
    
    
    [Subview addConstraint:OkBTNBotom];
    
    NSLayoutConstraint *OkBTNHeight = [NSLayoutConstraint
                                       constraintWithItem:OkBTN
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                       constant:40];
    [OkBTN addConstraint:OkBTNHeight];
    
    NSLayoutConstraint *OkBTwidth = [NSLayoutConstraint
                                     constraintWithItem:OkBTN
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0
                                     constant:160];
    [OkBTN addConstraint:OkBTwidth];
    
    
    NSLayoutConstraint *OkBTNY = [NSLayoutConstraint
                                  constraintWithItem:OkBTN
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:Subview
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0
                                  constant:0];
    [Subview addConstraint:OkBTNY];
    
    if (SCREEN_SIZE.height == 568) {
        
        OkBTN.titleLabel.font  = FONT_Semibold(15);
        
    }
    else if (SCREEN_SIZE.width == 375)
    {
        OkBTN.titleLabel.font  = FONT_Semibold(17);
    }
    else if (SCREEN_SIZE.width == 414){
        
        OkBTN.titleLabel.font  = FONT_Medium(19);
    }
    
    [OkBTN setTitle:@"OK" forState:UIControlStateNormal];
    [OkBTN addTarget:self action:@selector(CloseView) forControlEvents:UIControlEventTouchUpInside];
    OkBTN.layer.borderWidth = 1.0f;
    OkBTN.layer.borderColor = UIColorFromRGBAlpha(252, 115, 125, 1).CGColor;
    OkBTN.layer.cornerRadius    = 20;
    OkBTN.clipsToBounds         = true;
    
    [OkBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UILabel *ErrorTitle      = [[UILabel alloc] init];
    
    ErrorTitle.translatesAutoresizingMaskIntoConstraints = NO;
    ErrorTitle.text          = errorMsg;
    ErrorTitle.textColor     = [UIColor lightGrayColor];
    ErrorTitle.numberOfLines = 0;
    ErrorTitle.clipsToBounds = YES;
    ErrorTitle.textAlignment = NSTextAlignmentCenter;
    if (SCREEN_SIZE.height == 568) {
        // IPhone 5
        ErrorTitle.font      = FONT_Medium(13);
    }
    else if (SCREEN_SIZE.width == 375)
    {
        ErrorTitle.font      = FONT_Medium(15);
    }
    else if (SCREEN_SIZE.width == 414){
        ErrorTitle.font      = FONT_Medium(17);
    }
    
    [cont.view endEditing:YES];
    [Subview addSubview:ErrorTitle];
    
    NSLayoutConstraint *TitleLeft   = [NSLayoutConstraint
                                       constraintWithItem:ErrorTitle
                                       attribute:NSLayoutAttributeLeft
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:Subview
                                       attribute:NSLayoutAttributeLeft
                                       multiplier:1.0
                                       constant:30];
    NSLayoutConstraint *TitleRight  = [NSLayoutConstraint
                                       constraintWithItem:ErrorTitle
                                       attribute:NSLayoutAttributeRight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:Subview
                                       attribute:NSLayoutAttributeRight
                                       multiplier:1.0
                                       constant:-30];
    NSLayoutConstraint *TitleTop    = [NSLayoutConstraint
                                       constraintWithItem:ErrorTitle
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:Subview
                                       attribute:NSLayoutAttributeTop
                                       multiplier:1.0
                                       constant:80];
    NSLayoutConstraint *TitleBottom = [NSLayoutConstraint
                                       constraintWithItem:OkBTN
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:ErrorTitle
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                       constant:30];
    
    [Subview addConstraint:TitleLeft];
    [Subview addConstraint:TitleRight];
    [Subview addConstraint:TitleTop];
    [Subview addConstraint:TitleBottom];
    
    
    
    UILabel *titleLB      = [[UILabel alloc] init];
    
    titleLB.translatesAutoresizingMaskIntoConstraints = NO;
    titleLB.text          = titleStr;
    titleLB.numberOfLines = 1;
    titleLB.clipsToBounds = YES;
    titleLB.textAlignment = NSTextAlignmentCenter;
    if (SCREEN_SIZE.height == 568) {
        // IPhone 5
        titleLB.font      = FONT_Semibold(23);
    }
    else if (SCREEN_SIZE.width == 375)
    {
        titleLB.font      = FONT_Semibold(25);
    }
    else if (SCREEN_SIZE.width == 414){
        titleLB.font      = FONT_Semibold(27);
    }
    
    [cont.view endEditing:YES];
    [Subview addSubview:titleLB];
    
    NSLayoutConstraint *TitleLefttitleLB = [NSLayoutConstraint
                                            constraintWithItem:titleLB
                                            attribute:NSLayoutAttributeLeft
                                            relatedBy:NSLayoutRelationEqual
                                            toItem:Subview
                                            attribute:NSLayoutAttributeLeft
                                            multiplier:1.0
                                            constant:30];
    NSLayoutConstraint *TitleRighttitleLB = [NSLayoutConstraint
                                             constraintWithItem:titleLB
                                             attribute:NSLayoutAttributeRight
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:Subview
                                             attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                             constant:-30];
    NSLayoutConstraint *TitleToptitleLB = [NSLayoutConstraint
                                           constraintWithItem:titleLB
                                           attribute:NSLayoutAttributeTop
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:Subview
                                           attribute:NSLayoutAttributeTop
                                           multiplier:1.0
                                           constant:20];
    
    NSLayoutConstraint *TitleTopHeight = [NSLayoutConstraint
                                          constraintWithItem:titleLB
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                          multiplier:1.0
                                          constant:40];
    
    [titleLB addConstraint:TitleTopHeight];
    [Subview addConstraint:TitleLefttitleLB];
    [Subview addConstraint:TitleRighttitleLB];
    [Subview addConstraint:TitleToptitleLB];
    
}


#pragma mark
#pragma mark Close Custom View
-(void)CloseView {
    
    if([delegate respondsToSelector:@selector(alertOkButtonClicked:)])
        [delegate alertOkButtonClicked:@"Clicked"];
    
    [_Mainview removeFromSuperview];
    
}


@end

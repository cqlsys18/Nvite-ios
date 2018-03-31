//
//  ForgotOTPVC.h
//  invite
//
//  Created by AJ on 9/22/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotOTPVC : UIViewController
{
    IBOutlet UITextField *thirdTF;
    
    IBOutlet UILabel *timerLB;
    IBOutlet UITextField *fourthTF;
    IBOutlet UITextField *secondTF;
    IBOutlet UITextField *firstTF;
    IBOutlet UILabel *phoneNoLB;
    long totalSeconds;
    NSTimer *twoMinTimer;
    
    
}

@property (strong, nonatomic) NSString *emailStr;
@end

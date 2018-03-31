//
//  OtpVC.m
//  invite
//
//  Created by Ajay kumar on 9/20/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "OtpVC.h"

@interface OtpVC ()
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
@end

@implementation OtpVC
//Enter the 4-digit code sent to you at 0987654321
- (void)viewDidLoad {
    [super viewDidLoad];
  
    phoneNoLB.text = [NSString stringWithFormat:@"Enter the 4-digit code sent to you at  %@%@",_Countrycode,_phoneNo];
        totalSeconds = 60;
        twoMinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(timer)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    
    - (void)timer {
        totalSeconds--;
        timerLB.text = [self timeFormatted:totalSeconds];//[self timeFormatted:totalSeconds];
        if ( totalSeconds == 0 ) {
            [twoMinTimer invalidate];
        } 
    }
- (NSString *)timeFormatted:(long)newTotalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    
    return [NSString stringWithFormat:@"%i:%02d", minutes, seconds];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger newLength = newString.length;
    
    
    if (textField == firstTF) {
        if (newLength == 1) {
            [firstTF setText:newString];
            [secondTF becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == secondTF) {
        if (newLength == 1) {
            [secondTF setText:newString];
            [thirdTF becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == thirdTF) {
        if (newLength == 1) {
            [thirdTF setText:newString];
            [fourthTF becomeFirstResponder];
            return NO;
        }
    }
    else if (textField == fourthTF){
        if ([firstTF.text isEqualToString:@""] || [secondTF.text isEqualToString:@""] || [thirdTF.text isEqualToString:@""])
        {
            [firstTF becomeFirstResponder];
            return  NO;
            
        }
        else {
            [fourthTF setText:newString];
            
            [self.view endEditing:YES];
            
            
        }
    }
    return YES;
}

#pragma mark- button action
- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (IBAction)resendBtnAction:(id)sender {

    [twoMinTimer invalidate];
    totalSeconds = 60;
    twoMinTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(timer)
                                                 userInfo:nil
                                                  repeats:YES];
     [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
         {
             
             if (responseObject == false)
             {
                 SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
             }
             else
             {
                 SHOW_PROGRESS(@"");
                
                 NSMutableDictionary *otpDict = [[NSMutableDictionary alloc] init];
                 [otpDict setObject:_phoneNo        forKey:@"phone_no"];
                 [otpDict setObject:_Countrycode    forKey:@"phone_code"];
                 
                 NSString *otpUrl=[NSString stringWithFormat:@"%@%@",appURL,@"resent_otp"];
                 
                 [[ApiManager sharedInstance] POST:otpUrl parameterDict:otpDict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                     
                     HIDE_PROGRESS;
                     if (success == false)
                     {
                         SHOW_NETWORK_ERROR(message, self);
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary])
                         {
                             
                         }
                         else
                         {
                             if ([[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"code"]]isEqualToString:@"403"]) {
                                 
                                 
                             }
                         }
                     }
                 }];
             }
             
         }];
//
    
    }
    


- (IBAction)submitBtnaction:(id)sender {
    if ([firstTF.text isEqualToString:@""]||[secondTF.text isEqualToString:@""]||[thirdTF.text isEqualToString:@""]||[fourthTF.text isEqualToString:@""]) {
        SHOW_NETWORK_ERROR(@"Please Enter Correct OTP", self);
        return;
    }
    else{
        [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
         {
             
             if (responseObject == false)
             {
                 SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
             }
             else
             {
                 SHOW_PROGRESS(@"");
                 NSString *otp = [NSString stringWithFormat:@"%@%@%@%@",firstTF.text,secondTF.text,thirdTF.text,fourthTF.text];
                 NSMutableDictionary *otpDict = [[NSMutableDictionary alloc] init];
                 [otpDict setObject:AUTH_TOKEN   forKey:@"auth_token"];
                 [otpDict setObject:otp   forKey:@"otp"];
                 [otpDict setObject:@"1"  forKey:@"type"];
                 
                 NSString *otpUrl=[NSString stringWithFormat:@"%@%@",appURL,@"verify_otp"];
                 
                 [[ApiManager sharedInstance] POST:otpUrl parameterDict:otpDict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                  
                     HIDE_PROGRESS;
                     if (success == false)
                     {
                         SHOW_NETWORK_ERROR(message, self);
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary])
                         {
                             [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"] objectForKey:@"User"] forKey:@"userInfo"];
                             
                             SET_USER_ID([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"id"])
                             SET_AUTH_TOKEN([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"auth_token"])
                             
                             UIViewController *Tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarVC"];
                             self.view.window.rootViewController=Tabbar;
                             
                         }
                         else
                         {
                             if ([[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"code"]]isEqualToString:@"403"]) {
                                 
                                 
                             }
                         }
                     }
                 }];
             }
             
         }];
        
        
    }

}

#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

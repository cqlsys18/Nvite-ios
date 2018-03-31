//
//  ForgotOTPVC.m
//  invite
//
//  Created by AJ on 9/22/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "ForgotOTPVC.h"
#import "ChangePassVC.h"

@interface ForgotOTPVC ()

@end

@implementation ForgotOTPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}



#pragma mark -

- (IBAction)backBTnAction:(id)sender {

    [self.navigationController popViewControllerAnimated:true];
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

#pragma mark -


- (IBAction)submitBtnAction:(id)sender {
    
    
    NSString *otp = [NSString stringWithFormat:@"%@%@%@%@",firstTF.text,secondTF.text,thirdTF.text,fourthTF.text];
    
    if (otp.length < 4) {
        SHOW_NETWORK_ERROR(@"Enter OTP!", self);
    }
    else {
        NSString *url = [NSString stringWithFormat:@"%@%@",appURL, @"verify_otp"];
        
        NSDictionary *dict = @{
                               @"email":_emailStr,
                               @"type" : @"0",
                               @"otp"  :otp
                               };
        
        [[ApiManager sharedInstance] POST:url parameterDict:dict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary){
            
            HIDE_PROGRESS;
            if (success == false) {
                SHOW_NETWORK_ERROR(message, self);
                
            }
            else
            {
                if ([Util checkIfSuccessResponse:dictionary]) {
                    
                    SET_AUTH_TOKEN([[dictionary objectForKey:@"body"] objectForKey:@"auth_token"])
                    ChangePassVC *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePassVC"];
                    view.emailStr      = _emailStr;
                    [self.navigationController pushViewController:view animated:YES];
                }
            }
            
        }];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

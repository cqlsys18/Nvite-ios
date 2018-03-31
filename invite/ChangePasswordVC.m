//
//  ChangePasswordVC.m
//  AddChats
//
//  Created by Ajay kumar on 9/7/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "ChangePasswordVC.h"

@interface ChangePasswordVC ()
{
    
    IBOutlet UITextField *repeatPasswordTF;
    IBOutlet UITextField *newPasswordTF;
    IBOutlet UITextField *passwordTf;
}
@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)saveBtn:(id)sender {
    if (![Util validatePasswordString:passwordTf.text]) {
        SHOW_NETWORK_ERROR(@"Password must contains one Special Character , one Alphanumeric character, One Capital Charater", self);
    }
    else if (![Util validatePasswordString:newPasswordTF.text]) {
        SHOW_NETWORK_ERROR(@"Password must contains one Special Character , one Alphanumeric character, One Capital Charater", self);
    }
    else if (![newPasswordTF.text isEqualToString:repeatPasswordTF.text]) {
        SHOW_NETWORK_ERROR(@"Password and Confirm Password should be same!", self);
    }
    else {
        NSString *url = [NSString stringWithFormat:@"%@%@",appURL, @"change_password"];
        
        NSDictionary *dict = @{
                              @"password" :newPasswordTF.text,
                               @"type"  :@"1",
                               @"auth_token":AUTH_TOKEN,
                               @"old_password":passwordTf.text
                               };
        
        [[ApiManager sharedInstance] POST:url parameterDict:dict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary){
            
            HIDE_PROGRESS;
            if (success == false) {
                SHOW_NETWORK_ERROR(@"Error Updating Password. TryAgain!!", self);
                
            }
            else
            {
                if ([Util checkIfSuccessResponse:dictionary]) {
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:appNAME
                                                          message:@"Password Updated!! Please Login to Continue.."
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   [self presentViewController:alertController animated:YES completion:nil];
                                                   [self performSelector:@selector(navigateToRoot) withObject:nil afterDelay:1.0];
                                               }];
                    
                    [alertController addAction:okAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
            
        }];
    }
    
}

- (void)navigateToRoot {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

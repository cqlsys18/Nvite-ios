//
//  ChangePassVC.m
//  invite
//
//  Created by AJ on 9/22/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "ChangePassVC.h"

@interface ChangePassVC ()

@end

@implementation ChangePassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated{
     self.tabBarController.tabBar.hidden = true;
}

- (IBAction)submitBtnActiob:(id)sender {
    
    if (![Util validatePasswordString:passwordTF.text]) {
        SHOW_NETWORK_ERROR(@"Password must contains one Special Character , one Alphanumeric character, One Capital Charater", self);
    }
    else if (![Util validatePasswordString:confirmPasswordTF.text]) {
        SHOW_NETWORK_ERROR(@"Password must contains one Special Character , one Alphanumeric character, One Capital Charater", self);
    }
    else if (![passwordTF.text isEqualToString:confirmPasswordTF.text]) {
        SHOW_NETWORK_ERROR(@"Password and Confirm Password should be same!", self);
    }
    else {
        NSString *url = [NSString stringWithFormat:@"%@%@",appURL, @"change_password"];
        
        NSDictionary *dict = @{
                               @"email":_emailStr,
                               @"password" :passwordTF.text,
                               @"type"  :@"0"
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
                                                   UIViewController *signin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
                                                   [self dismissViewControllerAnimated:signin completion:nil];
                                               }];
                    
                    [alertController addAction:okAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
            
        }];
    }
    
}



- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

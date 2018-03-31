//
//  CreateUsernameVC.m
//  invite
//
//  Created by AJ on 9/26/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "CreateUsernameVC.h"
#import "PhoneVC.h"

@interface CreateUsernameVC ()

@end

@implementation CreateUsernameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]);
    NSLog(@"%@", AUTH_TOKEN);
}
#pragma mark - 

- (IBAction)submitBtn_Action:(id)sender {
    
    if ([usernameTF.text isEqualToString:@""]) {
        SHOW_NETWORK_ERROR(@"Enter a Unique Username", self);
    }
    else {
        NSString *url = [NSString stringWithFormat:@"%@%@",appURL, @"check_username"];
        
        NSDictionary *dict = @{
                               @"auth_token": AUTH_TOKEN,
                               @"username":usernameTF.text
                               };
        
        [[ApiManager sharedInstance] POST:url parameterDict:dict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary){
            
            HIDE_PROGRESS;
            if (success == false) {
                SHOW_NETWORK_ERROR(@"Error Updating Password. TryAgain!!", self);
                
            }
            else
            {
                if ([Util checkIfSuccessResponse:dictionary]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"] objectForKey:@"User"] forKey:@"userInfo"];
                    
                    SET_USER_ID([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"id"])
                    SET_AUTH_TOKEN([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"auth_token"])
                    
                    UIAlertController *alertController = [UIAlertController
                                                          alertControllerWithTitle:appNAME
                                                          message:@"Username Added Successfully!!"
                                                          preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:@"OK"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   
                                                   PhoneVC *phoneVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneVC"];
                                                   phoneVc.title = @"SocialLogin";
                                                   [self presentViewController:phoneVc animated:YES completion:nil];
                                               }];
                    
                    [alertController addAction:okAction];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
            
        }];
    }
}

- (IBAction)backBtn_action:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}


#pragma mark -TEXTFIELD

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {

    NSString *emailRegex =
    @"abcdefghijklmnopqrstuvwxyz._-";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:string];
    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet];
//    
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    
//    return ![string isEqualToString:filtered];
}*/


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
        NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890._-"];
        s = [s invertedSet];
        NSRange r = [string rangeOfCharacterFromSet:s];
        if (r.location != NSNotFound) {
            //NSLog(@"the string contains illegal characters");
            return NO;
        }
        //        if ([string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        //            return NO;
        //        }
  
    
    return YES;
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

//
//  LoginVC.m
//  invite
//
//  Created by Ajay CQL on 04/09/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "LoginVC.h"
#import "PhoneVC.h"
#import "OtpVC.h"
#import "ForgotOTPVC.h"
#import "CreateUsernameVC.h"

@interface LoginVC (){
    
    IBOutlet UIView *innerV;
    IBOutlet UITextField *usernameTXT;
    IBOutlet NSLayoutConstraint *heightConst;
    IBOutlet UIView *outerV;
    IBOutlet UITextField *forgotEmailTF;
    IBOutlet UITextField *passwordTXT;
    
}

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    heightConst.constant = 100;
    innerV.clipsToBounds = YES;
    innerV.layer.cornerRadius = 3;
}

#pragma mark - SignInAction

- (IBAction)signInAction:(id)sender {
    
    if ([usernameTXT.text isEqualToString:@""]) {
        SHOW_NETWORK_ERROR(@"Enter username!", self);
        return;
    }
    else if ([passwordTXT.text isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Enter password!", self);
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
                 
                 NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                 if (token == nil || [token isEqualToString:@""])
                 {
                     token = @"123456789";
                 }
                 NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
                 [loginDict setObject:usernameTXT.text   forKey:@"username"];
                 [loginDict setObject:passwordTXT.text   forKey:@"password"];
                 [loginDict setObject:token              forKey:@"device_token"];
                 [loginDict setObject:@"1"               forKey:@"device_type"];
                 NSString *Loginurl=[NSString stringWithFormat:@"%@%@",appURL,@"login"];
                 
                 [[ApiManager  sharedInstance] POST:Loginurl parameterDict:loginDict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                     HIDE_PROGRESS;
                     if (success == false)
                     {
                         SHOW_NETWORK_ERROR(message, self);
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary])
                         {
                             
                             SET_USER_ID([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"id"])
                             SET_AUTH_TOKEN([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"auth_token"])
                             
                             if ([[[[dictionary objectForKey:@"body"] objectForKey:@"User"]objectForKey:@"phone_verfiy" ]integerValue] == 0) {
                                 UIViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
                                 self.view.window.rootViewController=view;
                             }
                             else{
                                 [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"] objectForKey:@"User"] forKey:@"userInfo"];
                                 
                                 
                                 
                                 UIViewController *Tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarVC"];
                                 self.view.window.rootViewController=Tabbar;
 
                             }
                             
                             
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

#pragma mark
#pragma mark FB login
- (IBAction)fbLogin:(id)sender {
    
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appD.isFb = @"True";
    
    
    FBSDKLoginManager *login    = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions: @[@"public_profile",@"email",@"user_friends"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                }
                                else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                }
                                else {
                                    if ([result.grantedPermissions containsObject:@"email"])
                                    {
                                        [self fetchUserInfo];
                                    }
                                }
                            }];
    
}


#pragma mark
#pragma mark google login
- (IBAction)googleLogin:(id)sender {
    
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appD.isFb = @"False";
    
    GIDSignIn* signIn   = [GIDSignIn sharedInstance];
    signIn.delegate     = self;
    signIn.uiDelegate   = self;
    [signIn signIn];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    if (!error) {
        
        // Perform any operations on signed in user here.
        NSString *socialID = user.userID;                  // For client-side use only!
        //NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        // NSString *givenName = user.profile.givenName;
        //NSString *familyName = user.profile.familyName;
        NSString *email  = user.profile.email;
        NSURL *imageURL = [user.profile imageURLWithDimension:200];
        
        NSString *imgurl = imageURL.absoluteString;
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        if (token == nil || [token isEqualToString:@""])
        {
            token = @"123456789";
        }
        
        
        NSString *url = [NSString stringWithFormat:@"%@%@",appURL, @"social_login"];
        
        NSDictionary *dict = @{
                               @"social_id"        :socialID,
                               
                               @"username"         :fullName,
                               @"email"            :email,
                               @"device_token"     :token,
                               @"device_type"      :@"1",
                               @"social_type"      :@"3",
                               @"social_image"     :imgurl,
                               
                               };
        
        
        [[ApiManager sharedInstance] POST:url parameterDict:dict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary){
            
            HIDE_PROGRESS;
            if (success == false) {
                SHOW_NETWORK_ERROR(@"Login Unsucessful!", self);
                
            }
            else
            {
                if ([Util checkIfSuccessResponse:dictionary]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"] objectForKey:@"User"] forKey:@"userInfo"];
                    
                    SET_USER_ID([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"id"])
                    SET_AUTH_TOKEN([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"auth_token"])
                    
                    if ([[NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"body"]objectForKey:@"User"] objectForKey:@"newstatus"]] isEqualToString:@"3"]) {
                        
                        PhoneVC *phoneVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneVC"];
                        phoneVc.title = @"SocialLogin";
                        [self presentViewController:phoneVc animated:YES completion:nil];
                        
                    }
                    else if ([[NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"body"]objectForKey:@"User"] objectForKey:@"newstatus"]] isEqualToString:@"2"]) {
                        
                        CreateUsernameVC *phoneVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateUsernameVC"];
                        phoneVc.title = @"SocialLogin";
                        [self.navigationController pushViewController:phoneVc animated:YES];
                        
                    }
                    else {
                        UIViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarVC"];
                        [self.view.window setRootViewController:view];
                    }
                }
                else
                {
                    
                    if ([[[dictionary objectForKey:@"status"] objectForKey:@"message"] isEqualToString:@"Authentication Token does not match"]) {
                        UIAlertController *alertController = [UIAlertController
                                                              alertControllerWithTitle:@""
                                                              message:[[dictionary objectForKey:@"status"] objectForKey:@"message"]
                                                              preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okAction = [UIAlertAction
                                                   actionWithTitle:@"OK"
                                                   style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                                                   {
                                                       SET_USER_ID(nil);
                                                       UIViewController *view  = [self.storyboard instantiateViewControllerWithIdentifier:@"VerifyVC"];
                                                       self.view.window.rootViewController    = view;
                                                       
                                                   }];
                        
                        [alertController addAction:okAction];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                }
            }
            
            
        }];
        
        
    }
    
    else {
        
        NSLog(@"Error !! ");
    }
    
    
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}


#pragma mark - FBLoginResult

-(void)fetchUserInfo
{
    SHOW_PROGRESS(@"Please Wait..");
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 
                 NSString *socialID = [result objectForKey:@"id"] ;
                 NSString *name = @"";//[NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                 NSString *email = [result objectForKey:@"email"];
                 NSString *Imgurl       = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                 NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
                 if (token == nil || [token isEqualToString:@""])
                 {
                     token = @"123456789";
                 }
                 NSString *url = [NSString stringWithFormat:@"%@%@",appURL, @"social_login"];
                 
                 NSDictionary *dict = @{
                                        @"social_id"        :socialID,
                                        @"username"         :name,
                                        @"email"            :email,
                                        @"device_token"     :token,
                                        @"device_type"      :@"1",
                                        @"social_type"      :@"1",
                                        @"social_image"     :Imgurl,
                                        };
                 
                 [[ApiManager sharedInstance] POST:url parameterDict:dict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary){
                     
                     HIDE_PROGRESS;
                     if (success == false) {
                         SHOW_NETWORK_ERROR(message, self);
                         
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary]) {
                             
                             [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"] objectForKey:@"User"] forKey:@"userInfo"];
                             
                             SET_USER_ID([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"id"])
                             SET_AUTH_TOKEN([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"auth_token"])
                             
                             if ([[NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"body"]objectForKey:@"User"] objectForKey:@"newstatus"]] isEqualToString:@"3"]) {
                                 
                                 PhoneVC *phoneVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneVC"];
                                 phoneVc.title = @"SocialLogin";
                                 [self presentViewController:phoneVc animated:YES completion:nil];
                                 
                             }
                             else if ([[NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"body"]objectForKey:@"User"] objectForKey:@"newstatus"]] isEqualToString:@"2"]) {
                                 
                                 CreateUsernameVC *phoneVc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateUsernameVC"];
                                 phoneVc.title = @"SocialLogin";
                                 [self.navigationController pushViewController:phoneVc animated:YES];
                                 
                             }
                             else {
                                 UIViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarVC"];
                                 [self.view.window setRootViewController:view];
                             }
                         }
                         else
                         {
                             SHOW_NETWORK_ERROR([[dictionary objectForKey:@"status"] objectForKey:@"message"],self);
                             
                             
                         }
                     }
                 }];
             }
             else
             {
                 NSLog(@"Error %@",error);
             }
         }];
        
    }
    
}
#pragma mark-
- (IBAction)signUpAction:(id)sender {
    UIViewController *signUpView = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpVC"];
    [self presentViewController:signUpView animated:YES completion:nil];
    
}
- (IBAction)forgotPswdAction:(id)sender {
    
    outerV.hidden = NO;
}


- (IBAction)sendBtnaction:(id)sender {
 
    if (![Util ValidateEmailString:forgotEmailTF.text]) {
        SHOW_NETWORK_ERROR(@"Enter Valid EmailID", self);
    }
    else {
        SHOW_PROGRESS(@"");
        NSString *url = [NSString stringWithFormat:@"%@%@",appURL, @"forgot_password"];
        
        NSDictionary *dict = @{
                               @"email"            :forgotEmailTF.text
                               
                               };
        
        [[ApiManager sharedInstance] POST:url parameterDict:dict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary){
            
            HIDE_PROGRESS;
            if (success == false) {
                SHOW_NETWORK_ERROR(@"Email Not Exists!", self);
                
            }
            else
            {
                if ([Util checkIfSuccessResponse:dictionary]) {
                    
                    SET_AUTH_TOKEN([[dictionary objectForKey:@"body"] objectForKey:@"auth_token"]);
                    ForgotOTPVC *otpVc  = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotOTPVC"];
                    otpVc.emailStr      = forgotEmailTF.text;
                    [self.navigationController pushViewController:otpVc animated:YES];
                }
            }
            
        }];
    }
}

- (IBAction)backBtn:(id)sender {
    outerV.hidden = YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if (textField == usernameTXT) {
        NSRange upperCharRange;
        upperCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
        
        if (upperCharRange.location != NSNotFound) {
            
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:[string lowercaseString]];
            return NO;
        }
    }
    return YES;
}
#pragma mark-
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

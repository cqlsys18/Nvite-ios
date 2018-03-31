//
//  EditProfileVC.m
//  invite
//
//  Created by AJ on 10/11/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "EditProfileVC.h"

@interface EditProfileVC ()
{
    IBOutlet UITextField *emailTF;
    
   
    IBOutlet UITextField *dobTF;
    IBOutlet UIButton *profileBtn;
    NSData *ProfileImageData;
    NSArray *genderArray;
     UIPickerView *genderPicker;
    NSString*gender;
   IBOutlet UIImageView *userImageV;
}
@end

@implementation EditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self addDatePicker:dobTF];
    
    NSDictionary *userDetailsDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    emailTF.text    = [userDetailsDict objectForKey:@"email"];
    
    
    
    NSString * timeStampString  = [userDetailsDict objectForKey:@"birthday"];
    
    NSTimeInterval _interval    = [timeStampString doubleValue];
    NSDate *date                = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd/MM/YYYY"];
    dobTF.text            = [_formatter stringFromDate:date];

    
    [userImageV setImageWithURL:[NSURL URLWithString:[userDetailsDict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@""]];
    ProfileImageData = UIImageJPEGRepresentation(userImageV.image, 0.5);

    //heightConst.constant = 120;
}



#pragma mark
#pragma mark Add date picker
-(void)addDatePicker:(UITextField *)field{
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.tag = [field tag];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate    = [NSDate date];
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [field setInputView:datePicker];
    
    
}

#pragma mark
#pragma mark Show date and time value
-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)dobTF.inputView;
    
    
    // [picker setMinimumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    
    
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    dobTF.text = [NSString stringWithFormat:@"%@",dateString];
    
    
}

-(void)viewDidLayoutSubviews{
    profileBtn.layer.cornerRadius = profileBtn.frame.size.width/2;
    profileBtn.clipsToBounds      = YES;
    userImageV.layer.cornerRadius = userImageV.frame.size.width/2;
    userImageV.clipsToBounds = YES;
}

#pragma mark  - button action
- (IBAction)saveBtn:(id)sender {
     if ([emailTF.text isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Enter Email!", self);
        return;
    }else if (![Util ValidateEmailString:emailTF.text]){
        SHOW_NETWORK_ERROR(@"Enter proper email format", self);
        return;
    }else if ([dobTF.text isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Enter DOB", self);
        return;
    }
        else
        {      [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
                {
                    
                    if (responseObject == false)
                    {
                        SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
                    }
                    else
                    {
                        SHOW_PROGRESS(@"");
                        
                        
        
        NSString * dateString   = [NSString stringWithFormat:@"%@",dobTF.text];
        NSDateFormatter * df    = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"dd/MM/YYYY"];
        
        NSDate *date = [df dateFromString:dateString];
        
        NSDateFormatter* df2    = [[NSDateFormatter alloc]init];
        [df2 setDateFormat:@"dd/MM/YYYY"];
        NSString *scheduledate  = [df2 stringFromDate:date];
        
        NSMutableDictionary *editProfileDict     = [[NSMutableDictionary alloc] init];
       
        [editProfileDict setObject:emailTF.text    forKey:@"email"];
        [editProfileDict setObject: [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]]      forKey:@"birthday"];
        [editProfileDict setObject:AUTH_TOKEN forKey:@"auth_token"];
     
        NSMutableDictionary *imageDict = [[NSMutableDictionary alloc] init];
        
        if (ProfileImageData!= nil) {
            [imageDict setObject:ProfileImageData forKey:@"image"];
        }
        
  
            NSString *signupurl=[NSString stringWithFormat:@"%@%@",appURL,@"update_profile"];
            [[ApiManager sharedInstance] apiCallWithImage:signupurl parameterDict:editProfileDict imageDataDictionary:imageDict  CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                     
                     HIDE_PROGRESS;
                     if (success == false)
                     {
                         SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary])
                         {
                             
                            [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"body"] forKey:@"userInfo"];
                             

                             [CustomVW sharedInstance].delegate  = self;
                             
                             SHOW_CUSTOM_ALERT(appNAME,@"Update Profile successfully", self);
                             
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

#pragma mark - CustomAlertDelegates

-(void)alertOkButtonClicked:(NSString *)response {
    self.tabBarController.tabBar.hidden = false;
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)cameraBtn:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:appNAME
                                                                   message:@"Upload Photo!"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take Photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  imagePickerController.delegate = self;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing Photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.delegate = self;
                                  imagePickerController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark
#pragma mark imagepickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [profileBtn setImage:chosenImage forState:UIControlStateNormal];
    ProfileImageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backbtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated: YES];
}


#pragma mark  -
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

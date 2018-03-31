//
//  SignUpVC.m
//  invite
//
//  Created by Ajay CQL on 04/09/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "SignUpVC.h"
#import "PhoneVC.h"
@interface SignUpVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    IBOutlet UIButton *profileBTN;
    NSData            *ProfileImageData;
    IBOutlet UITextField *userNameTXT;
    IBOutlet UITextField *emailTXT;
    IBOutlet NSLayoutConstraint *heightConst;
    IBOutlet UITextField *cPasswordTXT;
    IBOutlet UITextField *passwordTXT;
    IBOutlet UITextField *genderTXT;
    IBOutlet UITextField *dobTXT;
    UIPickerView *genderPicker;
    NSArray      *genderArray;
    IBOutlet UIImageView *userImageV;
    NSString*gender;
    NSString * ageStr;
    
    IBOutlet UIButton *googleBtn;
    IBOutlet NSLayoutConstraint *ViewHeight;
    
}

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ageStr = @"";
    genderArray = [NSArray arrayWithObjects:@"Male",@"Female", nil];
    age = @"";
    genderPicker            = [[UIPickerView alloc] init];
    genderTXT.inputView     = genderPicker;
    genderPicker.delegate   = self;
    [self addDatePicker:dobTXT];
    
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
    UIDatePicker *picker = (UIDatePicker*)dobTXT.inputView;
    
    
    // [picker setMinimumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    
    
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    dobTXT.text = [NSString stringWithFormat:@"%@",dateString];
    
    
}

-(void)viewDidLayoutSubviews{
    ViewHeight.constant = googleBtn.frame.origin.y+googleBtn.frame.size.height+0;
    profileBTN.layer.cornerRadius = profileBTN.frame.size.width/2;
    profileBTN.clipsToBounds      = YES;
    userImageV.layer.cornerRadius = userImageV.frame.size.width/2;
    userImageV.clipsToBounds = YES;
}

#pragma mark
#pragma mark Upload profile pic action

- (IBAction)profileAction:(id)sender {
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
    [profileBTN setImage:chosenImage forState:UIControlStateNormal];
    ProfileImageData = UIImageJPEGRepresentation(chosenImage, 0.5);
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signUpAction:(id)sender {
    [self validateAge];
    if ([age isEqualToString:@"NO"] || [age isEqualToString:@""]) {
        SHOW_NETWORK_ERROR(@"You must be at least 13 years old to register!", self);
        return;
    } else if ([userNameTXT.text isEqualToString:@""]) {
        SHOW_NETWORK_ERROR(@"Enter Username!", self);
        return;
   }else if ([emailTXT.text isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Enter Email!", self);
        return;
    }else if (![Util ValidateEmailString:emailTXT.text]){
        SHOW_NETWORK_ERROR(@"Enter proper email format", self);
        return;
    }else if ([dobTXT.text isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Enter Gender", self);
        return;
    }else if ([passwordTXT.text isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Enter Password!", self);
        return;
    }
    else if (![Util validatePasswordString:passwordTXT.text]) {
        SHOW_NETWORK_ERROR(@"Password must contain a minimum of eight letters, one upppercase letter, one lowercase letter, one number, and one special character", self);
    }
    else
    {
    
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        if (token == nil || [token isEqualToString:@""])
        {
            token = @"123456789";
        }
       
        NSString * dateString   = [NSString stringWithFormat:@"%@",dobTXT.text];
        NSDateFormatter * df    = [[NSDateFormatter alloc] init];
       
        [df setDateFormat:@"dd/MM/YYYY"];
        
        NSDate *date = [df dateFromString:dateString];
        
        NSDateFormatter* df2    = [[NSDateFormatter alloc]init];
        [df2 setDateFormat:@"dd/MM/YYYY"];
        NSString *scheduledate  = [df2 stringFromDate:date];
      
        NSMutableDictionary *signupdict     = [[NSMutableDictionary alloc] init];
        [signupdict setObject:userNameTXT.text forKey:@"username"];
        [signupdict setObject:emailTXT.text    forKey:@"email"];
        [signupdict setObject: [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]]      forKey:@"birthday"];
        [signupdict setObject:gender           forKey:@"gender"];
        [signupdict setObject:passwordTXT.text forKey:@"password"];
        [signupdict setObject:@"1"             forKey:@"device_type"];
        [signupdict setObject:token            forKey:@"device_token"];
        
        NSMutableDictionary *imageDict = [[NSMutableDictionary alloc] init];
        
        if (ProfileImageData!= nil) {
            [imageDict setObject:ProfileImageData forKey:@"image"];
        }
        
        PhoneVC *phoneVc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneVC"];
        phoneVc.signupParamDict =[[NSMutableDictionary alloc] initWithDictionary:signupdict];
        phoneVc.imgDict =[[NSMutableDictionary alloc] initWithDictionary:imageDict];
        [self presentViewController:phoneVc animated:YES completion:nil];

    }
}

#pragma mark - UIPickerviewDelegate&Datasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [genderArray count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    genderTXT.text = [genderArray objectAtIndex:row];
    if (row == 0) {
        gender = @"1";
    }
    else if(row ==1){
        gender = @"2";
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title ;
    
    title = [genderArray objectAtIndex:row];
    return title;
}

#pragma mark - UIButtonActions

- (IBAction)ageBtnAction:(id)sender {
    if (ageBtn.selected == YES)
    {
        ageBtn.selected = NO;
        ageStr = @"";
    }
    else
    {
        ageStr = @"1";
        ageBtn.selected = YES;
    }
}

- (IBAction)fbBtnAction:(id)sender {

}

- (IBAction)googlePlusBtnAction:(id)sender {

}

- (IBAction)signInBtnAction:(id)sender {
    
    UIViewController *signin = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self dismissViewControllerAnimated:signin completion:nil];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
//    
//   if (textField == userNameTXT) {
//        NSString *emailRegex =
//        @"abcdefghijklmnopqrstuvwxyz._-";
//        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
//        
//        return [emailTest evaluateWithObject:string];
//    }
//    return true;
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (userNameTXT == textField) {
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
    }
    if (textField == userNameTXT) {
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


-(BOOL)validateAge
{
    NSString *birthDate = dobTXT.text;
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:birthDate]];
    int allDays = (((time/60)/60)/24);
    int days = allDays%365;
    int years = (allDays-days)/365;
    
    NSLog(@"You live since %i years and %i days",years,days);
    
    if(years>=13)
    {
        age = @"yes";
        return YES;
    }
    else
    {
         age = @"NO";
        return NO;
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  EditEventVC.m
//  invite
//
//  Created by AJ on 10/9/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "EditEventVC.h"

@interface EditEventVC ()

@end

@implementation EditEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cameraBtn.layer.cornerRadius =cameraBtn.frame.size.width/2;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width , 44.0f)];
    _tableDataSource = [[GMSAutocompleteTableDataSource alloc] init];
    _tableDataSource.delegate = self;
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.searchBar.delegate = self;
    
    _searchBar.placeholder = @"Enter Location";
    
    _searchDisplayController.searchResultsDataSource = _tableDataSource;
    _searchDisplayController.searchResultsDelegate = _tableDataSource;
    _searchDisplayController.delegate = self;
    
    [self.view addSubview:_searchBar];
    
    _searchBar.hidden = YES;
    [self createPickersView];

    [self showDataOnView];
}

- (void) showDataOnView {

    dateStr     = [_dataDictionary objectForKey:@"event_date"];
    timeStr     = [_dataDictionary objectForKey:@"start_time"];
    endTimeStr  = [_dataDictionary objectForKey:@"end_time"];
    
    eventNAmeTF.text    = [_dataDictionary objectForKey:@"name"];
    locationTF.text     = [_dataDictionary objectForKey:@"address"];
    locationLati        = [_dataDictionary objectForKey:@"latitude"];
    locationLongi       = [_dataDictionary objectForKey:@"longitude"];
    city                = @"City";
    
    [eventImageV setImageWithURL:[NSURL URLWithString:[_dataDictionary objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"BG_EVNT_IMG"]];
    
    NSTimeInterval _interval11    = [endTimeStr doubleValue];
    NSDate *date11                = [NSDate dateWithTimeIntervalSince1970:_interval11];
    NSDateFormatter *_formatter11 = [[NSDateFormatter alloc]init];
    [_formatter11 setDateFormat:@"H:mm"];
    
    endTimeTF.text            = [_formatter11 stringFromDate:date11];
    
    NSTimeInterval _interval1    = [timeStr doubleValue];
    NSDate *date1                = [NSDate dateWithTimeIntervalSince1970:_interval1];
    NSDateFormatter *_formatter1 = [[NSDateFormatter alloc]init];
    [_formatter1 setDateFormat:@"H:mm"];
    
    startTimeTF.text            = [_formatter1 stringFromDate:date1];
    
    
    NSTimeInterval _interval    = [dateStr doubleValue];
    NSDate *date                = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"YYYY-dd-MM"];
    
    dateTF.text             = [_formatter stringFromDate:date];
    infoTV.text             = [_dataDictionary objectForKey:@"description"];
    
    infoTV.textColor  = [UIColor darkGrayColor];
}

- (void) createPickersView {
    
    datePicker  = [[UIDatePicker alloc]init];
    datePicker.datePickerMode   = UIDatePickerModeDate;
    datePicker.backgroundColor  = [UIColor whiteColor];
    
    datePicker.date = [NSDate date];
    [datePicker addTarget:self action:@selector(startDatePick:) forControlEvents:UIControlEventValueChanged];
    dateTF.inputView = datePicker;
    
    timePicker  = [[UIDatePicker alloc]init];
    timePicker.datePickerMode   = UIDatePickerModeTime;
    timePicker.backgroundColor  = [UIColor whiteColor];
    
    timePicker.date = [NSDate date];
    [timePicker addTarget:self action:@selector(startTimePick:) forControlEvents:UIControlEventValueChanged];
    startTimeTF.inputView = timePicker;
    
    
    endTimePicker   = [[UIDatePicker alloc]init];
    endTimePicker.datePickerMode    = UIDatePickerModeTime;
    endTimePicker.backgroundColor   = [UIColor whiteColor];
    endTimePicker.date              = [NSDate date];
    
    [endTimePicker addTarget:self action:@selector(endTimePick:) forControlEvents:UIControlEventValueChanged];
    endTimeTF.inputView = endTimePicker;
    
}


-(void)startDatePick:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str   = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    dateTF.text = str;
    dateStr     = [NSString stringWithFormat:@"%0.0f",[datePicker.date timeIntervalSince1970]];
    
}

-(void)startTimePick:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle    =NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"H:mm"];
    NSString *str       = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:timePicker.date]];
    startTimeTF.text    = str;
    
    NSString *newTime = [NSString stringWithFormat:@"%@ %@",dateTF.text,str];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [dateFormatter1 dateFromString:newTime];
    timeStr      = [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]];
 
    
}

-(void)endTimePick:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"H:mm"];
    NSString *str   = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:endTimePicker.date]];
    
    endTimeTF.text  = str;
    NSString *newTime = [NSString stringWithFormat:@"%@ %@",dateTF.text,str];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd hh:mm a"];
    NSDate *date = [dateFormatter1 dateFromString:newTime];
    endTimeStr      = [NSString stringWithFormat:@"%0.0f",[date timeIntervalSince1970]];
}

#pragma mark - button action

- (IBAction)createEventBtnAction:(id)sender {
    
    if (imgData == nil) {
        imgData = UIImageJPEGRepresentation(eventImageV.image, 1.0);
    }

    
    if ([[eventNAmeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        
        SHOW_NETWORK_ERROR(@"Please enter event name!", self);
    }
    else if ([selectedTypStr isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Please select Event type!!", self);
    }
    else if ([dateStr isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Please select Event date!!", self);
    }
    else if ([timeStr isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Please select Event Start Time!!", self);
    }
    else if ([endTimeStr isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Please select Event End Time!!", self);
    }
    else if(imgData == nil) {
        SHOW_NETWORK_ERROR(@"Please select Event Image!!", self);
    }
    else if([[locationTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        SHOW_NETWORK_ERROR(@"Please select Event Location!!", self);
    }
    else {
        
        NSDictionary *dict = @{@"auth_token"    :AUTH_TOKEN,
                               @"name"           :eventNAmeTF.text,
                               @"event_date"    :dateStr,
                               @"end_time"      :endTimeStr,
                               @"start_time"    :timeStr,
                               @"latitude"      :locationLati,
                               @"longitude"     :locationLongi,
                               @"address"       :locationTF.text,
                               @"city"          :@"city",
                               @"zip"           :@"123456",
                               @"description"  :infoTV.text,
                               @"event_id"      :[_dataDictionary objectForKey:@"id"]
                               };
        
        
        NSDictionary *imgDict = @{@"event_image" :imgData};
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@", appURL,@"edit_event"];
        [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
         {
             
             if (responseObject == false)
             {
                 SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
             }
             else
             {
                 
                 [[ApiManager sharedInstance] apiCallWithImage:urlString parameterDict:dict imageDataDictionary:imgDict  CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                     
                     HIDE_PROGRESS;
                     if (success == false)
                     {
                         SHOW_NETWORK_ERROR(message, self);
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary])
                         {
                             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Event Updated Successfully.." preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *okAction = [UIAlertAction
                                                        actionWithTitle:@"OK"   style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                                        {
                                                            [[IQKeyboardManager sharedManager] setEnable:YES];
                                                            [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
                                                            [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:YES];
                                                            
                                                            self.tabBarController.tabBar.hidden = false;
                                                            [self.navigationController popViewControllerAnimated:true];
                                                        }];
                             
                             [alertController addAction:okAction];
                             
                             [self presentViewController:alertController animated:YES completion:nil];
                         }
                         else
                         {
                             SHOW_NETWORK_ERROR(@"Error Occured While Creating Event!!", self);
                         }
                     }
                 }];
             }
             
         }];
    }
}

- (IBAction)addphotoBtnaction:(id)sender

{
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
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
                                  imagePickerController.allowsEditing = true;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing = true;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (IBAction)backBtnAction:(id)sender {
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:YES];
    
    self.tabBarController.tabBar.hidden = false;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage * img       = [info valueForKey:UIImagePickerControllerEditedImage];
    eventImageV.image   = img;
    imgData         = UIImageJPEGRepresentation(img, 0.5);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker  dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == locationTF) {
        [[IQKeyboardManager sharedManager] setEnable:NO];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
        [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:NO];
        
        _searchBar.hidden = NO;
        [_searchBar becomeFirstResponder];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:YES];
    
    if ([textView.text isEqualToString:@"Information"]) {
        
        textView.text   = @"";
        textView.textColor  = [UIColor darkGrayColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Information"] || [textView.text isEqualToString:@""]) {
        textView.textColor  = [UIColor lightGrayColor];
    }
}



#pragma mark - UIAlertview Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Search Bar Delegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchBar.hidden = YES;
    searchBar.text = @"";
    [self.view endEditing:YES];
}

#pragma mark - Search Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [_tableDataSource sourceTextHasChanged:searchString];
    return NO;
}

#pragma mark
#pragma mark - Map Delgate
- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didAutocompleteWithPlace:(GMSPlace *)place {
    
    [_searchDisplayController setActive:NO animated:YES];
    
    // Do something with the selected place.
    //    NSLog(@"Place name %@", place.name);
    
    NSLog(@"Place address %@", place.formattedAddress);
    //    NSLog(@"Place attributions %@", place.attributions.string);
    //    NSLog(@"lat %f", place.coordinate.latitude);
    //    NSLog(@"lang %f", place.coordinate.longitude);
    locationLati    = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
    locationLongi   = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
    
    locationTF.text     = place.name;
    _searchBar.hidden   = YES;
}

- (void)tableDataSource:(GMSAutocompleteTableDataSource *)tableDataSource
didFailAutocompleteWithError:(NSError *)error {
    [_searchDisplayController setActive:NO animated:YES];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)didUpdateAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    // Turn the network activity indicator off.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Reload table data.
    [_searchDisplayController.searchResultsTableView reloadData];
}

- (void)didRequestAutocompletePredictionsForTableDataSource:
(GMSAutocompleteTableDataSource *)tableDataSource {
    // Turn the network activity indicator on.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // Reload table data.
    [_searchDisplayController.searchResultsTableView reloadData];
}



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

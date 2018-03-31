//
//  ChatVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "ChatVC.h"
#import "GroupMemberDetailVC.h"

@interface ChatVC ()
{
    IBOutlet UIButton *topBtn;
    
}
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    chatTV.rowHeight = UITableViewAutomaticDimension;
    chatTV.estimatedRowHeight = 50.0f;
    
    
    [self.tabBarController.tabBar setHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getChatList)
                                                 name:@"ChatNotification"
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(groupgetChatList)
                                                 name:@"GroupChatNotification"
                                               object:nil];
    
    UITapGestureRecognizer *tapGesture  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGesture.cancelsTouchesInView     = NO;
    [chatTV addGestureRecognizer:tapGesture];
    
    apiCallDict = [[NSMutableDictionary alloc] init];
    viewTitle   = self.title;
  
    if ([self.title isEqualToString:@"Event"]) {
        
        [apiCallDict setObject:[_dataDict objectForKey:@"id"] forKey:@"event_id"];
        [apiCallDict setObject:AUTH_TOKEN forKey:@"auth_token"];
        topBtn.hidden = YES;
        /*
         @"auth_token" :AUTH_TOKEN,
         @"event_id":[_dataDict objectForKey:@"id"]
         */
    }
    else {
        topBtn.hidden = NO;
        [apiCallDict setObject:[_dataDict objectForKey:@"id"] forKey:@"group_id"];
       
        [apiCallDict setObject:AUTH_TOKEN forKey:@"auth_token"];
             }
    
      [self updateChatView];
}

#pragma mark -ViewWillAppear
-(void) viewWillAppear:(BOOL)animated {
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:NO];
    
}

- (void) updateChatView {
    userIMG.layer.cornerRadius  = userIMG.frame.size.width/2.0f;
    userIMG.clipsToBounds       = true;
    
    nameLB.text     = [[NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"name"]]capitalizedString];
    if ([self.title isEqualToString:@"Event"]) {
        [userIMG setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"AppLogo"]];
        [self getChatList];
    }
    else {
        [userIMG setImageWithURL:[NSURL URLWithString:[_dataDict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"AppLogo"]];
          [self groupgetChatList];
    }
   
   
}

#pragma mark - ApiToGetChatList

- (void) getChatList {
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             
             //NSDictionary * params = @{
                   //                    @"auth_token" :AUTH_TOKEN,
                   //                    @"event_id":[_dataDict objectForKey:@"id"]};
             
             NSString *apiName = @"";
             apiName    = @"get_event_chat";
            
             
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,apiName];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:apiCallDict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(message, self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          
                          chatArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [chatTV reloadData];
                           [self seenMsgApiCalling];
                      }
                      else
                      {
                          SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                      }
                  }
              }];
         }
     }];
}
- (void) groupgetChatList {
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             
             //NSDictionary * params = @{
             //                    @"auth_token" :AUTH_TOKEN,
             //                    @"event_id":[_dataDict objectForKey:@"id"]};
             
             NSString *apiName = @"";
             
            apiName    = @"get_chat";
            
             
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,apiName];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:apiCallDict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(message, self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          
                          chatArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [chatTV reloadData];
                          [self seenMsgApiCalling];
                      }
                      else
                      {
                          SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                      }
                  }
              }];
         }
     }];
}
- (void) seenMsgApiCalling {
    
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             
                        NSString *type = @"";
             NSString *event_id =@"";
             NSString *group_id =@"";
             if ([self.title isEqualToString:@"Event"]) {
                 type    = @"2";
                 event_id =[_dataDict objectForKey:@"id"];
             }
             else {
                 type    = @"1";
                 group_id =[_dataDict objectForKey:@"id"];
             }
             
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       @"event_id":event_id,
                                       @"group_id" :group_id,
             @"type":type};

             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"msg_seen"];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
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
                          SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                      }
                  }
              }];
         }
     }];
}

#pragma mark -

- (void)keyboardWasShown:(NSNotification *)notification
{
     CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    bottomConstraint.constant = keyboardSize.height;
}

- (void)keyboardHide:(NSNotification *)notification
{
    [self.view endEditing:YES];
    bottomConstraint.constant = 0;
}

#pragma mark - UITableViewDelegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return chatArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (![[chatArray[indexPath.row] objectForKey:@"user_id"] isEqualToString:GET_USER_ID]) {
        
        if ([[chatArray[indexPath.row] objectForKey:@"msg_type"] isEqualToString:@"1"]) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherImageCell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherImageCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *chatIMG = [cell.contentView viewWithTag:1];
            [chatIMG setImageWithURL:[NSURL URLWithString:[chatArray[indexPath.row] objectForKey:@"msg"]] placeholderImage:[UIImage imageNamed:@""]];
            chatIMG.clipsToBounds    = true;
            chatIMG.layer.cornerRadius   = 10.0f;
            
            UIView *outerV  = [cell.contentView viewWithTag:10];
            outerV.clipsToBounds    = true;
            outerV.layer.cornerRadius   = 10.0f;
            
            UILabel *nameuserLB = [cell.contentView viewWithTag:11];
            nameuserLB.text     = [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] != nil ? [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] : @"";
            
            return cell;
        }
        else { // TEXT
        
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherTextCell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherTextCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *textLB = [cell.contentView viewWithTag:1];
            textLB.text     = [chatArray[indexPath.row] objectForKey:@"msg"];
            
            UIView *outerV  = [cell.contentView viewWithTag:10];
            outerV.clipsToBounds    = true;
            outerV.layer.cornerRadius   = 10.0f;
            
            UILabel *nameuserLB = [cell.contentView viewWithTag:11];
            nameuserLB.text     = [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] != nil ? [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] : @"";
            
            return cell;
        }
    }
    else {
        
        if ([[chatArray[indexPath.row] objectForKey:@"msg_type"] isEqualToString:@"1"]) {
           
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyImageCell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyImageCell"];
            }
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
            
            UIImageView *chatIMG    = [cell.contentView viewWithTag:1];
            [chatIMG setImageWithURL:[NSURL URLWithString:[chatArray[indexPath.row] objectForKey:@"msg"]] placeholderImage:[UIImage imageNamed:@""]];
            chatIMG.clipsToBounds    = true;
            chatIMG.layer.cornerRadius   = 10.0f;
            
            UIView *outerV      = [cell.contentView viewWithTag:10];
            outerV.clipsToBounds        = true;
            outerV.layer.cornerRadius   = 10.0f;
            
            UILabel *nameuserLB = [cell.contentView viewWithTag:11];
            nameuserLB.text     = [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] != nil ? [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] : @"";
            
            return cell;
        
        }
        else {
        //Text
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTextCell"];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyTextCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *textLB = [cell.contentView viewWithTag:1];
            textLB.text     = [chatArray[indexPath.row] objectForKey:@"msg"];
            
            
            UIView *outerV  = [cell.contentView viewWithTag:10];
            outerV.clipsToBounds    = true;
            outerV.layer.cornerRadius   = 10.0f;
            
            UILabel *nameuserLB = [cell.contentView viewWithTag:11];
            nameuserLB.text     = [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] != nil ? [[chatArray[indexPath.row] objectForKey:@"user"] objectForKey:@"username"] : @"";
            
            return cell;
        }
    }
}

#pragma mark - UIButtonActions

- (IBAction)backBtnAction:(id)sender {
    
    [self.tabBarController.tabBar setHidden:false];
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)videoBtnAction:(id)sender {
    
    
}
- (IBAction)attacmentBtnAction:(id)sender {
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
                                  imagePickerController.allowsEditing   = true;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing Photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.allowsEditing   = true;
                                  imagePickerController.delegate = self;
                                  imagePickerController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - imagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    if (imageData != nil) {
        [self sendImageMessage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - SendMessageBtn

- (IBAction)sendBtnAction:(id)sender {
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         
         if (responseObject == false)
         {
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             //NSDictionary *dict     = @{@"event_id":[_dataDict objectForKey:@"id"], @"auth_token":AUTH_TOKEN,  @"message_type":@"0" , @"message":messageV.text};
             
             [apiCallDict setObject:@"0" forKey:@"message_type"];
             [apiCallDict setObject:messageV.text forKey:@"message"];
             
             NSString *apiName = @"";
             if ([self.title isEqualToString:@"Event"]) {
                 apiName    = @"event_chat";
             }
             else {
                 apiName    = @"chat";
             }
             
             NSString *urlStr       = [NSString stringWithFormat:@"%@%@",appURL,apiName];
             
             [[ApiManager sharedInstance] apiCallWithImage:urlStr parameterDict:apiCallDict imageDataDictionary:nil  CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                 
                 HIDE_PROGRESS;
                 if (success == false)
                 {
                     SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                 }
                 else
                 {
                     if ([Util checkIfSuccessResponse:dictionary])
                     {
                         messageV.text = @"";
                         if ([self.title isEqualToString:@"Event"]) {
                              [self getChatList];
                         }
                         else {
                             [self groupgetChatList];
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


- (void) sendImageMessage {

    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         
         if (responseObject == false)
         {
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             //NSDictionary *dict     = @{@"event_id":[_dataDict objectForKey:@"id"], @"auth_token":AUTH_TOKEN, @"message":messageV.text , @"message_type":@"1"};
             
             [apiCallDict setObject:@"1" forKey:@"message_type"];
             
             NSDictionary *imgDict       = @{@"message":imageData};
             
             NSString *apiName = @"";
             if ([self.title isEqualToString:@"Event"]) {
                 apiName    = @"event_chat";
             }
             else {
                 apiName    = @"chat";
             }
             
             NSString *urlStr       = [NSString stringWithFormat:@"%@%@",appURL,apiName];
             
             [[ApiManager sharedInstance] apiCallWithImage:urlStr parameterDict:apiCallDict imageDataDictionary:imgDict  CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                 
                 HIDE_PROGRESS;
                 if (success == false)
                 {
                     SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                 }
                 else
                 {
                     if ([Util checkIfSuccessResponse:dictionary])
                     {
                       
                         if ([self.title isEqualToString:@"Event"]) {
                             [self getChatList];
                         }
                         else {
                             [self groupgetChatList];
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



#pragma mark -

#pragma mark - TextViewDelegates

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Message Here.."]) {
        
        textView.text   = @"";
        textView.textColor  = [UIColor darkGrayColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"Message Here.."] || [textView.text isEqualToString:@""]) {
        textView.textColor  = [UIColor lightGrayColor];
    }
}

- (IBAction)groupInfoBtnAction:(id)sender {
    
    GroupMemberDetailVC *view =[self.storyboard instantiateViewControllerWithIdentifier:@"GroupMemberDetailVC"];
    view.groupID    = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"id"]];
    view.groupName  = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"name"]];
    [self.navigationController pushViewController:view animated:YES];
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

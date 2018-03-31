//
//  NotificationVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "NotificationVC.h"
#import "NotificationTVCell.h"
#import "EventDetailVC.h"
@interface NotificationVC ()
{
    UIRefreshControl * refreshControl;
}
@end

@implementation NotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [notificationTV addSubview:refreshControl];
    
   [refreshControl addTarget:self action:@selector(getNotifications) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TokenChange:)
                                                 name:@"LOGIN"
                                               object:nil];
    notificationTV.tableFooterView = [[UIView alloc] init];
}
-(void) TokenChange:(NSNotification *)notification {
    
    // SET_AUTH_TOKEN(nil);
    UIStoryboard *story  = self.storyboard;
    UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.view.window.rootViewController = views;
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:true];
    [self getNotifications];
}

#pragma mark - Custom Methods

- (void) getNotifications {
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             [refreshControl endRefreshing];
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"notification"];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  [refreshControl endRefreshing];
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(message, self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          notificationsArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [notificationTV reloadData];
                          [self seenNotificationApiCalling];
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
- (void) seenNotificationApiCalling {
    
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
             
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"seen_notification"];
             
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
                           [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
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

#pragma mark - UITableViewDelegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if ([notificationsArray count] > 0) {
            tableView.backgroundView = nil;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            noDataLabel.font             = FONT_Medium(20);
            noDataLabel.textColor        = [UIColor darkGrayColor];
            noDataLabel.text             = @"No New Notifications Found";
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tableView.backgroundView = noDataLabel;
        }
        return [notificationsArray count];
    }
    else if (section == 1) {
        return 0;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    if (cell == nil) {
        
        cell = [[NotificationTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NotificationCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userProfileImgV.layer.cornerRadius =cell.userProfileImgV.frame.size.width/2;
    cell.userProfileImgV.clipsToBounds = YES;
    if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"type"]] isEqualToString:@"2"]) {
        
         cell.userInteractionEnabled = YES;
        cell.notificationDetailLb.text  = [NSString stringWithFormat:@"%@ has invited you to %@",[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]], [[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"event_data"] objectForKey:@"name"] capitalizedString]];
        cell.userNAmeLB.text            = [NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]];
        
        [cell.userProfileImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
    }
    else if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"type"]] isEqualToString:@"1"]) {
         cell.userInteractionEnabled = YES;
         cell.notificationDetailLb.text  = [NSString stringWithFormat:@"%@  has sent you a friend request",[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]]];
        cell.userNAmeLB.text            = [NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]];
        
        [cell.userProfileImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
    }
    else if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"type"]] isEqualToString:@"3"]){
        cell.userInteractionEnabled = NO;
        if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"seen"]] isEqualToString:@"1"]) {
            if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"status"]] isEqualToString:@"1"]){
                 cell.userNAmeLB.text            = [NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]];
                cell.notificationDetailLb.text  = [NSString stringWithFormat:@"%@ has accepted your request",[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]]];
                  [cell.userProfileImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
            }
            else{
                 cell.userNAmeLB.text            = [NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]];
                cell.notificationDetailLb.text  = [NSString stringWithFormat:@"%@ has rejected your request",[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"username"]]];
                  [cell.userProfileImgV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"sender_data"] objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
            }
        }

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *localView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    localView.backgroundColor =UIColorFromRGBAlpha(240, 240, 240, 1);
    
    UILabel *artistlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, localView.frame.size.width, 30)];
    
    artistlbl.textAlignment           = NSTextAlignmentCenter;
    
    if (section == 0)  {
        artistlbl.text = @"NEW NOTIFICATION";
    }
    else {
        artistlbl.text = @"OLD NOTIFICATION";
    }
    [localView addSubview:artistlbl];
    
    UIView *LineV = [[UIView alloc] initWithFrame:CGRectMake(0,localView.frame.size.height-1, localView.frame.size.width, 1)];
    
    LineV.backgroundColor = [UIColor lightGrayColor];
    [localView addSubview:LineV];
    
    
    return localView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}


-(NSArray* )tableView:(UITableView* )tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str;
    NSString *str1;
    NSString *str2;
    NSString *url;
    if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"type"]] isEqualToString:@"2"]) {
        
        if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"seen"]] isEqualToString:@"0"]) {
            
            url = [NSString stringWithFormat:@"%@%@",appURL,@"attend_event"];
            str = [NSString stringWithFormat:@"%@%@",@"",@"\u24E7\n Decline" ];
            ;
             UITableViewRowAction *declineAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:str  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                
                 [self attendOrNOt:@"2" dataDictionary:[notificationsArray objectAtIndex:indexPath.row] UrlString:url seen:@""];
            }];
            declineAction.backgroundColor = [UIColor redColor];
            
            str1 = [NSString stringWithFormat:@"%@%@",@"",@"\u2713\n Accept" ];
            ;
             UITableViewRowAction *acceptAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:str1  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                
                 UIAlertController *alertController = [UIAlertController
                                                       alertControllerWithTitle:appNAME
                                                       message:@"Do you want your name to be added to the guest list?"
                                                       preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *okAction = [UIAlertAction
                                            actionWithTitle:@"YES"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
                                            {
                                                [self attendOrNOt:@"1" dataDictionary:[notificationsArray objectAtIndex:indexPath.row] UrlString:url seen:@"1"];
                                            }];
                 UIAlertAction *noAction = [UIAlertAction
                                            actionWithTitle:@"NO"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
                                            {
                                                [self attendOrNOt:@"1" dataDictionary:[notificationsArray objectAtIndex:indexPath.row] UrlString:url seen:@"0"];
                                            }];
                 
                 [alertController addAction:okAction];
                 [alertController addAction:noAction];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
                 
            }];
            
            acceptAction.backgroundColor = UIColorFromRGBAlpha(4, 208, 139, 1);
            
            str2 = [NSString stringWithFormat:@"%@%@",@"",@"\n  View" ];
            ;
            UITableViewRowAction *viewAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:str2  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                [self eventDetail:[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"event_data"]];
                
            }];
            viewAction.backgroundColor = [UIColor lightGrayColor];

            return @[acceptAction,declineAction,viewAction];
        }
        else{
           

        }
    }
    
    else if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"type"]] isEqualToString:@"1"]) {
        if ([[NSString stringWithFormat:@"%@",[[notificationsArray objectAtIndex:indexPath.row] objectForKey:@"seen"]] isEqualToString:@"0"]) {
             url = [NSString stringWithFormat:@"%@%@",appURL,@"accept_friend_request"];
            str = [NSString stringWithFormat:@"%@%@",@"",@"\u24E7\n Decline" ];
            ;
            UITableViewRowAction*declineAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:str  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
                
               [self frientrquest:@"2" dataDictionary:[notificationsArray objectAtIndex:indexPath.row] UrlString:url];
            }];
            declineAction.backgroundColor = [UIColor redColor];
            
            str1 = [NSString stringWithFormat:@"%@%@",@"",@"\u2713\n Accept" ];
            ;
             UITableViewRowAction *acceptAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:str1  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            [self frientrquest:@"1" dataDictionary:[notificationsArray objectAtIndex:indexPath.row] UrlString:url];
              
            }];
            acceptAction.backgroundColor = UIColorFromRGBAlpha(4, 208, 139, 1);
            return @[acceptAction,declineAction];

        }
        else{
            
        }
        
    }
    return nil;
}

#pragma mark - buttonAction


- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)searchBntaction:(id)sender {
}

#pragma mark - apiCallForAttending

- (void) attendOrNOt: (NSString *)status dataDictionary : (NSDictionary *)_dataDict UrlString :(NSString *) _urlString  seen :(NSString *) _seen {
    
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
             
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       @"status" : status,
                                       @"seen_in_list":_seen,
                                       @"event_id" : [_dataDict objectForKey:@"event_id"]};
             
            
             
             [[ApiManager sharedInstance] POST:_urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
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
                          
                          [self getNotifications];
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
- (void) frientrquest: (NSString *)status dataDictionary : (NSDictionary *)_dataDict UrlString :(NSString *) _urlString {
    
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
             
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       @"status" : status,
                                       @"user_id" :[_dataDict objectForKey:@"senderId"]};
             
             
             
             [[ApiManager sharedInstance] POST:_urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
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
                          ALERTVIEW(appNAME, @"Your Invite Status Updated Successfully.", self);
                          [self getNotifications];
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

-(void) eventDetail: (NSDictionary *)_dataDict{
    
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
             
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       @"event_id" :[_dataDict objectForKey:@"id"]};
             
             
              NSString *urlstring = [NSString stringWithFormat:@"%@%@",appURL,@"event_detail"];
             [[ApiManager sharedInstance] POST:urlstring parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
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
                          EventDetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailVC"];
                          detail.title = @"Home";
                          detail.detailsDict  = [[NSMutableDictionary alloc] initWithDictionary:[dictionary objectForKey:@"body"]];
                          [self.navigationController pushViewController:detail animated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ProfileVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "ProfileVC.h"
#import "RecentTVCell.h"
#import "EventDetailVC.h"
#import "EditEventVC.h"


@interface ProfileVC ()

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TokenChange:)
                                                 name:@"LOGIN"
                                               object:nil];
    recentEventTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    editProfileBtn.layer.cornerRadius  = 20;
    editProfileBtn.clipsToBounds = YES;
    
}
-(void) TokenChange:(NSNotification *)notification {
    
    // SET_AUTH_TOKEN(nil);
    UIStoryboard *story  = self.storyboard;
    UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.view.window.rootViewController = views;
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    self.tabBarController.tabBar.hidden = false;
  
    NSDictionary *userDetailsDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    if (userDetailsDict != nil) {
        
        userNAmeLB.text = [userDetailsDict objectForKey:@"username"];
        if ([[userDetailsDict objectForKey:@"gender"] integerValue]==2)
        {
            [userProfileImgV setImageWithURL:[NSURL URLWithString:[userDetailsDict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"USER_PIC_FEMALE"]];
        }
        else
        {
        [userProfileImgV setImageWithURL:[NSURL URLWithString:[userDetailsDict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
        }
        userProfileImgV.layer.cornerRadius  = userProfileImgV.frame.size.width/2.0f;
        userProfileImgV.clipsToBounds       = true;
    }
      [self showEventsBtn: recentBtn];
}


- (void) getEventsWithApiName : (NSString *) apiName{
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
                                       @"auth_token" :AUTH_TOKEN                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,apiName];
            [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(@"Error retrieving data from Server", self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          scoreLB.text = [NSString stringWithFormat:@"%@",[[[dictionary objectForKey:@"body"] objectForKey:@"user"]objectForKey:@"score"]];
                          eventArray = [[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"body"] objectForKey:@"recent"] ];
                          [recentEventTV reloadData];
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

- (void) getEventsWithApiName1 : (NSString *) apiName{
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
                                       @"auth_token" :AUTH_TOKEN                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,apiName];
             [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(@"Error retrieving data from Server", self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                         eventArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                         [recentEventTV reloadData];
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


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return eventArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentC"];
    if (cell == nil) {
         cell = [[RecentTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecentC"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imgV.layer.cornerRadius = cell.imgV.frame.size.width/2;
    cell.clipsToBounds =YES;
    [cell.imgV setImageWithURL:[NSURL URLWithString:[[eventArray objectAtIndex:indexPath.row] objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
    cell.nameLB.text    = [[eventArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailVC *detail   = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailVC"];
    detail.detailsDict      = [eventArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(NSArray* )tableView:(UITableView* )tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *str = [NSString stringWithFormat:@"%@%@",@"",@"\u24E7\n Delete"];
    ;
    UITableViewRowAction *declineAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:str  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [self deleteEvent:[eventArray objectAtIndex:indexPath.row]];
    }];
    declineAction.backgroundColor = [UIColor redColor];
    
    NSString *str1 = [NSString stringWithFormat:@"%@%@",@"",@"\u2713\n Edit" ];
    
    UITableViewRowAction *acceptAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:str1  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        EditEventVC *view   = [self.storyboard instantiateViewControllerWithIdentifier:@"EditEventVC"];
        view.dataDictionary = [[NSMutableDictionary alloc] initWithDictionary:[eventArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:view animated:true];
    }];
    acceptAction.backgroundColor = UIColorFromRGBAlpha(4, 208, 139, 1);
    return @[acceptAction,declineAction];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([myEventsBTN isSelected]) {
        return true;
    }
    else {
        return false;
    }
    return false;
}

#pragma mark - button action

- (IBAction)editProfileBntAction:(id)sender {
    UIViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    self.tabBarController.tabBar.hidden = true;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)settingBtnAction:(id)sender {
    UIViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)searchBtnAction:(id)sender {
  
    UIViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchUserVC"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)showEventsBtn:(UIButton *)sender {
    
    recentBtn.selected      = false;
    myEventsBTN.selected    = false;
    sender.selected         = true;
    
    recentBtn.backgroundColor   = UIColorFromRGBAlpha(240, 240, 240, 1);
    myEventsBTN.backgroundColor = UIColorFromRGBAlpha(240, 240, 240, 1);
    
    sender.backgroundColor      = UIColorFromRGBAlpha(255, 72, 1, 1);
    
    if (sender == recentBtn) {
        
        [self getEventsWithApiName:@"recent_event_list"];
    }
    else {
        [self getEventsWithApiName1:@"my_event_list"];
    }
}

- (void) deleteEvent:(NSDictionary *) _dataDict {

    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:appNAME
                                          message:@"Are you sure you want to delete the event?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
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
                                                                      @"id" : [_dataDict objectForKey:@"id"]};
                                            NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"delete_event"];
                                            
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
                                                         [eventArray removeObject:_dataDict];
                                                         [recentEventTV reloadData];
                                                     }
                                                     else
                                                     {
                                                         SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                                                     }
                                                 }
                                                 
                                             }];
                                        }
                                        
                                    }];

                               }];
    
    [alertController addAction:okAction];
    
    UIAlertAction *ok1Action = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    [alertController addAction:ok1Action];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

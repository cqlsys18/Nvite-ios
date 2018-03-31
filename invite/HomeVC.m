//
//  HomeVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "HomeVC.h"
#import "EventTVCell.h"
#import "SavedEventCV.h"
#import "ContactVC.h"
#import "EventDetailVC.h"
#import "ChatVC.h"
#import "AttendingVC.h"

@interface HomeVC ()
{
    IBOutlet UITableView *eventTV;
    IBOutlet UICollectionView *savedCV;
    IBOutlet UILabel *noteLB;
    UIRefreshControl *refreshControl;
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [LocationManager sharedInstance];
    refreshControl = [[UIRefreshControl alloc]init];
    [eventTV addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(getEvents) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TokenChange:)
                                                 name:@"LOGIN"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoveToNoti)
                                                   name:@"Notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoveToChat:)
                                                 name:@"moveToChatVC" object:nil];
    //moveTogroupChatVC
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoveTogroupChat:)
                                                 name:@"moveTogroupChatVC" object:nil];
    eventTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
}
-(void) TokenChange:(NSNotification *)notification {
    
    // SET_AUTH_TOKEN(nil);
    UIStoryboard *story  = self.storyboard;
    UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.view.window.rootViewController = views;
    
}
-(void)MoveToNoti{
    UIViewController *view =[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)MoveToChat:(NSNotification *)notification{
    if([self.navigationController.visibleViewController isKindOfClass:[ChatVC class]])
    {
         [[NSNotificationCenter defaultCenter]  postNotificationName:@"ChatNotification" object:self];
       
    }else{
        [self.parentViewController.tabBarController setSelectedIndex:0];
        NSDictionary* userInfo = notification.object;
        ChatVC *views  = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        views.dataDict = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
        [self.navigationController pushViewController:views animated:YES];
    }
}
-(void)MoveTogroupChat:(NSNotification *)notification{
    if([self.navigationController.visibleViewController isKindOfClass:[ChatVC class]])
    {
        [[NSNotificationCenter defaultCenter]  postNotificationName:@"GroupChatNotification" object:self];
        
    }else{
        [self.parentViewController.tabBarController setSelectedIndex:0];
        NSDictionary* userInfo = notification.object;
        ChatVC *views  = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        views.dataDict = [[NSMutableDictionary alloc] initWithDictionary:userInfo];
        [self.navigationController pushViewController:views animated:YES];
    }
}



-(void)viewWillAppear:(BOOL)animated {

    [self updateLocationApiCalling];
}
- (void) updateLocationApiCalling
{
    
   NSString * locationLat = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString * locationLng =[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
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
                                       @"latitude":locationLat,
                                       @"longitude":locationLng
                                       
                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"update_location"];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  [refreshControl endRefreshing];
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(@"Error retrieving data from Server", self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          [self getEvents];
                         
                      }
                      else
                      {
                          [self getEvents];
                          SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                      }
                  }
                  
              }];
         }
         
     }];
}


- (void) getEvents {
    
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
                                       @"auth_token" :AUTH_TOKEN                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"invite_event_listing"];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  [refreshControl endRefreshing];
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(@"Error retrieving data from Server", self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          eventsArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [eventTV reloadData];
                          [self getSavedEvents];
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

- (void) getSavedEvents {
    
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
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"save_event_list"];
             
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
                        savedEventsArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          if (savedEventsArray.count == 0) {
                              savedCV.hidden = YES;
                              noteLB.hidden  = NO;
                          }
                          else{
                              savedCV.hidden = NO;
                              noteLB.hidden  = YES;
                              [savedCV reloadData];
                          }
                          [self getNotiCount];
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
-(void) getNotiCount {
    
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
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"count_notification"];
             
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
                          
                          if ([[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"body"]objectForKey:@"count"]] isEqualToString:@"0"]) {
                            [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
                          }
                          else{
                              [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"body"]objectForKey:@"count"]]];
                          }
                          
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

#pragma mark
#pragma mark - Collection View Delegate and Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return savedEventsArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"SavedEventCell";
    SavedEventCV *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    UIImageView*eventImagV        = [cell.contentView viewWithTag:1];
    
    
    eventImagV.layer.cornerRadius = eventImagV.frame.size.width/2;
    eventImagV.clipsToBounds      = YES;
   [eventImagV setImageWithURL:[NSURL URLWithString:[[savedEventsArray  objectAtIndex:indexPath.row ]objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"BG_EVNT_IMG"]];
    
    return cell;
    
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EventDetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailVC"];
    detail.title = @"Home";
    detail.detailsDict  = [[NSMutableDictionary alloc] initWithDictionary:[savedEventsArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detail animated:YES];
    
}
#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([eventsArray count] > 0) {
        tableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
        noDataLabel.font             = FONT_Medium(20);
        noDataLabel.textColor        = [UIColor darkGrayColor];
        noDataLabel.text             = @"No Event Invites Found";
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
    }
    return [eventsArray count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell"];
    if (cell == nil) {
        
        cell = [[EventTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EventCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = [eventsArray objectAtIndex:indexPath.row];
    
    [cell.eventImgV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"BG_EVNT_IMG"]];
    cell.eventNAmeLB.text       = [dict objectForKey:@"name"];
    
    NSString * timeStampString  = [dict objectForKey:@"event_date"];
    
    NSTimeInterval _interval    = [timeStampString doubleValue];
    NSDate *date                = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd MMMM YYYY"];
    cell.dateLB.text            = [_formatter stringFromDate:date];
    
    [cell.locationLB setTitle:[dict objectForKey:@"address"] forState:UIControlStateNormal];
    cell.UserNameLB.text    = [dict objectForKey:@"user_name"] != nil ? [NSString stringWithFormat:@"Hosted by: %@",[dict objectForKey:@"user_name"]] : @"Hosted By";
    if ([[NSString stringWithFormat:@"%@", [dict objectForKey:@"unseen_msg"]] isEqualToString:@"0"]) {
        cell.unreadCountLB.text =@"";
    }
    else{
        cell.unreadCountLB.text =[NSString stringWithFormat:@"(%@)", [dict objectForKey:@"unseen_msg"]];

    }
    if ([[dict objectForKey:@"user_id"] intValue] == [GET_USER_ID intValue])
    {
        [cell.attendBtn setTitle:@"Attending" forState:UIControlStateNormal];
        [cell.attendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cell.attendBtn.backgroundColor = [UIColor orangeColor];
    }
    else
    {
    if ([[dict objectForKey:@"attend"] intValue] == 1)
    {
        [cell.attendBtn setTitle:@"Attending" forState:UIControlStateNormal];
        [cell.attendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cell.attendBtn.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        cell.attendBtn.backgroundColor = [UIColor blackColor];
        [cell.attendBtn setTitle:@"Invited" forState:UIControlStateNormal];
        [cell.attendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    }
    cell.chatBtn.tag    = indexPath.row;
    cell.attendBtn.tag  = indexPath.row;
    cell.chatBtn.layer.cornerRadius = 15;
    cell.chatBtn.clipsToBounds = YES;
    cell.attendBtn.layer.cornerRadius = 15;
    cell.attendBtn.clipsToBounds = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailVC"];
    detail.title = @"Home";
    detail.detailsDict  = [[NSMutableDictionary alloc] initWithDictionary:[eventsArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - Button Action

- (IBAction)searchBtnAction:(id)sender {
    
}

- (IBAction)createEventBtnAction:(id)sender {
    
    UIViewController *createEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateEventVC"];
    self.tabBarController.tabBar.hidden = true;
    [self.navigationController pushViewController:createEvent animated:YES];
}

- (IBAction)attendBtnAction:(UIButton *)sender {
    
    AttendingVC *view   = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendingVC"];
    view.dataDict       = [[NSMutableDictionary alloc] initWithDictionary:[eventsArray objectAtIndex:sender.tag]];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)shareBtnaction:(UIButton*)sender {
    NSString * timeStampString  = [[eventsArray objectAtIndex:sender.tag] objectForKey:@"event_date"];
    
    NSTimeInterval _interval    = [timeStampString doubleValue];
    NSDate *date                = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd MMMM YYYY"];
  NSString *eventDate            = [_formatter stringFromDate:date];
    
    UIImage * image ;
    
    if (image != nil) {
        image =[UIImage imageNamed:[[eventsArray objectAtIndex:sender.tag] objectForKey:@"event_image"]];
    }
    else{
        image =[UIImage imageNamed:@"BG_EVNT_IMG"];
    }
    NSString *textToShare = [NSString stringWithFormat:@"Event %@ will be on %@",[[eventsArray objectAtIndex:sender.tag] objectForKey:@"name"],eventDate];
    
    NSArray *objectsToShare = @[textToShare,image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
- (IBAction)chatBtnAction:(UIButton *)sender {
    
    ChatVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    view.dataDict = [[NSMutableDictionary alloc] initWithDictionary:[eventsArray objectAtIndex:sender.tag]];
    view.title  = @"Event";
    [self.navigationController pushViewController:view animated:true];
}


- (IBAction)addnewGroupAction:(id)sender {
    ContactVC *ContactV = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactVC"];
    ContactV.title = @"Home";
    [self.navigationController pushViewController:ContactV animated:YES];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

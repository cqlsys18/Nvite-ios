//
//  MyFriendList.m
//  invite
//
//  Created by AJ on 10/10/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "MyFriendList.h"
#import "OtherUserProfileVC.h"
@interface MyFriendList ()

{
    IBOutlet UILabel *topLB;
    IBOutlet UITableView *friendTV;
    NSMutableArray * myfriendArray;
}
@end

@implementation MyFriendList

- (void)viewDidLoad {
    [super viewDidLoad];
    friendTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if ([self.title isEqualToString:@"Invited"])  {
        topLB.text = @"Invited";
        [self invitedApiCalling];
        
    }
    else if ([self.title isEqualToString:@"Attending"]){
        topLB.text = @"Attending";
         [self attendingAPiCalling];
    }
    else{
        topLB.text = @"Friends List";
         [self myFriendApiCalling];
    }
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([self.title isEqualToString:@"Invited"])  {
        topLB.text = @"Invited";
        [self invitedApiCalling];
        
    }
    else if ([self.title isEqualToString:@"Attending"]){
        topLB.text = @"Attending";
        [self attendingAPiCalling];
    }
    else{
        topLB.text = @"Friends List";
        [self myFriendApiCalling];
    }
    
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [myfriendArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyContactListCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyContactListCell"];
    }
    
    cell.selectionStyle         = UITableViewCellSelectionStyleGray;
    
    UIImageView*userimgV        = [cell.contentView viewWithTag:1];
    UILabel*nameLB              = [cell.contentView viewWithTag:2];
    
    nameLB.text     = [[myfriendArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    
    [userimgV setImageWithURL:[NSURL URLWithString:[[myfriendArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@""]];

    userimgV.layer.cornerRadius     = userimgV.frame.size.width/2;
    cell.clipsToBounds              = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OtherUserProfileVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileVC"];
    detail.friendId =[NSString stringWithFormat:@"%@",[[myfriendArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:detail animated:YES];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


#pragma mark - ButtonAction
- (IBAction)backBtnaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) myFriendApiCalling{
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
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"friend_list"];
             
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
                          myfriendArray =[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                        
                          if (myfriendArray.count == 0) {
                              [CustomVW sharedInstance].delegate  = self;
                              
                              SHOW_CUSTOM_ALERT(appNAME,@"You have no friends", self);

                          }
                          else{
                              for (int i = 0; i < myfriendArray.count; i++) {
                                  if ([[[myfriendArray objectAtIndex:i]objectForKey:@"id"] integerValue] == [GET_USER_ID integerValue]) {
                                      [myfriendArray removeObjectAtIndex:i];
                                  }
                                  
                              }
                          [friendTV reloadData];
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

-(void) invitedApiCalling{
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
                                       @"auth_token" :AUTH_TOKEN ,
                                       @"event_id": _eventId
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"event_invited_user"];
             
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
                          myfriendArray =[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          
                          if (myfriendArray.count == 0) {
                              [CustomVW sharedInstance].delegate  = self;
                              
                              SHOW_CUSTOM_ALERT(appNAME,@"No one is invited", self);
#pragma mark - CustomAlertDelegates
                              
                              
                              
                          }
                          else{
                              
                              [friendTV reloadData];
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

-(void) attendingAPiCalling{
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
                                        @"event_id": _eventId
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"event_attending_user"];
             
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
                          myfriendArray =[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          
                          if (myfriendArray.count == 0) {
                              [CustomVW sharedInstance].delegate  = self;
                              
                              SHOW_CUSTOM_ALERT(appNAME,@"No one is attending", self);
#pragma mark - CustomAlertDelegates
                              
                              
                              
                          }
                          else{
                              
                              [friendTV reloadData];
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
-(void)alertOkButtonClicked:(NSString *)response {
  
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

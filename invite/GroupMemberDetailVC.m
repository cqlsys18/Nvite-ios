//
//  GroupMemberDetailVC.m
//  invite
//
//  Created by AJ on 10/12/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "GroupMemberDetailVC.h"

@interface GroupMemberDetailVC ()
{
    IBOutlet UILabel *topLB;
    
    IBOutlet UITableView *memberTV;
    NSMutableArray *groupMemberArray;
}
@end

@implementation GroupMemberDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    topLB.text = _groupName;
    [self getMembers];
    
}
//MemberCell

- (void) getMembers {
    
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
                                       @"group_id":_groupID
                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"group_members"];
             
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
                          groupMemberArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [memberTV reloadData];
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
    
    return [groupMemberArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberCell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MemberCell"];
    }
    
    //cell.accessoryType        = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *userPicV     = [cell.contentView viewWithTag:1];
    UILabel *usernameLB       = [cell.contentView viewWithTag:2];
    UILabel *adminLB          = [cell.contentView viewWithTag:3];
    userPicV.layer.cornerRadius = userPicV.frame.size.width/2;
    userPicV.clipsToBounds  = YES;
    
    usernameLB.text = [[groupMemberArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    [userPicV setImageWithURL:[NSURL URLWithString:[[groupMemberArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
    
    if ([[NSString stringWithFormat:@"%@",[[groupMemberArray objectAtIndex:indexPath.row] objectForKey:@"is_admin"]] isEqualToString:@"1"]) {
        adminLB.hidden = NO;
        adminLB.text = @"Group Admin";
    }
    else{
        adminLB.hidden = YES;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


#pragma mark - button action

- (IBAction)backbtnaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)exitGroup_Action:(id)sender {
    
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
                                       @"group_id":_groupID
                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"left_group"];
             
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
                         
                              [CustomVW sharedInstance].delegate  = self;
                              
                              SHOW_CUSTOM_ALERT(appNAME,@"successfully left", self);

                             
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
#pragma mark - CustomAlertDelegates
-(void)alertOkButtonClicked:(NSString *)response {
             
[self.navigationController popViewControllerAnimated: YES];
    
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  OtherUserProfileVC.m
//  invite
//
//  Created by Ajay kumar on 9/18/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "OtherUserProfileVC.h"

@interface OtherUserProfileVC ()
{
    IBOutlet UITableView *recentTV;
    
    IBOutlet UIButton *unfrindBtn;
    IBOutlet UILabel *scoreLB;
    IBOutlet UIButton *addBtn;
    IBOutlet UIImageView *userPcV;
    IBOutlet UILabel *userNAmeLB;
    IBOutlet UILabel *toptitleLB;
}
@end

@implementation OtherUserProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    addBtn.hidden = YES;
    unfrindBtn.layer.cornerRadius = 20;
    unfrindBtn.clipsToBounds = YES;
    recentTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self friendProfileApiCalling];
}

-(void)viewWillLayoutSubviews{
    
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return eventArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherUserRecentCell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherUserRecentCell"];
    }
    
    cell.accessoryType     = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView*imgV       = [cell.contentView viewWithTag:1];
    UILabel*titleLB        = [cell.contentView viewWithTag:2];

    imgV.layer.cornerRadius = imgV.frame.size.width/2;
    cell.clipsToBounds =YES;
    
    imgV.layer.cornerRadius = imgV.frame.size.width/2;
    cell.clipsToBounds =YES;
    
    [imgV setImageWithURL:[NSURL URLWithString:[[eventArray objectAtIndex:indexPath.row] objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"BG_EVNT_IMG"]];
    
    titleLB.text    = [[eventArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailVC"];
//    [self.navigationController pushViewController:detail animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(void) friendProfileApiCalling{
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
                                       @"user_id": _friendId};
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"GetProfileDetails"];
             
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
                          userPcV.layer.cornerRadius = userPcV.frame.size.width/2;
                          userPcV.clipsToBounds = YES;
                          dict =[[dictionary objectForKey:@"body"] objectForKey:@"user"];
                          userNAmeLB.text =[dict objectForKey:@"username"];
                          
                         [userPcV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
                          toptitleLB.text =[dict objectForKey:@"username"];
                          scoreLB.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"score"]];
                          eventArray =[[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"body"] objectForKey:@"recent"]];
                         if (eventArray.count == 0) {
                              recentTV.hidden = YES;
                          }
                          else{
                              recentTV.hidden = NO;
                              [recentTV reloadData];
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

-(void)UnfrindApiCalling
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
                                       @"auth_token" :AUTH_TOKEN ,
                                       @"user_id": _friendId
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"remove_friend"];
             
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
                          UIAlertController* alert = [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:[dictionary objectForKey:@"message"]
                                                      preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction* button0 = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                                                    {
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                    }];
                          [alert addAction:button0];
                          [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - button action

- (IBAction)unfriendBtnAction:(id)sender
{
     NSString * msg = [NSString stringWithFormat:@"Are you sure you want to unfriend %@%@",[dict objectForKey:@"username"],@"?"];
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@""
                                message:msg
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self UnfrindApiCalling];
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)addcontactAction:(id)sender {
}
- (IBAction)backBtnaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ChatListVC.m
//  invite
//
//  Created by AJ on 10/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "ChatListVC.h"
#import "ChatVC.h"

@interface ChatListVC ()
{
    UIRefreshControl * refreshControl;
}

@end

@implementation ChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [chatListTV addSubview:refreshControl];
   
    
    if (groupbtn.selected==YES)
    {
        [refreshControl addTarget:self action:@selector(getGroupsList) forControlEvents:UIControlEventValueChanged];
    }
    else
    {
         [refreshControl addTarget:self action:@selector(getChatList) forControlEvents:UIControlEventValueChanged];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TokenChange:)
                                                 name:@"LOGIN"
                                               object:nil];
    chatListTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void) TokenChange:(NSNotification *)notification {
    
    // SET_AUTH_TOKEN(nil);
    UIStoryboard *story  = self.storyboard;
    UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.view.window.rootViewController = views;
    
}
-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = false;
     tableValue = @"Group";
    [self groupBtnAction:groupbtn];
   
   
}

- (void) getChatList {//get_groups
    
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
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"get_chat_events"];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                 [refreshControl endRefreshing];
                  [self getGroupsList];
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(message, self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          chatListArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [chatListTV reloadData];
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

- (void) getGroupsList {
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
        // SHOW_PROGRESS(@"Please Wait..");
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
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"get_groups"];
             
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
                          groupListArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [chatListTV reloadData];
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

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([tableValue isEqualToString:@"Event"]) {
        if ([chatListArray count] > 0) {
            tableView.backgroundView = nil;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            noDataLabel.font             = FONT_Medium(20);
            noDataLabel.textColor        = [UIColor darkGrayColor];
            noDataLabel.text             = @"No Recent Chats Available";
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tableView.backgroundView = noDataLabel;
        }
        return [chatListArray count];
    }
    else {
        if ([groupListArray count] > 0) {
            tableView.backgroundView = nil;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
            noDataLabel.font             = FONT_Medium(20);
            noDataLabel.textColor        = [UIColor darkGrayColor];
            noDataLabel.text             = @"No Groups Available";
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tableView.backgroundView = noDataLabel;
        }
        return [groupListArray count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableValue isEqualToString:@"Event"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLB         = [cell.contentView viewWithTag:2];
        UIImageView *userIMG    = [cell.contentView viewWithTag:1];
        
        if ([[NSString stringWithFormat:@"%@",[[chatListArray objectAtIndex:indexPath.row] objectForKey:@"unseen_msg"]] isEqualToString:@"0"]) {
            nameLB.text = [NSString stringWithFormat:@"%@",[[[chatListArray objectAtIndex:indexPath.row] objectForKey:@"name"] capitalizedString]];
        }
        else{
            [self showDataOnActivityLabel:nameLB Activitystring:[[[chatListArray objectAtIndex:indexPath.row] objectForKey:@"name"] capitalizedString] withString:[NSString stringWithFormat:@"(%@)",[[chatListArray objectAtIndex:indexPath.row] objectForKey:@"unseen_msg"]]];
             // nameLB.text = [NSString stringWithFormat:@"%@ (%@)",[[[chatListArray objectAtIndex:indexPath.row] objectForKey:@"name"] capitalizedString],[[chatListArray objectAtIndex:indexPath.row] objectForKey:@"unseen_msg"]];
        }
      
        
        [userIMG setImageWithURL:[NSURL URLWithString:[[chatListArray objectAtIndex:indexPath.row] objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@""]];
        
        userIMG.layer.cornerRadius  = userIMG.frame.size.width/2.0f;
        userIMG.clipsToBounds       = true;
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell"];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatListCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLB         = [cell.contentView viewWithTag:2];
        UIImageView *userIMG    = [cell.contentView viewWithTag:1];
        
          if ([[NSString stringWithFormat:@"%@",[[groupListArray objectAtIndex:indexPath.row] objectForKey:@"unseen_msg"]] isEqualToString:@"0"]) {
              nameLB.text = [NSString stringWithFormat:@"%@",[[[groupListArray objectAtIndex:indexPath.row] objectForKey:@"name"] capitalizedString]];
          }
          else{

              [self showDataOnActivityLabel:nameLB Activitystring:[[[groupListArray objectAtIndex:indexPath.row] objectForKey:@"name"] capitalizedString] withString:[NSString stringWithFormat:@"(%@)",[[groupListArray objectAtIndex:indexPath.row] objectForKey:@"unseen_msg"]]];
//            nameLB.text = [NSString stringWithFormat:@"%@ (%@)",[[[groupListArray objectAtIndex:indexPath.row] objectForKey:@"name"] capitalizedString],[[groupListArray objectAtIndex:indexPath.row] objectForKey:@"unseen_msg"]];
          }
        [userIMG setImageWithURL:[NSURL URLWithString:[[groupListArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@""]];
        
        userIMG.layer.cornerRadius  = userIMG.frame.size.width/2.0f;
        userIMG.clipsToBounds       = true;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([tableValue isEqualToString:@"Event"]) {
        ChatVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        view.dataDict   = [[NSMutableDictionary alloc] initWithDictionary:[chatListArray objectAtIndex:indexPath.row]];
        view.title      = @"Event";
        [self.navigationController pushViewController:view animated:true];
    }
    else {
        
        ChatVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        view.dataDict   = [[NSMutableDictionary alloc] initWithDictionary:[groupListArray objectAtIndex:indexPath.row]];
        view.title      = @"Group";
        [self.navigationController pushViewController:view animated:true];
    }
        

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *localView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
//    localView.backgroundColor =UIColorFromRGBAlpha(240, 240, 240, 1);
//
//    UILabel *artistlbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, localView.frame.size.width, 35)];
//    artistlbl.font      = FONT_Medium(13);
//    artistlbl.textAlignment           = NSTextAlignmentLeft;
//
//    if (section == 0)  {
//        artistlbl.text = @"Groups";
//    }
//    else {
//        artistlbl.text = @"Events";
//    }
//    [localView addSubview:artistlbl];
//
//    UIView *LineV = [[UIView alloc] initWithFrame:CGRectMake(0,localView.frame.size.height-1, localView.frame.size.width, 1)];
//
//    LineV.backgroundColor = [UIColor lightGrayColor];
//    [localView addSubview:LineV];
//
//
//    return localView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 35;
//}


#pragma mark - UIButtonActions

- (IBAction)menuBtnAction:(UIButton*)sender {
    if (!sender.selected) {
        sender.selected= YES;
        menuV.hidden = NO;
    }
    else{
        sender.selected= NO;
        menuV.hidden = YES;
    }
}
- (IBAction)createEventBtnAction:(id)sender {
    
    UIViewController *createEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateGroupVC"];
    self.tabBarController.tabBar.hidden = true;
    [self.navigationController pushViewController:createEvent animated:YES];
}

- (void) showDataOnActivityLabel : (UILabel *)lbl
                  Activitystring : (NSString *) Activitystring withString : (NSString *) eventnamestring {
    
    NSString *tailNoStr = [NSString stringWithFormat:@"%@%@%@  %@%@%@",@"<span style ='color:#4C4C4C ;font-family:AvenirNext-Medium; font-size:17px;'>",Activitystring,@"</span>",@"<span style ='color:#FF4801 ;font-family:AvenirNext-Medium; font-size:17px;'>", eventnamestring, @"</span>"];
    
    NSError *err = nil;
    lbl.attributedText = [[NSAttributedString alloc] initWithData: [tailNoStr dataUsingEncoding:NSUTF8StringEncoding] options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                               documentAttributes: nil error: &err];
    
    
}
- (IBAction)groupBtnAction:(id)sender {
    
    tableValue = @"Group";
    groupbtn.selected       = true;
    eventBtn.selected       = false;
    eventBtn.backgroundColor = UIColorFromRGBAlpha(240, 240, 240, 1);
    groupbtn.backgroundColor      = UIColorFromRGBAlpha(255, 72, 1, 1);
    [self getGroupsList];
}

- (IBAction)eventBtnAction:(id)sender {
    
    tableValue = @"Event";
    groupbtn.selected       = false;
    eventBtn.selected       = true;
    groupbtn.backgroundColor      = UIColorFromRGBAlpha(240, 240, 240, 1);
    eventBtn.backgroundColor      = UIColorFromRGBAlpha(255, 72, 1, 1);
    [self getChatList];
    
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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

//
//  PublicEventVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "PublicEventVC.h"
#import "PublicEventTVCell.h"
#import "EventDetailVC.h"
#import "ChatVC.h"

@interface PublicEventVC ()
{
    UIRefreshControl * refreshControl;
    
}

@end

@implementation PublicEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [eventTV addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(getEvents) forControlEvents:UIControlEventValueChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TokenChange:)
                                                 name:@"LOGIN"
                                               object:nil];
    eventTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void) TokenChange:(NSNotification *)notification {
    
    // SET_AUTH_TOKEN(nil);
    UIStoryboard *story  = self.storyboard;
    UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.view.window.rootViewController = views;
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [self getEvents];
}

#pragma mark
#pragma mark api calling


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
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"event_listing"];
             
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
    
    if ([eventsArray count] > 0) {
        tableView.backgroundView = nil;
    }
    else
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 50)];
        noDataLabel.font             = FONT_Medium(20);
        noDataLabel.textColor        = [UIColor darkGrayColor];
        noDataLabel.text             = @"No Nearby Public Events Found";
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
    }
    return [eventsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicEventTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublicEventCell"];
    if (cell == nil) {
        
        cell = [[PublicEventTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PublicEventCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *dict = [eventsArray objectAtIndex:indexPath.row];
    
    [cell.EventImageV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"BG_EVNT_IMG"]];
    cell.eventNameLB.text   = [dict objectForKey:@"name"];
    cell.detailLB.text      = [dict objectForKey:@"description"];
    
    [cell.locationBtn setTitle:[dict objectForKey:@"address"] forState:UIControlStateNormal];
    [cell.messageBtn setTitle:[NSString stringWithFormat:@"%@ message",[dict objectForKey:@"chat_count"]] forState:UIControlStateNormal];
    cell.commentBtn.tag = indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventDetailVC *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"EventDetailVC"];
    detail.title = @"Public";
    detail.detailsDict  = [[NSMutableDictionary alloc] initWithDictionary:[eventsArray objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)shareBtnaction:(id)sender {
    
    
}

- (IBAction)chatBtnAction:(UIButton *)sender {
    if ([[[eventsArray objectAtIndex:sender.tag]objectForKey:@"attend"]integerValue] == 1) {
        ChatVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        view.dataDict = [[NSMutableDictionary alloc] initWithDictionary:[eventsArray objectAtIndex:sender.tag]];
        view.title  = @"Event";
        [self.navigationController pushViewController:view animated:true];
    }
    else{
        SHOW_CUSTOM_ALERT(appNAME, @"Please accept invitation request of event to continue chat", self)
    }
}

#pragma mark-

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

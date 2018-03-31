//
//  AttendingVC.m
//  invite
//
//  Created by Ajay kumar on 9/11/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "AttendingVC.h"
#import "MyFriendList.h"
@interface AttendingVC ()
{
    IBOutlet UIButton *goingBtn;
    
    IBOutlet UIButton *outBtn;
    IBOutlet UIButton *attendingBtn;
    IBOutlet UILabel *femaleLB;
    IBOutlet UILabel *maleLB;
    IBOutlet UILabel *attendingLB;
    IBOutlet UIButton *centerAttendBtn;
    IBOutlet UIButton *invitedBtn;
}
@end

@implementation AttendingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", _dataDict);
    [self showDataOnView];
}

- (void) showDataOnView {

    maleLB.text     = [NSString stringWithFormat:@"%@%@",[_dataDict objectForKey:@"male"],@"% Male"];
    femaleLB.text   = [NSString stringWithFormat:@"%@%@",[_dataDict objectForKey:@"female"],@"% Female"];
    attendingLB.text    = [NSString stringWithFormat:@"%@ Attending",[_dataDict objectForKey:@"total_attend"]];
    
    NSString *eventStatus = [NSString stringWithFormat:@"%@", [_dataDict objectForKey:@"attend"]];
    if ([[NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"user_id"]] isEqualToString: GET_USER_ID])  {
        acceptBtn.hidden       = YES;
        declineBtn.hidden      = YES;
        goingNotGoingLB.hidden = YES;
    }
    else{
        if ([eventStatus isEqualToString:@"0"]) {
            
            goingNotGoingLB.hidden  = YES;
            acceptBtn.hidden        = false;
            declineBtn.hidden       = false;
        }
        else {
            goingNotGoingLB.hidden  = YES;
            acceptBtn.hidden        = true;
            declineBtn.hidden       = true;
            
            /*if ([eventStatus isEqualToString:@"1"]) {
                goingNotGoingLB.text = @"You have accepted the invitation";
            }
            else {
                goingNotGoingLB.text = @"You have declined the invitation";
            }*/
        }

    }
    
    if ([self.title isEqualToString:@"Public"]) {
        invitedBtn.hidden       =  YES;
        attendingBtn.hidden     =  YES;
         centerAttendBtn.hidden =   NO;
    }
    else{
        invitedBtn.hidden       =  NO;
        attendingBtn.hidden     =  NO;
        centerAttendBtn.hidden  = YES;
    }
    values = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"male"]] ,[NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"female"]],@"0",@"0", nil];
    
   // XYPieChart *pieChart   = [cell.contentView viewWithTag:4];
    
    [pieChart setDataSource:self];
    [pieChart setStartPieAngle:M_PI_2];
    [pieChart setAnimationSpeed:1.0];
    [pieChart setLabelFont:FONT_Medium(12)];
    //[pieChart setLabelRadius:160];
    
    [pieChart setShowPercentage:YES];
    [pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [pieChart setPieCenter:CGPointMake(pieChart.frame.size.width/2, pieChart.frame.size.height/2)];
    [pieChart setUserInteractionEnabled:NO];
    [pieChart setLabelShadowColor:[UIColor blackColor]];
    
    [pieChart.layer setCornerRadius:90];
    
    _sliceColors   = [NSArray arrayWithObjects:
                      UIColorFromRGBAlpha(255, 72, 1, 1),
                      [UIColor lightGrayColor],nil];
    
    [pieChart reloadData];
    
   

}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return 4;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[values objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [_sliceColors objectAtIndex:(index % _sliceColors.count)];
}


#pragma mark - Button action

- (IBAction)invitebtnAction:(id)sender {
    MyFriendList *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFriendList"];
    view.eventId = [_dataDict objectForKey:@"id"];
    view.title  = @"Invited";
    [self.navigationController pushViewController:view animated:true];
    
}

- (IBAction)attendingbtnaction:(id)sender {
    MyFriendList *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFriendList"];
    view.eventId = [_dataDict objectForKey:@"id"];
    view.title  = @"Attending";
    [self.navigationController pushViewController:view animated:true];
    
}

- (IBAction)acceptAction:(UIButton*)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:appNAME
                                          message:@"Do you want your name to be added to the guest list?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"YES"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                  [self attendOrNOt:@"1" seen:@"1"];
                               }];
    UIAlertAction *noAction = [UIAlertAction
                               actionWithTitle:@"NO"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                  [self attendOrNOt:@"1" seen:@"0"];
                               }];
    
    [alertController addAction:okAction];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

    }
- (IBAction)declineAction:(UIButton*)sender {
  
    [self attendOrNOt:@"2" seen:@""];
}

- (IBAction)backBtnaction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - apiCallForAttending

- (void) attendOrNOt: (NSString *)status seen :(NSString *) _seen {
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
                                       @"event_id" : [_dataDict objectForKey:@"id"]};
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"attend_event"];
             
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
                          [self.navigationController popToRootViewControllerAnimated:true];
                                                 
                          
                      
                          
                         
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

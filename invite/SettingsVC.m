//
//  SettingsVC.m
//  AddChats
//
//  Created by Ajay kumar on 9/8/17.
//  Copyright © 2017 Ajay kumar. All rights reserved.
//

#import "SettingsVC.h"
#import "SettingsCell.h"
@interface SettingsVC ()
{
    NSArray *profilearray;
    NSArray *appArray;
    IBOutlet UITableView *settingTV;
}
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(TokenChange:)
                                                 name:@"LOGIN"
                                               object:nil];
    profilearray = [NSArray arrayWithObjects:@"Change Password",@"Friends List",@"Help",@"Logout", nil];
   
    settingTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void) TokenChange:(NSNotification *)notification {
    
    // SET_AUTH_TOKEN(nil);
    UIStoryboard *story  = self.storyboard;
    UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
    self.view.window.rootViewController = views;
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = false;
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [profilearray count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    if (cell == nil) {
        
        cell = [[SettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];
    }
    
  
        cell.titleLB.text = [profilearray objectAtIndex:indexPath.row];


    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.row == 0) {
        
        UIStoryboard *story  = self.storyboard;
        UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"ChangePasswordVC"];
        
        [self.navigationController pushViewController:views animated:YES];
    }
    else if (indexPath.row ==1){
        UIViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFriendList"];
        [self.navigationController pushViewController:detail animated:YES];

    }
      else if (indexPath.row == 3) {
          
          UIAlertController* alert = [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Are you sure you would like to logout?"
                                      preferredStyle:UIAlertControllerStyleAlert];
          
          UIAlertAction* button0 = [UIAlertAction
                                    actionWithTitle:@"Logout"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        SET_USER_ID(nil);
                                        SET_AUTH_TOKEN(nil);
                                        UIStoryboard *story  = self.storyboard;
                                        UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
                                        self.view.window.rootViewController = views;
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
   

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 50;
}

- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) logoutApicalling {
    
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
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"logout"];
             
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
                          SET_USER_ID(nil);
                          SET_AUTH_TOKEN(nil);
                          UIStoryboard *story  = self.storyboard;
                          UIViewController *views        = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
                            self.view.window.rootViewController = views;
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

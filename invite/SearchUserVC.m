//
//  SearchUserVC.m
//  invite
//
//  Created by Ajay kumar on 9/18/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "SearchUserVC.h"


@interface SearchUserVC ()
{
    
    IBOutlet UITableView *serchTV;
    IBOutlet UISearchBar *searchBaritem;
}
@end

@implementation SearchUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userid =@"";
    selectedArray             = [[NSMutableArray alloc] init];
    //contactsArray           = [[NSMutableArray alloc] init];
    invitesTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    searchBaritem.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
}




#pragma mark -

/*-(void) getcontactList {
    
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted == YES) {
            
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                
                for (CNContact *contact in cnContacts) {
                    
                    for (CNLabeledValue *label in contact.phoneNumbers) {
                        
                        NSString *phone = [label.value stringValue];
                        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0987654321"] invertedSet];
                        NSString *resultString = [[phone componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
                        
                        NSString *name = [NSString stringWithFormat:@"%@ %@",contact.givenName, contact.familyName];
                        NSCharacterSet *notAllowedChars1 = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz0987654321"] invertedSet];
                        NSString *resultString1 = [[name componentsSeparatedByCharactersInSet:notAllowedChars1] componentsJoinedByString:@""];
                        
                        NSDictionary *dict = @{@"phone":resultString, @"name": resultString1};
                        
                        [contactsArray addObject:dict];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    selectedArray = [[NSMutableArray alloc] initWithArray:contactsArray];
                    
                    [invitesTV reloadData];
                });
            }
        }
    }];
}
*/

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [selectedArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUserListCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchUserListCell"];
    }
    
    cell.selectionStyle         = UITableViewCellSelectionStyleGray;
    
    UIImageView*userimgV        = [cell.contentView viewWithTag:1];
    UILabel*nameLB              = [cell.contentView viewWithTag:2];
    UILabel * plusLB            = [cell.contentView viewWithTag:3];
    nameLB.text     = [[selectedArray objectAtIndex:indexPath.row] objectForKey:@"username"];
    
    if ([[NSString stringWithFormat:@"%@",[[selectedArray objectAtIndex:indexPath.row] objectForKey:@"is_friend"]] isEqualToString:@"0"]) {
        plusLB.hidden = NO;
        
    }
    else{
        plusLB.hidden = YES;
    }
    
    userimgV.layer.cornerRadius     = userimgV.frame.size.width/2;
    cell.clipsToBounds              = YES;
    
      [userimgV setImageWithURL:[NSURL URLWithString:[[selectedArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([[NSString stringWithFormat:@"%@",[[selectedArray objectAtIndex:indexPath.row] objectForKey:@"is_friend"]] isEqualToString:@"0"]){
        
        userid =[NSString stringWithFormat:@"%@",[[selectedArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSString * msg = [NSString stringWithFormat:@"Are you sure you want to send a friend request to %@",[[selectedArray objectAtIndex:indexPath.row] objectForKey:@"username"]];
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@""
                                    message:msg
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* button0 = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                    [self addFriendApiCalling];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma mark - MessageComposerDelegates

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ButtonAction
- (IBAction)backBtnaction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark searchDelegates


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //selectedArray   = [[NSMutableArray alloc] initWithArray:contactsArray];
    //[invitesTV reloadData];
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchApiCalling];
    [searchBar resignFirstResponder];
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
   
    return YES;
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //selectedArray = [[NSMutableArray alloc] init];
    
    /*for (NSDictionary *dd in contactsArray) {
        
        NSString *myString = [dd objectForKey:@"name"];
        NSRange rangeValue = [myString rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
        
        if (rangeValue.length > 0)
        {
            [selectedArray addObject:dd];
        }

    }
    
    [invitesTV reloadData];*/
    return YES;
}

-(void) searchApiCalling{
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
                                       @"username" :searchBaritem.text
                                           };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"searchUser"];
             
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
                          selectedArray =[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [serchTV reloadData];
                          
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

-(void) addFriendApiCalling{
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
                                       @"user_id" :userid
                                       };
             
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"send_friend_request"];
             
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
                          //selectedArray =[[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [CustomVW sharedInstance].delegate  = self;

                          SHOW_CUSTOM_ALERT(appNAME,@"Friend request sent successfully", self);
                          
                          [serchTV reloadData];
                          
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
    
    [self searchApiCalling];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

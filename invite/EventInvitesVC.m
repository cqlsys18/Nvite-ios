//
//  EventInvitesVC.m
//  invite
//
//  Created by AJ on 9/29/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "EventInvitesVC.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/CNContactStore.h>
#import <ContactsUI/ContactsUI.h>

@interface EventInvitesVC ()

@end

@implementation EventInvitesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedArray           = [[NSMutableArray alloc] init];
    contactsArray           = [[NSMutableArray alloc] init];
    invitesTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getcontactList];
    
}

#pragma mark -

-(void) getcontactList {
    
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
                    
                    [self eventInviteApi];
                });
            }
        }
    }];
}

- (void) eventInviteApi {

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
          
             NSError *error;
             NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contactsArray options:NSJSONWritingPrettyPrinted error:&error];
             NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             
             result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
             
             result = [result stringByReplacingOccurrencesOfString:@"\u00a0" withString:@" "];
             
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       @"contact":result
                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"contact_list"];
             
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
                          usersArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          for (int i = 0; i < usersArray.count; i++) {
                              if ([[[usersArray objectAtIndex:i]objectForKey:@"id"] integerValue] == [GET_USER_ID integerValue]) {
                                  [usersArray removeObjectAtIndex:i];
                              }
                              
                          }
                          [invitesTable reloadData];
                          
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


#pragma mark - UITableViewDelegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return usersArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    
    UILabel *nameLB = [cell.contentView viewWithTag:2];
    UILabel *phonLB = [cell.contentView viewWithTag:3];
    UIImageView *slectIMG   = [cell.contentView viewWithTag:10];
    
    
    nameLB.text     = [usersArray[indexPath.row] objectForKey:@"username"];
    phonLB.text     = [usersArray[indexPath.row] objectForKey:@"phone"] == nil ? @"" : [usersArray[indexPath.row] objectForKey:@"phone"];
    UIImageView *userIMG   = [cell.contentView viewWithTag:1];
    
    
    userIMG.layer.cornerRadius =userIMG.frame.size.width/2;
    userIMG.clipsToBounds = YES;
    
    [userIMG setImageWithURL:[NSURL URLWithString:[[usersArray objectAtIndex:indexPath.row] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"USER_IMG"]];
    

    if ([selectedArray containsObject:[usersArray objectAtIndex:indexPath.row]]) {
        slectIMG.highlighted = true;
    }
    else {
        slectIMG.highlighted = false;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([selectedArray containsObject:[usersArray objectAtIndex:indexPath.row]]) {
        [selectedArray removeObject:[usersArray objectAtIndex:indexPath.row]];
    }
    else {
        [selectedArray addObject:[usersArray objectAtIndex:indexPath.row]];
    }
    
    [tableView reloadData];
}

#pragma mark - UIButtonActions

- (IBAction)backBTn_Action:(id)sender {
    
    [self.navigationController popViewControllerAnimated:true];
}


- (IBAction)createEventBtn:(id)sender {
    
    if (selectedArray.count == 0) {
        SHOW_NETWORK_ERROR(@"Please select atleast one of your Friends", self);
    }
    else {
        
        NSMutableArray *contacts = [[NSMutableArray alloc] init];
        for (NSDictionary *dd in selectedArray) {
            [contacts addObject:[dd objectForKey:@"id"]];
        }
        
        [_dataDict setObject:[contacts componentsJoinedByString:@","] forKey:@"contact"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@", appURL,@"create_event"];
        [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
         {
             
             if (responseObject == false)
             {
                 SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
             }
             else
             {
                 
                 [[ApiManager sharedInstance] apiCallWithImage:urlString parameterDict:_dataDict imageDataDictionary:_imgDataDict  CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                     
                     HIDE_PROGRESS;
                     if (success == false)
                     {
                         SHOW_NETWORK_ERROR(message, self);
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary])
                         {
                             
                             UIAlertController *alertController = [UIAlertController
                                                                   alertControllerWithTitle:@""
                                                                   message:@"Event Created Successfully!"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *okAction = [UIAlertAction
                                                        actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action)
                                                        {
                                                            [[IQKeyboardManager sharedManager] setEnable:YES];
                                                            [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
                                                            [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:YES];
                                                            
                                                            self.tabBarController.tabBar.hidden = false;
                                                            [self.navigationController popToRootViewControllerAnimated:true];
                                                        }];
                             
                             [alertController addAction:okAction];
                             
                             [self presentViewController:alertController animated:YES completion:nil];
                             
                         }
                         else
                         {
                             SHOW_NETWORK_ERROR(@"Error Occured While Creating Event!!", self);
                         }
                     }
                 }];
             }
             
         }];

    }
    
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

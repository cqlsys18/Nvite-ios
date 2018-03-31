//
//  InvitesVC.h
//  invite
//
//  Created by AJ on 10/5/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/CNContactStore.h>
#import <ContactsUI/ContactsUI.h>

@interface InvitesVC : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *invitesTable;
    
    NSMutableArray *contactsArray;
    NSMutableArray *usersArray;
    
    NSMutableArray *selectedArray;
}

@property (strong, nonatomic) NSMutableDictionary *dataDict;

@end

//
//  SearchUserVC.h
//  invite
//
//  Created by Ajay kumar on 9/18/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/CNContactStore.h>
#import <ContactsUI/ContactsUI.h>
#import <MessageUI/MessageUI.h> 

@interface SearchUserVC : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate,UISearchBarDelegate>
{
    IBOutlet UITableView *invitesTV;
    
    //NSMutableArray *contactsArray;
    NSMutableArray *usersArray;
    
    NSMutableArray *selectedArray;
    NSString *userid;
    
}
@end

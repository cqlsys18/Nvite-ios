//
//  EventInvitesVC.h
//  invite
//
//  Created by AJ on 9/29/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventInvitesVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *invitesTable;
    
    NSMutableArray *contactsArray;
    NSMutableArray *usersArray;
    
    NSMutableArray *selectedArray;
}

@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property (strong, nonatomic) NSMutableDictionary *imgDataDict;
@end

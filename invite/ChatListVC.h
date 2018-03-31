//
//  ChatListVC.h
//  invite
//
//  Created by AJ on 10/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSString *tableValue;
    IBOutlet UIButton *eventBtn;
    IBOutlet UIButton *groupbtn;
    IBOutlet UITableView *chatListTV;
    IBOutlet UIView *menuV;
    
    NSMutableArray *chatListArray;
    NSMutableArray *groupListArray;
}
@end

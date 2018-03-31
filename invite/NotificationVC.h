//
//  NotificationVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
    IBOutlet UITableView *notificationTV;
    
    NSMutableArray *notificationsArray;
    
}
@end

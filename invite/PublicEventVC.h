//
//  PublicEventVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicEventVC : UIViewController
{
    IBOutlet UITableView *eventTV;
    
    NSMutableArray *eventsArray;
}
@end

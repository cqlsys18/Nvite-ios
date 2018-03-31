//
//  ProfileVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    IBOutlet UITableView *recentEventTV;
    IBOutlet UIButton *editProfileBtn;
    IBOutlet UILabel *scoreLB;
    IBOutlet UILabel *lastNAmeLB;
    IBOutlet UILabel *userNAmeLB;
    IBOutlet UIImageView *userProfileImgV;
    
    IBOutlet UIButton *recentBtn;
    IBOutlet UIButton *myEventsBTN;
    
    NSMutableArray *eventArray;
}
@end

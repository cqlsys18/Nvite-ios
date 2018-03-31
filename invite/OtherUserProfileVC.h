//
//  OtherUserProfileVC.h
//  invite
//
//  Created by Ajay kumar on 9/18/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserProfileVC : UIViewController
{
    NSMutableArray *eventArray;
    NSDictionary *dict;
}
@property(strong,nonatomic) NSString *friendId;
@end

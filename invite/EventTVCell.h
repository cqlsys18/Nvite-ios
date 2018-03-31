//
//  EventTVCell.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthConst;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *attendingWidthConst;
@property (strong, nonatomic) IBOutlet UILabel *dateLB;
@property (strong, nonatomic) IBOutlet UIButton *locationLB;
@property (strong, nonatomic) IBOutlet UIView *attendingV;
@property (strong, nonatomic) IBOutlet UILabel *UserNameLB;
@property (strong, nonatomic) IBOutlet UILabel *unreadCountLB;

@property (strong, nonatomic) IBOutlet UILabel *eventNAmeLB;
@property (strong, nonatomic) IBOutlet UIImageView *eventImgV;
@property (strong, nonatomic) IBOutlet UIButton *attendBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@end

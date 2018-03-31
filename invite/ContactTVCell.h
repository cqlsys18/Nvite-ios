//
//  ContactTVCell.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTVCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userPicV;
@property (strong, nonatomic) IBOutlet UILabel *nameLB;
@property (strong, nonatomic) IBOutlet UILabel *numberLB;
@property (strong, nonatomic) IBOutlet UIButton *inviteBtn;

@end

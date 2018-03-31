//
//  CreateUsernameVC.h
//  invite
//
//  Created by AJ on 9/26/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateUsernameVC : UIViewController
{
    IBOutlet UITextField *usernameTF;
    
}
@property(strong,nonatomic) NSMutableDictionary *signupParamDict;
@property(strong,nonatomic) NSMutableDictionary *imgDict;
@end

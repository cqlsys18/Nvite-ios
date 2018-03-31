//
//  ChangePassVC.h
//  invite
//
//  Created by AJ on 9/22/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePassVC : UIViewController
{    
    IBOutlet UITextField *confirmPasswordTF;
    IBOutlet UITextField *passwordTF;
}
@property (strong, nonatomic) NSString *emailStr;
@end

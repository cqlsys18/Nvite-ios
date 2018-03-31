//
//  PhoneVC.h
//  invite
//
//  Created by Ajay kumar on 9/20/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneVC : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property(strong,nonatomic) NSMutableDictionary *signupParamDict;
@property(strong,nonatomic) NSMutableDictionary *imgDict;
@end

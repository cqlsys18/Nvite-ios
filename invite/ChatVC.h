//
//  ChatVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    IBOutlet UITableView *chatTV;
    
    IBOutlet UIView *bottomV;
    IBOutlet UITextView *messageV;
    
    IBOutlet NSLayoutConstraint *bottomConstraint;
    
    IBOutlet UILabel *nameLB;
    IBOutlet UIImageView *userIMG;
    
    NSArray *chatArray;
    NSData *imageData;
    
    NSMutableDictionary *apiCallDict;
    NSString *viewTitle;
    
}

@property (strong, nonatomic) NSMutableDictionary *dataDict;
@end

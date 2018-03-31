//
//  CreateGroupVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateGroupVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    
    IBOutlet UIImageView *groupImageV;
    IBOutlet UICollectionView *personCollectionV;
    IBOutlet UITextField *groupNAmeTF;
    
    NSData *imageData;
    
    NSMutableArray *selectedUsers;
    NSMutableArray *usersArray;
}
@end

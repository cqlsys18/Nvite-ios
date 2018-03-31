//
//  HomeVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationVC.h"
@interface HomeVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
 
    NSMutableArray *eventsArray;
    NSMutableArray *savedEventsArray;
}
@end

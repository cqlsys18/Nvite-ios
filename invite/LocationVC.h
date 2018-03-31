//
//  LocationVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface LocationVC : UIViewController
{
    
    IBOutlet UIButton *messageBtn;
    IBOutlet UILabel *eventDetailLB;
    IBOutlet UILabel *eventNAmeLB;
    IBOutlet UIImageView *eventImgV;
   
    IBOutlet MKMapView *mapV;
}

@property (strong, nonatomic) NSMutableDictionary *detailsDict;

@end

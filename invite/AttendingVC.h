//
//  AttendingVC.h
//  invite
//
//  Created by Ajay kumar on 9/11/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface AttendingVC : UIViewController <XYPieChartDataSource,XYPieChartDelegate>
{
    NSArray *_sliceColors;
    NSArray *values;
    
    IBOutlet UILabel *goingNotGoingLB;
    
    IBOutlet UIButton *declineBtn;
    IBOutlet UIButton *acceptBtn;
    IBOutlet XYPieChart *pieChart;
}

@property (strong, nonatomic) NSMutableDictionary *dataDict;

@end

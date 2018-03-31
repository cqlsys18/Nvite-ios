//
//  CreateEventVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>

@interface CreateEventVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UISearchDisplayDelegate,GMSAutocompleteTableDataSourceDelegate,UISearchBarDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>
{
    
    IBOutlet UIButton *cameraBtn;
    IBOutlet UITextView *infoTV;
    IBOutlet UITextField *locationTF;
    IBOutlet UITextField *endTimeTF;
    IBOutlet UITextField *startTimeTF;
    IBOutlet UITextField *dateTF;
    IBOutlet UITextField *eventTypeTF;
    IBOutlet UITextField *eventNAmeTF;
    IBOutlet UIImageView *eventImageV;
 
    IBOutlet UIButton *createEventBTn;
    
    IBOutlet UITextField *eventSubType;
    IBOutlet NSLayoutConstraint *topSpaceDateTFConst;
    IBOutlet UIView *eventTypeV;
    
    NSString *selectedTypStr;
    
    NSArray *typeArray;
    NSArray *subTypeArray;
    
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    UIDatePicker *endTimePicker;
    
    NSString *dateStr;
    NSString *timeStr;
    NSString *endTimeStr;
    
    NSString *locationLati;
    NSString *locationLongi;
    NSString *city;
    
    NSData *imgData;
}

@property (strong, nonatomic)UISearchBar *searchBar;
@property (strong, nonatomic)UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic)GMSAutocompleteTableDataSource *tableDataSource;
@end

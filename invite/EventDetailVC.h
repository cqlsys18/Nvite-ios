//
//  EventDetailVC.h
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface EventDetailVC : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    ////// make bar code  /////
    
    IBOutlet UIView *popv;
    IBOutlet UIImageView *QRImgV;
    IBOutlet UIView *QrPopUpV;
    
    /// scan bar code ////
    
    IBOutlet UIView *scanQR_CodePopUp;
    IBOutlet UIView *scannerPop;
    
    //////  pop up name ////
    
    IBOutlet UIView *popUpView;
    IBOutlet UIView *eventPopUpView;
    IBOutlet UILabel *eventstatusLBL;
    IBOutlet UILabel *eventNamerLBL;
    IBOutlet UIButton *okBtn;
    
    
    IBOutlet UIImageView *eventImgV;
    IBOutlet UIButton *toplocationBTn;
    IBOutlet UILabel  *userNameLB;
    IBOutlet UILabel  *infoTV;
    IBOutlet UIButton *locationBtn;
    IBOutlet UILabel  *eventNAmeLB;
    IBOutlet UILabel  *dateLB;
    IBOutlet UIButton *attendBtn;
    IBOutlet UIButton *saveEventBtn;
}
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) NSMutableDictionary *detailsDict;
-(BOOL)startReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

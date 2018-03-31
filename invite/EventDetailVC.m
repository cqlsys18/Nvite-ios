//
//  EventDetailVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "EventDetailVC.h"
#import "InvitesVC.h"
#import "ChatVC.h"
#import "AttendingVC.h"
#import "LocationVC.h"

@interface EventDetailVC ()
{
    IBOutlet UIButton *viteBtn;
    IBOutlet UIButton *plusbtn;
    NSString * qrType;
    NSString *barcodeString;
}
@end

@implementation EventDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
      _isReading = NO;
     _captureSession = nil;
    viteBtn.layer.cornerRadius    = 20;
    viteBtn.clipsToBounds         = true;
    
    popv.layer.cornerRadius = 1;
    popv.layer.borderColor = [[UIColor orangeColor]CGColor];
    popv.layer.borderWidth = 2;
    popv.clipsToBounds = YES;
    
    scannerPop.layer.cornerRadius = 1;
    scannerPop.layer.borderColor = [[UIColor orangeColor]CGColor];
    scannerPop.layer.borderWidth = 2;
    scannerPop.clipsToBounds = YES;
    
    popUpView.layer.cornerRadius = 1;
    popUpView.layer.borderColor = [[UIColor orangeColor]CGColor];
    popUpView.layer.borderWidth = 2;
    popUpView.clipsToBounds = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self showDataOnScreen];
}

- (void) showDataOnScreen {
    
    NSLog(@"UserID: %@",GET_USER_ID);
    NSLog(@"dict %@",_detailsDict);
    
    if ([[_detailsDict objectForKey:@"user_id"] integerValue] == [GET_USER_ID integerValue])
    {
        qrType = @"SCAN";
        [viteBtn setTitle:@"SCAN" forState:UIControlStateNormal];
    }
    else
    {
        qrType = @"VITE";
        [viteBtn setTitle:@"VITE" forState:UIControlStateNormal];
    }
    
    if ([[_detailsDict objectForKey:@"event_type"] isEqualToString:@"1"]) {
        [plusbtn setHidden:true];
    }
    else if ([[_detailsDict objectForKey:@"event_type"] isEqualToString:@"4"]) {
        [plusbtn setHidden:true];
    }
    else if ([[_detailsDict objectForKey:@"event_type"] isEqualToString:@"2"])
    {
        BOOL is_creator = false;
        BOOL is_invite_sent = false;
        
        if ([[_detailsDict objectForKey:@"user_id"] integerValue]!= [GET_USER_ID integerValue]) {
            
            for (int i= 0; i<[[_detailsDict objectForKey:@"invition"] count]; i++) {
//
//                if ([[[[_detailsDict objectForKey:@"invition"]objectAtIndex:i] objectForKey:@"senderId"] integerValue] == [GET_USER_ID integerValue])
//                {
//                    is_creator = false;
//                }
              // else
                if ([[[[_detailsDict objectForKey:@"invition"]objectAtIndex:i] objectForKey:@"senderId"] integerValue] == [[_detailsDict objectForKey:@"user_id"] integerValue] && [[[[_detailsDict objectForKey:@"invition"]objectAtIndex:i] objectForKey:@"userId"] integerValue]  == [GET_USER_ID integerValue]) {
                    is_creator = true;
                    
                }
                if ([[[[_detailsDict objectForKey:@"invition"]objectAtIndex:i] objectForKey:@"senderId"] integerValue] == [GET_USER_ID integerValue]) {
                    is_invite_sent = true;
                }
            }
            if (is_creator && !is_invite_sent)
            {
                  [plusbtn setHidden:false];
            }
            else if (is_invite_sent == true)
            {
                [plusbtn setHidden:YES];
            }
            
        }
        else {
           [plusbtn setHidden:false];
        }

        
    }
    else {
        [plusbtn setHidden:false];
    }

    NSDictionary *dict = _detailsDict;
    
    [eventImgV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"BG_EVNT_IMG"]];
    eventNAmeLB.text    = [dict objectForKey:@"name"];
    infoTV.text         = [dict objectForKey:@"description"];

    NSString * timeStampString =[dict objectForKey:@"event_date"];
    
    NSTimeInterval _interval    = [timeStampString doubleValue];
    NSDate *date                = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd MMMM YYYY h:mm a"];
 
    dateLB.text            = [_formatter stringFromDate:date];
    
    [locationBtn setTitle:[dict objectForKey:@"address"] forState:UIControlStateNormal];
    userNameLB.text    = [dict objectForKey:@"user_name"] != nil ? [NSString stringWithFormat:@"Hosted by: %@",[dict objectForKey:@"user_name"]] : @"Hosted By";
 
    if ([[NSString stringWithFormat:@"%@",[_detailsDict objectForKey:@"save"]] isEqualToString:@"1"]) {
        
        //saveEventBtn.userInteractionEnabled = false;
        saveEventBtn.selected   = true;
    }
    else {
        //saveEventBtn.userInteractionEnabled = true;
        saveEventBtn.selected   = false;
    }
}

#pragma mark - button Action
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)attendBtnaction:(id)sender {
    AttendingVC *view   = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendingVC"];
    if ( [self.title isEqualToString:@"Public"]) {
        view.title = @"Public";
    }
    view.dataDict       = [[NSMutableDictionary alloc] initWithDictionary:_detailsDict];
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)saveEventBtnaction:(id)sender {
    if ([[_detailsDict objectForKey:@"save"]intValue] == 1 ) {
        [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
         {
             SHOW_PROGRESS(@"Please Wait..");
             if (responseObject == false)
             {
                 HIDE_PROGRESS;
                 SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
             }
             else
             {
                 NSDictionary * params = @{
                                           @"auth_token" :AUTH_TOKEN  ,
                                           @"event_id": [_detailsDict objectForKey:@"id"]
                                           };
                 
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"unsave_event"];
                 
                 [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
                  {
                      HIDE_PROGRESS;
                      if (success == false)
                      {
                          SHOW_NETWORK_ERROR(message, self);
                      }
                      else
                      {
                          if ([Util checkIfSuccessResponse:dictionary])
                          {
                              [_detailsDict setObject:@"0" forKey:@"save"];
                              [self showDataOnScreen];
                          }
                          else
                          {
                              SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                          }
                      }
                }];
             }
        }];
}
    
    else{
        [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
         {
             SHOW_PROGRESS(@"Please Wait..");
             if (responseObject == false)
             {
                 HIDE_PROGRESS;
                 SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
             }
             else
             {
                 NSDictionary * params = @{
                                           @"auth_token" :AUTH_TOKEN  ,
                                           @"event_id": [_detailsDict objectForKey:@"id"]
                                           };
                 NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"save_event"];
                 [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
                  {
                      HIDE_PROGRESS;
                      if (success == false)
                      {
                          SHOW_NETWORK_ERROR(message, self);
                      }
                      else
                      {
                          if ([Util checkIfSuccessResponse:dictionary])
                          {
                              [_detailsDict setObject:@"1" forKey:@"save"];
                              [self showDataOnScreen];
                          }
                          else
                          {
                              SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                          }
                      }
                }];
             }
        }];
     }
}

- (IBAction)shareEventBtnAction:(id)sender {

    NSString * timeStampString  = [_detailsDict objectForKey:@"event_date"];
    
    NSTimeInterval _interval    = [timeStampString doubleValue];
    NSDate *date                = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd MMMM YYYY"];
    NSString *eventDate            = [_formatter stringFromDate:date];
    UIImage * image ;
    
    if (image != nil) {
        image =[UIImage imageNamed:[_detailsDict objectForKey:@"event_image"]];
    }
    else{
        image =[UIImage imageNamed:@"BG_EVNT_IMG"];
    }
    NSString *textToShare = [NSString stringWithFormat:@"Event %@ will be on %@",[_detailsDict objectForKey:@"name"],eventDate];
    
    NSArray *objectsToShare = @[textToShare,image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    activityVC.excludedActivityTypes = excludeActivities;
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction)chatbtnAction:(id)sender {
      if ([self.title isEqualToString:@"Public"]) {
        if ([[_detailsDict objectForKey:@"attend"]integerValue] == 1) {
            ChatVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
            view.dataDict = [[NSMutableDictionary alloc] initWithDictionary:_detailsDict];
            view.title  = @"Event";
            [self.navigationController pushViewController:view animated:true];
        }
        else{
            SHOW_CUSTOM_ALERT(appNAME, @"Please accept invitation request of event to continue chat", self)
        }
    }
    else{
        ChatVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
        view.dataDict = [[NSMutableDictionary alloc] initWithDictionary:_detailsDict];
        view.title  = @"Event";
        [self.navigationController pushViewController:view animated:true];
    }
}

#pragma mark- button action

- (IBAction)okBtnAction:(id)sender
{
    eventPopUpView.hidden = YES;
}

- (IBAction)viteBtnAction:(id)sender
{
    if ([qrType isEqualToString:@"VITE"])
    {
        if ([[_detailsDict objectForKey:@"attend"]integerValue] == 1) {
            //  NSString *qrString = [dictionary objectForKey:@"code"];
            NSString *qrString = [NSString stringWithFormat:@"%@%@%@",[_detailsDict objectForKey:@"id"],@"!",GET_USER_ID];
            NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
            
            CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            [qrFilter setValue:stringData forKey:@"inputMessage"];
            [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
            
            CIImage *qrImage = qrFilter.outputImage;
            float scaleX = QRImgV.frame.size.width / qrImage.extent.size.width;
            float scaleY = QRImgV.frame.size.height / qrImage.extent.size.height;
            
            qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
            
            QRImgV.image = [UIImage imageWithCIImage:qrImage
                                               scale:[UIScreen mainScreen].scale
                                         orientation:UIImageOrientationUp];
            QrPopUpV.hidden = NO;
        }
        else{
            SHOW_CUSTOM_ALERT(appNAME, @"Please accept invitation request of event to continue chat", self)
        }
    }
    else
    {
        if (!_isReading) {
            if ([self startReading]) {
            }
        }
        else{
           [self stopReading];
        }
        
        _isReading = !_isReading;
    }
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:scannerPop.layer.bounds];
    [scannerPop.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
     scanQR_CodePopUp.hidden = NO;
    return YES;
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
          barcodeString = metadataObj.stringValue;
          [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
          _isReading = NO;
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
     scanQR_CodePopUp.hidden = YES;
    [_videoPreviewLayer removeFromSuperlayer];
    [self checkQrCode];
    
}


- (IBAction)locationBtnaction:(id)sender {
    LocationVC *location    = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationVC"];
    location.detailsDict    = [[NSMutableDictionary alloc] initWithDictionary:_detailsDict];
    [self.navigationController pushViewController:location animated:YES];
}

- (IBAction)inviteBtnAction:(id)sender {
    InvitesVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"InvitesVC"];
    view.dataDict   = [[NSMutableDictionary alloc] initWithDictionary:_detailsDict];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
    if(touch.view == QrPopUpV)
    {
        QrPopUpV.hidden = YES;
    }
}

-(void)checkQrCode
{
    NSString *str=barcodeString;  //is your str
    NSArray *items = [str componentsSeparatedByString:@"!"];   //take the one array for split the string
    NSString *str1=[items objectAtIndex:0];   //shows Description
    NSString *str2=[items objectAtIndex:1];
    
    if ([[_detailsDict objectForKey:@"id"] integerValue] ==[str1 integerValue] )
    {
      [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         SHOW_PROGRESS(@"Please Wait..");
         if (responseObject == false)
         {
             HIDE_PROGRESS;
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             NSDictionary * params = @{
                                       @"auth_token" :AUTH_TOKEN,
                                       @"user_id":str2,
                                       @"event_id":str1
                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"qr_check"];
             
             [[ApiManager sharedInstance] POST:urlString parameterDict:params Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)
              {
                  HIDE_PROGRESS;
                  if (success == false)
                  {
                      SHOW_NETWORK_ERROR(@"Error retrieving data from Server", self);
                  }
                  else
                  {
                      if ([Util checkIfSuccessResponse:dictionary])
                      {
                          if ([[[dictionary objectForKey:@"body"] objectForKey:@"attend"] integerValue] == 1)
                          {
                              eventstatusLBL.text = [NSString stringWithFormat:@"%@ was invited to your event",[[dictionary objectForKey:@"body"] objectForKey:@"username"]];
                              eventNamerLBL.text = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"body"] objectForKey:@"event_name"]];
                          }
                          else
                          {
                              eventstatusLBL.text = [NSString stringWithFormat:@"%@ was invited to your event",[[dictionary objectForKey:@"body"] objectForKey:@"username"]];
                              eventNamerLBL.text = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"body"] objectForKey:@"event_name"]];                                                                                                                                                                     
                          }
                          eventPopUpView.hidden = NO;
                      }
                      else
                      {
                        SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                      }
                  }
                  
              }];
         }
         
     }];
    }
    else
    {
       SHOW_CUSTOM_ALERT(appNAME, @"Wrong event scanned, please check the event details", self)
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

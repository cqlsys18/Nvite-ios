//
//  LocationVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "LocationVC.h"
#import "ChatVC.h"

@interface LocationVC ()

@end

@implementation LocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self showDataOnScreen];
}

- (void) showDataOnScreen {
    
    
    NSDictionary *dict = _detailsDict;
    
    [eventImgV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"event_image"]] placeholderImage:[UIImage imageNamed:@"BG_EVNT_IMG"]];
    eventNAmeLB.text    = [dict objectForKey:@"name"];
    eventDetailLB.text         = [dict objectForKey:@"description"];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[_detailsDict objectForKey:@"latitude"] doubleValue], [[_detailsDict objectForKey:@"longitude"] doubleValue]);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coord, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    annotation.title = eventNAmeLB.text;
    
    [mapV setRegion:region];
    [mapV addAnnotation:annotation];
    
}


#pragma mark - UIButtonActions

- (IBAction)commentBtnAction:(id)sender {
    
    ChatVC *view = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    view.dataDict = [[NSMutableDictionary alloc] initWithDictionary:_detailsDict];
    view.title  = @"Event";
    
    [self.navigationController pushViewController:view animated:true];
}

- (IBAction)shareBtnAction:(id)sender {
    
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getDirections:(id)sender {

    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
      
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?addr=%f,%f&zoom=14&views=traffic", [[_detailsDict objectForKey:@"latitude"] doubleValue], [[_detailsDict objectForKey:@"longitude"] doubleValue]]]];
    } else {
        
        NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps?addr=\%f,%f", [[_detailsDict objectForKey:@"latitude"] doubleValue], [[_detailsDict objectForKey:@"longitude"] doubleValue]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        
    }
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

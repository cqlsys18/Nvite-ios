//
//  ViewController.m
//  invite
//
//  Created by Ajay CQL on 04/09/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (AUTH_TOKEN != nil) {
        UIViewController *Tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarVC"];
        self.view.window.rootViewController = Tabbar;
    }
    else{
        UIViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:loginView animated:true];
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

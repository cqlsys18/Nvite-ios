//
//  TabbarVC.m
//  Nimbus
//
//  Created by AJ on 8/2/17.
//  Copyright © 2017 Team. All rights reserved.
//

#import "TabbarVC.h"

@interface TabbarVC ()

@end

@implementation TabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor], }forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :UIColorFromRGBAlpha(255, 72, 1, 1),}forState:UIControlStateSelected];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeFont:FONT_Medium(10)} forState:UIControlStateNormal];
    
    [[UITabBar appearance] setTintColor:UIColorFromRGBAlpha(255, 72, 1, 1)];
    for(UITabBarItem * tabBarItem in self.tabBar.items){
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ContactVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "ContactVC.h"
#import "ContactTVCell.h"
@interface ContactVC (){
    
    IBOutlet NSLayoutConstraint *moreWidthConst;
    IBOutlet NSLayoutConstraint *moreheighConst;
    IBOutlet UIButton *morebtn;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchBtnconst;

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.title isEqualToString:@"location"]) {
        _searchBtnconst.constant = 0;
        morebtn.hidden = YES;
        moreWidthConst.constant = 0;
        moreheighConst.constant= 0;
        
    }else{
          _searchBtnconst.constant = 0;
        morebtn.hidden = NO;
        moreWidthConst.constant = 40;
        moreheighConst.constant= 40;
    }
  
    // Do any additional setup after loading the view.
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (cell == nil) {
        
        cell = [[ContactTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactCell"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.userPicV.layer.cornerRadius = cell.userPicV.frame.size.width/2;
    cell.clipsToBounds =YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}


#pragma mark - button Action
- (IBAction)backBtnAction:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)newGroupBtnaction:(id)sender {
    UIViewController *Group = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateGroupVC"];
    [self.navigationController pushViewController:Group animated:YES];

}

- (IBAction)searchBtnAction:(id)sender {
}
- (IBAction)moreBtnAction:(UIButton*)sender {
    if (!sender.selected) {
        sender.selected= YES;
        menuV.hidden = NO;
    }
    else{
        sender.selected= NO;
        menuV.hidden = YES;
    }

}
- (IBAction)inviteBtnaction:(UIButton*)sender {
    sender.selected= !sender.selected;
}
#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

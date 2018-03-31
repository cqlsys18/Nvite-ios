//
//  CreateGroupVC.m
//  invite
//
//  Created by Ajay kumar on 9/6/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "CreateGroupVC.h"
#import "GroupPersonCV.h"
@interface CreateGroupVC ()

@end

@implementation CreateGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    groupImageV.layer.cornerRadius  = groupImageV.frame.size.width/2;
    groupImageV.clipsToBounds       = YES;
    
    selectedUsers   = [[NSMutableArray alloc] init];
    
    [self getUsers];
}

- (void) getUsers {
    
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
                                       @"auth_token" :AUTH_TOKEN                                       };
             NSString * urlString = [NSString stringWithFormat:@"%@%@",appURL,@"friend_list"];
             
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
                          usersArray = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:@"body"]];
                          [personCollectionV reloadData];
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

#pragma mark - Collection View Delegate and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return usersArray.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"GroupPersonCell";
    GroupPersonCV *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    cell.crossbtn.userInteractionEnabled    = false;
    
    NSDictionary *dict  = [usersArray objectAtIndex:indexPath.row];
    
    cell.nameLB.text    = [dict objectForKey:@"username"];
    [cell.userImgV setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"USER_PIC"]];
    
    cell.userImgV.layer.cornerRadius    = cell.userImgV.frame.size.width/2.0f;
    cell.userImgV.clipsToBounds         = true;
    
    if ([selectedUsers containsObject:dict]) {
        cell.crossbtn.hidden    = false;
    }
    else {
        cell.crossbtn.hidden    = true;
    }
    return cell;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(personCollectionV.frame.size.width/3 , 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if ([selectedUsers containsObject:[usersArray objectAtIndex:indexPath.row]]) {
        [selectedUsers removeObject:[usersArray objectAtIndex:indexPath.row]];
    }
    else {
        [selectedUsers addObject:[usersArray objectAtIndex:indexPath.row]];
    }
    [collectionView reloadData];
}

#pragma mark collection view cell paddings

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
   
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}


#pragma mark - button action

- (IBAction)backBtnAction:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cameraBtnaction:(id)sender {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:appNAME
                                                                   message:@"Upload Photo!"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take Photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                  imagePickerController.delegate = self;
                                  imagePickerController.allowsEditing   = true;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Choose Existing Photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  
                                  UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
                                  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                  imagePickerController.allowsEditing   = true;
                                  imagePickerController.delegate = self;
                                  imagePickerController.navigationBar.barStyle = UIBarStyleBlackOpaque;
                                  [self presentViewController:imagePickerController animated:YES completion:^{}];
                              }];
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)clickBntaction:(id)sender {
    if ([groupNAmeTF.text isEqualToString:@""]) {
        SHOW_CUSTOM_ALERT(appNAME, @"Please Enter Group name", self)
    }
    else{
        [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
         {
             
             if (responseObject == false)
             {
                 SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
             }
             else
             {
                 NSMutableDictionary *imageDict = [[NSMutableDictionary alloc] init];
                 
                 if (imageData!= nil) {
                     [imageDict setObject:imageData forKey:@"image"];
                 }
                 
                 
                 NSMutableArray *iddds = [[NSMutableArray alloc] init];
                 
                 for (NSDictionary *dd in selectedUsers) {
                     [iddds addObject:[dd objectForKey:@"id"]];
                 }
                 
                 NSDictionary *dict     = @{@"user_ids":[iddds componentsJoinedByString:@","], @"auth_token":AUTH_TOKEN,  @"name":groupNAmeTF.text};
                 
                 NSString *urlStr       = [NSString stringWithFormat:@"%@%@",appURL,@"group_create"];
                 
                 [[ApiManager sharedInstance] apiCallWithImage:urlStr parameterDict:dict imageDataDictionary:imageDict  CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                     
                     HIDE_PROGRESS;
                     if (success == false)
                     {
                         SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                     }
                     else
                     {
                         if ([Util checkIfSuccessResponse:dictionary])
                         {
                             UIAlertController *alertController = [UIAlertController
                                                                   alertControllerWithTitle:appNAME
                                                                   message:@"Group Created Successfully."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *okAction = [UIAlertAction
                                                        actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action)
                                                        {
                                                            [self.navigationController popViewControllerAnimated:true];
                                                        }];
                             
                             [alertController addAction:okAction];
                             
                             [self presentViewController:alertController animated:YES completion:nil];
                         }
                         else
                         {
                             if ([[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"code"]]isEqualToString:@"403"]) {
                                 
                                 
                             }
                         }
                     }
                 }];
             }
             
         }];
    }
  
    
}

#pragma mark - imagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    groupImageV.image   = chosenImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

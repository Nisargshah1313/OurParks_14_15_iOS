/*
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may
 be used to endorse or promote products derived from this software
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "LoginVC.h"
#import "ClassDifficultyVC.h"
#import "MyClassVC.h"


#define HEIGHT_IPHONE_5 568
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5 )

@interface RearViewController()

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;
@synthesize customTblViewCell;
@synthesize profileImgVw;

#pragma marl - UITableView Data Source

-(void)viewDidLoad
{
    [super viewDidLoad];
    //[self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.title = NSLocalizedString(@"", nil);
    self.navigationController.navigationBar.hidden = YES;
    
//    arrMenuItems = [[NSMutableArray alloc]initWithObjects:@"HOME",@"MY CLASSES",@"LEADERBOARD",@"PROFILE",@"SHOP", nil];
    
    arrMenuItems = [[NSMutableArray alloc]initWithObjects:@"HOME",@"MY CLASSES",@"LOGOUT",nil];
    
    UIImage *mask =nil;
    
    UIImage *image = [UIImage imageNamed:@"personIcon.jpg"];
    
    profileImgVw.image = image;
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(50, 50)];
    mask = [UIImage imageNamed:@"Round.png"];
    UIImage *maskedImage = [self maskImage:image withMask:mask imgview:profileImgVw];
    profileImgVw.image=maskedImage;
    profileImgVw.layer.masksToBounds = YES;
    
    UILabel *lblName = (UILabel *)[self.view viewWithTag:121];
    NSString *strName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME]];
    lblName.text = strName;
    
     UILabel *lblPoints = (UILabel *)[self.view viewWithTag:122];
    NSString *strPoints = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_POINTS]];
    lblPoints.text = strPoints;

    [self performSelector:@selector(downloadManagerImage) withObject:nil afterDelay:0.1];
    
}

-(void)downloadManagerImage
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_PIC]) {
        
        UIImage *mask =nil;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_PIC]]];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        //        [profileImgVw setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:PHOTO]] placeholderImage:Nil];
        
        img = [self imageWithImage:img scaledToSize:CGSizeMake(50, 50)];
        
        
        mask = [UIImage imageNamed:@"Round.png"];
        
        UIImage *maskedImage = [self maskImage:img withMask:mask imgview:profileImgVw];
        
        profileImgVw.image=maskedImage;
        profileImgVw.layer.masksToBounds = YES;
        
        
        //manager_image
    }
    
    // [indicator stopAnimating];
    
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - Table Datasource Methods
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrMenuItems.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"customCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"RearViewMenuCell" owner:self options:nil];
        cell = customTblViewCell;
        
        customTblViewCell=nil;
    }
    
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    UILabel *lblTitleMenu = (UILabel *)[cell.contentView viewWithTag:21];
    
    UIImageView *imgVwMenuIcon = (UIImageView *)[cell.contentView viewWithTag:22];
    
    imgVwMenuIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[arrMenuItems objectAtIndex:indexPath.row]]];
    
    lblTitleMenu.text = [NSString stringWithFormat:@"%@",[arrMenuItems objectAtIndex:indexPath.row]];
    
    [lblTitleMenu setFont:[UIFont fontWithName:@"Oswald-Medium" size:16.0f]];
    
    //[cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18.0f]];
    
    //UIImageView *cellBgImg = (UIImageView *)[cell.contentView viewWithTag:25];
    
    //    if (indexPath.section == 0) {
    //        cellBgImg.image = [UIImage imageNamed:[arrMenuCellFirst objectAtIndex:indexPath.row]];
    //    }
    //    else if (indexPath.section == 1)
    //    {
    //        cellBgImg.image = [UIImage imageNamed:[arrMenuCellFeatures objectAtIndex:indexPath.row]];
    //    }
    //    else
    //    {
    //        cellBgImg.image = [UIImage imageNamed:[arrMenuCellMore objectAtIndex:indexPath.row]];
    //    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // We know the frontViewController is a NavigationController
    
    //    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    
    // NSInteger row = indexPath.row;
    
    // Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
    
    if (indexPath.row == 0) {
        
        //Home Clicked!
        ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [revealController pushFrontViewController:navigationController animated:YES];
        
        
    }
    else if (indexPath.row == 1)
    {
        MyClassVC *mcvc = [[MyClassVC alloc] initWithNibName:@"MyClassVC" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mcvc];
        [revealController pushFrontViewController:navigationController animated:YES];
    }
    
    else if (indexPath.row == 2)
    {
        UIAlertView *alertLogin = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure want to Logout from the Application?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        
        [alertLogin show];
        alertLogin = nil;

    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self action_logout:nil];
    }
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage imgview:(UIImageView *)imgView
{
    
    // UIImageView *imgView = (UIImageView *)[self.view viewWithTag:20];
    imgView.image = image;
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[maskImage CGImage];
    mask.frame = CGRectMake(0, 0, imgView.image.size.width, imgView.image.size.height);
    imgView.layer.mask = mask;
    imgView.layer.masksToBounds = YES;
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask11 = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                          CGImageGetHeight(maskRef),
                                          CGImageGetBitsPerComponent(maskRef),
                                          CGImageGetBitsPerPixel(maskRef),
                                          CGImageGetBytesPerRow(maskRef),
                                          CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask11);
    
    
    
    return [UIImage imageWithCGImage:masked];
    //iv.image= [UIImage imageWithCGImage:masked];
    // iv.layer.masksToBounds = YES;
    
}

- (IBAction)action_logout:(id)sender {
    
    SWRevealViewController *revealController = self.revealViewController;
    
    NSUserDefaults *defaultsEnabled = [NSUserDefaults standardUserDefaults];
    [defaultsEnabled setBool:NO forKey:@"isloggedIn"];
    [defaultsEnabled synchronize];
    
    self.navigationItem.rightBarButtonItem = nil;
        
    LoginVC *lvc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [revealController pushFrontViewController:navigationController animated:YES];
    
}

@end
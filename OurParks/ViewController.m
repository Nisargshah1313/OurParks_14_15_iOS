//
//  ViewController.m
//  OurParks
//
//  Created by Nisarg Shah on 30/07/15.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#import "ViewController.h"
#import "BookClassesVC.h"
#import "ClassDifficultyVC.h"
#import "BoroughListVC.h"
#import "ClassTypeVC.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tblHomeOptions,customTblViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
//    arrTitlesOpt = [[NSMutableArray alloc]initWithObjects:@"BOOK CLASSES",@"BROWSE BY CLASS TYPE",@"BROWSE BY FITNESS LEVEL",@"BROWSE BY BOROUGH",@"VIEW THE LEADERBOARD",@"FITNESS TOP TIPS", nil];
    
    arrTitlesOpt = [[NSMutableArray alloc]initWithObjects:@"BOOK CLASSES",@"BROWSE BY CLASS TYPE",@"BROWSE BY FITNESS LEVEL",@"BROWSE BY BOROUGH", nil];
    
    [tblHomeOptions reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger finalCountOfRow = 4;
    
    return finalCountOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customMemberCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HomeStudentVCcell" owner:self options:nil];
        cell = customTblViewCell;
        
        customTblViewCell=nil;
    }
    
    UIImageView *imgCellBg = (UIImageView *)[cell.contentView viewWithTag:20];
    
    UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:21];
    
    //  UILabel *lblSubTitle = (UILabel *)[cell.contentView viewWithTag:22];
    
    lblTitle.text = [NSString stringWithFormat:@"%@",[arrTitlesOpt objectAtIndex:indexPath.row]];
    
    imgCellBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"homeopt%ld.jpg",(long)indexPath.row+1]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        BookClassesVC *bcvc = [[BookClassesVC alloc]initWithNibName:@"BookClassesVC" bundle:nil];
        [self.navigationController pushViewController:bcvc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        ClassTypeVC *ctvc = [[ClassTypeVC alloc]initWithNibName:@"ClassTypeVC" bundle:nil];
        [self.navigationController pushViewController:ctvc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        ClassDifficultyVC *cdvc = [[ClassDifficultyVC alloc] initWithNibName:@"ClassDifficultyVC" bundle:nil];
        [self.navigationController pushViewController:cdvc animated:YES];
    }
    
    else if (indexPath.row == 3)
    {
        BoroughListVC *bvc = [[BoroughListVC alloc] initWithNibName:@"BoroughListVC" bundle:nil];
        [self.navigationController pushViewController:bvc animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

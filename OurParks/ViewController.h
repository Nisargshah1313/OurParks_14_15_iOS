//
//  ViewController.h
//  OurParks
//
//  Created by Nisarg Shah on 30/07/15.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrTitlesOpt;
}

@property (weak, nonatomic) IBOutlet UITableView *tblHomeOptions;
@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;

@end


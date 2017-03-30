//
//  CoachHomeVC.h
//  OurParks
//
//  Created by Nisarg Shah on 30/07/15.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoachHomeVC : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIActivityIndicatorView *indicator;
    
    NSMutableDictionary *dicCoachHomeSubmit;
    NSMutableArray *arr_ResponseData;
    
    NSMutableDictionary *dicAllResponseData;
    NSMutableArray *arrCoachHomeClassList;
    
     NSMutableDictionary *dicClassDetailSubmit;
    
    
    NSMutableDictionary *dictResultDirectory;
}

@property (weak, nonatomic) IBOutlet UIImageView *profileImgVw;

@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;

@property (weak, nonatomic) IBOutlet UITableView *tblCoachClassesList;

@end

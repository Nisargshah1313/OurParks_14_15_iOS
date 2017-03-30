//
//  NJSWelcomeVC.h
//  PropertyXP
//
//  Created by Nisarg Shah on 13/10/14.
//  Copyright (c)  2015  . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHWalkThroughView.h"

@interface NJSWelcomeVC : UIViewController

@property (nonatomic, strong) GHWalkThroughView* ghView ;

@property (nonatomic, strong) NSArray* descStrings;

@property (nonatomic, strong) UILabel* welcomeLabel;

@end

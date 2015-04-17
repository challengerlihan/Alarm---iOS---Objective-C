//
//  AlarmListViewController.h
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "AlarmDetailViewController.h"

@interface AlarmListViewController : UITableViewController<AlarmDetailViewControllerDelegate>

@property(nonatomic, strong) DataModel *dataModel;

@end

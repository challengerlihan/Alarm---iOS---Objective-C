//
//  AlarmDetailViewController.h
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlarmDetailViewController;
@class Alarm;


@protocol AlarmDetailViewControllerDelegate <NSObject>
- (void) alarmDetailViewControllerDidCancel: (AlarmDetailViewController*) controller;
- (void) alarmDetailViewController: (AlarmDetailViewController*) controller didFinishAddingAlarm: (Alarm*) alarm;
- (void) alarmDetailViewController:(AlarmDetailViewController*) controller didFinishEditingAlarm: (Alarm*) alarm;

@end

@interface AlarmDetailViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>


@property(nonatomic, weak) id<AlarmDetailViewControllerDelegate> delegate;//定义它的代理对象

@property(nonatomic, strong) Alarm *alarmToEdit;

@end

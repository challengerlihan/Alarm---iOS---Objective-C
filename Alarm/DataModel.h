//
//  DataModel.h
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(nonatomic, strong) NSMutableArray *alarms;

- (void) saveAlarms;

@end

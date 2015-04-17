//
//  Alarm.h
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject

@property(nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL onOff;
@property(nonatomic, copy) NSString *music;
@property(nonatomic, copy) NSString *timeInterval;


//@property(nonatomic, strong) NSMutableArray *musics;
//@property(nonatomic, strong) NSMutableArray *timeIntervals;

@end

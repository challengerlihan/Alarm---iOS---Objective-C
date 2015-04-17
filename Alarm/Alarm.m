//
//  Alarm.m
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super init])) {
        self.time = [aDecoder decodeObjectForKey:@"Time"];
        self.onOff = [aDecoder decodeBoolForKey:@"OnOff"];
        self.music = [aDecoder decodeObjectForKey:@"music"];
        self.timeInterval = [aDecoder decodeObjectForKey:@"TimeInterval"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.time forKey:@"Time"];
    [aCoder encodeBool:self.onOff forKey:@"OnOff"];
    [aCoder encodeObject:self.music forKey:@"music"];
    [aCoder encodeObject:self.timeInterval forKey:@"TimeInterval"];
}

@end

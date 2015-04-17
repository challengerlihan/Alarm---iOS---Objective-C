//
//  DataModel.m
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (NSString*) documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

- (NSString*) dataFilePath{
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Alarms.plist"];
}

- (void) saveAlarms{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.alarms forKey:@"Alarms"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)loadAlarms{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        self.alarms = [unarchiver decodeObjectForKey:@"Alarms"];        [unarchiver finishDecoding];
    } else {
        self.alarms = [[NSMutableArray alloc] initWithCapacity:20];
    }
}

//DataModel的核心功能就是load和save所有的数据
- (id)init{
    if((self = [super init])){
        [self loadAlarms];
    }
    return self;
}


@end

//
//  AlarmListViewController.m
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import "AlarmListViewController.h"
#import "DataModel.h"
#import "Alarm.h"
#import "AlarmDetailViewController.h"
#import "MMPDeepSleepPreventer.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AlarmListViewController (){

    NSMutableArray *timers;
    AVAudioPlayer *player;
    
}

@end

@implementation AlarmListViewController

- (void) playAlarm: (NSTimer *)theTimer{
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:(NSString*)[theTimer userInfo] withExtension:@"caf"];
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    [player play];
}

- (void) playAlarmRepetitively: (NSTimer *)theTimer{
    [timers removeLastObject];//ensure that each row only has one timer, which makes it easy to invalidate the timer
    
    NSString *info = [theTimer userInfo];
    NSString *repetitiveTimeInterval = [info substringWithRange:NSMakeRange(0,2)];
    NSString *musicTitle = [info substringWithRange:NSMakeRange(2, info.length - 2)];
    
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:(NSString*)musicTitle withExtension:@"caf"];
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    [player play];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:[repetitiveTimeInterval intValue]*60 target:self selector:@selector(playAlarm:) userInfo:musicTitle repeats:YES];
    [timers addObject:timer];
//    NSLog(@"The # of timers: %lu", [timers count]);
//    NSLog(@"The # of alarms: %lu", [self.dataModel.alarms count]);
}

- (NSTimer *) fireSingleTimer: (Alarm *) alarm{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    NSRange hourRange = NSMakeRange(0,2);
    NSString *nowHour = [now substringWithRange:hourRange];
    NSString *futureHour = [alarm.time substringWithRange:hourRange];
    
    NSRange minuteRange = NSMakeRange(3, 2);
    NSString *nowMinute = [now substringWithRange:minuteRange];
    NSString *futureMinute = [alarm.time substringWithRange:minuteRange];
    
    NSRange secondRange = NSMakeRange(6, 2);
    NSString *nowSecond = [now substringWithRange:secondRange];
    
    int timeIntervalInSeconds = ([futureHour intValue]-[nowHour intValue])*3600 + ([futureMinute intValue]-[nowMinute intValue])*60 - [nowSecond intValue];
    
    if (timeIntervalInSeconds <= 0) {
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(playAlarm:) userInfo:alarm.music repeats:NO];
//        [timer invalidate];
//        return timer;
        timeIntervalInSeconds = 24*3600 + timeIntervalInSeconds;
    }
    
    if ([alarm.timeInterval isEqualToString:@"0"])
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeIntervalInSeconds target:self selector:@selector(playAlarm:) userInfo:alarm.music repeats:NO];
        if (alarm.onOff == NO) {
            [timer invalidate];
        }
        return timer;
    } else {
        NSString *info = [NSString stringWithFormat:@"%@%@", alarm.timeInterval, alarm.music];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeIntervalInSeconds target:self selector:@selector(playAlarmRepetitively:) userInfo:info repeats:NO];
        if (alarm.onOff == NO) {
            [timer invalidate];
        }
        return timer;
    }
}

- (void) fireAllTimers{
    [timers removeAllObjects];
    for (Alarm *alarm in _dataModel.alarms) {
        NSTimer *timer = [self fireSingleTimer:alarm];
        [timers addObject:timer];
    }

//    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(playAlarm:) userInfo:@"梦幻" repeats:NO];
//    [timer fire];//原来只要创建timer它过一段时间就会自己fire，直接调用这个方法的话就立即fire了！！！
}

- (void)viewDidLoad {
    [super viewDidLoad];
    timers = [[NSMutableArray alloc] initWithCapacity:20];//必须init...
    [self fireAllTimers];
//    NSLog(@"The # of timers: %lu", [timers count]);
//    NSLog(@"The # of alarms: %lu", [self.dataModel.alarms count]);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    for (NSTimer *timer in timers) {
        [timer invalidate];
    }
    [self fireAllTimers];
//    NSLog(@"The # of timers: %lu", [timers count]);
//    NSLog(@"The # of alarms: %lu", [self.dataModel.alarms count]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureStuffForCell:(UITableViewCell *)cell withAlarm:(Alarm *)alarm{
    cell.textLabel.text = alarm.time;
    UISwitch *switchView = (UISwitch*) [cell viewWithTag:1];
    [switchView setOn:alarm.onOff animated:NO];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    //    [switchView release];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.dataModel.alarms count];
//    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //没有prototype的时候初始化方法
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Alarm"];//有prototype
    
    Alarm *alarm = self.dataModel.alarms[indexPath.row];
    
    [self configureStuffForCell:cell withAlarm:alarm];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataModel.alarms removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [timers[indexPath.row] invalidate];//删除timer是不够的，要invalidate才能关闭，阴魂不散
    [timers removeObjectAtIndex:indexPath.row];
    [player stop];
}


- (void) switchChanged:(id)sender {
    UISwitch* switchControl = sender;
    
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *hitIndex = [self.tableView indexPathForRowAtPoint:hitPoint];
    Alarm *alarm = self.dataModel.alarms[hitIndex.row];
    if (switchControl.on) {
        [player play];
        alarm.onOff = YES;
        [timers[hitIndex.row] invalidate];
        timers[hitIndex.row] = [self fireSingleTimer:alarm];
    } else {
        [player stop];
        alarm.onOff = NO;
        //invalidate the repetitive timer
        [timers[hitIndex.row] invalidate];//row number也是从零开始的！
//        NSLog(@"The # of timers: %lu", [timers count]);
//        NSLog(@"Row number: %ld", hitIndex.row);
    }
}

- (void) alarmDetailViewControllerDidCancel: (AlarmDetailViewController*) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) alarmDetailViewController: (AlarmDetailViewController*) controller didFinishAddingAlarm: (Alarm*) alarm{
    NSInteger newRowIndex = [self.dataModel.alarms count];
    [self.dataModel.alarms addObject:alarm];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) alarmDetailViewController:(AlarmDetailViewController*) controller didFinishEditingAlarm: (Alarm*) alarm{
    NSInteger index = [self.dataModel.alarms indexOfObject:alarm];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureStuffForCell:cell withAlarm:alarm];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"AddAlarm"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AlarmDetailViewController *controller = (AlarmDetailViewController*) navigationController.topViewController;
        controller.delegate = self;
    } else if ([segue.identifier isEqualToString:@"EditAlarm"]){
        UINavigationController *navigationController = segue.destinationViewController;
        AlarmDetailViewController *controller = (AlarmDetailViewController*) navigationController.topViewController;
        controller.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.alarmToEdit = self.dataModel.alarms[indexPath.row];
//        NSLog(@"Time is @%@", controller.alarmToEdit.timeInterval);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

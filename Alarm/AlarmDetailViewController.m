//
//  AlarmDetailViewController.m
//  Alarm
//
//  Created by Han Li on 15/4/9.
//  Copyright (c) 2015年 Han Li. All rights reserved.
//

#import "AlarmDetailViewController.h"
#import "Alarm.h"

@interface AlarmDetailViewController ()

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *musicPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timeIntervalPicker;

@property (strong, nonatomic) NSArray *musics;
@property (strong, nonatomic) NSArray *timeIntervals;
@property (strong, nonatomic) NSArray *timeIntervalsInNumber;

@end

@implementation AlarmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.musics = [[NSArray alloc] initWithObjects:@"懒猪起床", @"起床铃声", @"梦幻", @"非常有趣", @"叮当", @"布谷鸟", nil];
    self.timeIntervals = [[NSArray alloc] initWithObjects:@"不重复", @"1 min", @"3 min", @"10 min", @"30 min", @"60 min", nil];
    self.timeIntervalsInNumber = [[NSArray alloc] initWithObjects: @"0", @"01", @"03", @"10", @"30", @"60", nil];
    
    if (self.alarmToEdit != nil) {
        
        NSRange hourRange = NSMakeRange(0,2);
        NSString *futureHour = [self.alarmToEdit.time substringWithRange:hourRange];
        
        NSRange minuteRange = NSMakeRange(3, 2);
        NSString *futureMinute = [self.alarmToEdit.time substringWithRange:minuteRange];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:[futureHour intValue]];
        [components setMinute:[futureMinute intValue]];
        NSDate *defualtDate = [calendar dateFromComponents:components];
        [self.timePicker setDate:defualtDate];
        
        NSString *musicTitle = self.alarmToEdit.music;
//        NSLog(@"%@", musicTitle);
        NSInteger musicRowIndex =[self.musics indexOfObject:musicTitle];
        [self.musicPicker selectRow:musicRowIndex inComponent:0 animated:YES];
        
        NSString *timeInterval = self.alarmToEdit.timeInterval;
//        NSLog(@"%@", timeInterval);
        NSInteger timeIntervalRowIndex = [self.timeIntervalsInNumber indexOfObject:timeInterval];
        [self.timeIntervalPicker selectRow:timeIntervalRowIndex inComponent:0 animated:YES];
        
//        [self.musicPicker selectRow:1 inComponent:0 animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 1:
            return [self.musics count];
        case 2:
            return [self.timeIntervals count];
        default:
            return 0;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (pickerView.tag) {
        case 1:
            return [self.musics objectAtIndex:row];
        case 2:
            return [self.timeIntervals objectAtIndex:row];
        default:
            return nil;
    }
}

- (IBAction)done:(id)sender {
    
    if (self.alarmToEdit == nil) {
        Alarm *alarm = [[Alarm alloc]init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        alarm.time = [dateFormatter stringFromDate:[_timePicker date]];
        alarm.music = [_musics objectAtIndex:[_musicPicker selectedRowInComponent:0]];
        alarm.timeInterval = [_timeIntervalsInNumber objectAtIndex:[_timeIntervalPicker selectedRowInComponent:0]];
        alarm.onOff = YES;
        
        [self.delegate alarmDetailViewController:self didFinishAddingAlarm:alarm];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        self.alarmToEdit.time = [dateFormatter stringFromDate:[_timePicker date]];

        self.alarmToEdit.music = [_musics objectAtIndex:[_musicPicker selectedRowInComponent:0]];
        self.alarmToEdit.timeInterval = [_timeIntervalsInNumber objectAtIndex:[_timeIntervalPicker selectedRowInComponent:0]];
        [self.delegate alarmDetailViewController:self didFinishEditingAlarm:self.alarmToEdit];
    }
}

- (IBAction)cancel:(id)sender {
    [self.delegate alarmDetailViewControllerDidCancel:self];
}

@end

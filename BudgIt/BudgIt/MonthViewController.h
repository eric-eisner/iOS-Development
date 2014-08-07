//
//  MonthViewController.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YearViewController.h"
#import "AddEditEventViewController.h"
@class Day;
@class Month;
@class Year;

@interface MonthViewController : UIViewController <ChangeMonthYearDelegate, AddEvents>

@property(nonatomic, strong) Day* day;
@property(nonatomic, strong) Month* month;
@property(nonatomic, strong) Year* year;
@property(nonatomic, strong) Day* currentDay;
@property(nonatomic, strong) Month* currentMonth;
@property(nonatomic, strong) Year* currentYear;
@property(nonatomic, weak) IBOutlet UILabel* previousBalanceLabel;
@property(nonatomic, weak) IBOutlet UILabel* weekNetChangesLabel;
@property(nonatomic, weak) IBOutlet UILabel* thisWeekBalanceLabel;
@property(nonatomic, strong) UIImageView* todayCircle;
@property(nonatomic, weak) IBOutlet UIButton* monthYearTitle;
@property(nonatomic, retain) IBOutletCollection(UIButton) NSMutableArray* days;
@property(nonatomic, weak) IBOutlet UIView* calendarView;
@property(nonatomic, weak) IBOutlet UIView* balanceView;
@property(nonatomic, weak) IBOutlet UIBarButtonItem* addItemButton;

-(NSMutableArray *)getWeekDatesForDate:(NSDate *)date;
-(IBAction)incrementMonth;
-(IBAction)decrementMonth;
-(IBAction)addEvent;
-(IBAction)monthClicked;
-(IBAction)todayClicked;
-(IBAction)dayClicked:(UIButton*)sender;
-(IBAction)weeklyBalancesTapped:(id)sender;

@end

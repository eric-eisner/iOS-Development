//
//  DayEventsViewController.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEditEventViewController.h"
@class Day;
@class Month;
@class Year;

@interface DayEventsTableViewController : UITableViewController <AddEvents, EditEvents, DeleteEvents>

@property(nonatomic, weak) Day* day;
@property(nonatomic, weak) Month* month;
@property(nonatomic, weak) Year* year;
@property(nonatomic, strong) NSMutableArray* bills;
@property(nonatomic, strong) NSMutableArray* deposits;
@property(nonatomic, strong) NSMutableArray* weekBalances;
@property(nonatomic, weak) Event* event;

-(IBAction)addEvent;

@end

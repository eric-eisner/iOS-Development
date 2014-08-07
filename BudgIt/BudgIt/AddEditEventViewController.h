//
//  AddEditEventViewController.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEditEventProtocols.h"
#import "PickerViewController.h"
@class Event;
@class WeekTotal;

@interface AddEditEventViewController : UIViewController <UIAlertViewDelegate, PickerView, ReminderPicker, FrequencyPicker>

@property(nonatomic, weak) IBOutlet UIButton* billButton;
@property(nonatomic, weak) IBOutlet UIButton* deleteButton;
@property(nonatomic, weak) IBOutlet UIButton* depositButton;
@property(nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property(nonatomic, strong) NSDate* dateFromVC;
@property(nonatomic, strong) Event* event;
@property(nonatomic, strong) WeekTotal* weekTotal;
@property(nonatomic, weak) NSMutableArray* weekBalances;
@property(nonatomic) BOOL isBill;
@property(nonatomic) BOOL isEdit;
@property(nonatomic, retain) id<AddEvents> addDelegate;
@property(nonatomic, retain) id<EditEvents> editDelegate;
@property(nonatomic, retain) id<DeleteEvents> deleteDelegate;
@property(nonatomic, retain) id<CheckInput> checkInputDelegate;
@property(nonatomic, retain) id<PickerView> pickerDelegate;

-(IBAction)cancelPressed;
-(IBAction)donePressed;
-(IBAction)billPressed;
-(IBAction)depositPressed;
-(IBAction)deletePressed;
-(void)setPickerView;

@end

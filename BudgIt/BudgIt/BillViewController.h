//
//  AddEditBillViewController.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/6/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEditEventProtocols.h"
#import "BillDepositProtocols.h"
#import "PickerViewController.h"
@class Bill;
@class WeekTotal;

@interface BillViewController : UIViewController <UITextFieldDelegate, CheckInput, PickerView>

@property(nonatomic, weak) IBOutlet UITextField* nameTextField;
@property(nonatomic, weak) IBOutlet UITextField* dateTextField;
@property(nonatomic, weak) IBOutlet UITextField* paymentTextField;
@property(nonatomic, weak) IBOutlet UIButton* repeatButton;
@property(nonatomic, weak) IBOutlet UILabel* frequencyLabel;
@property(nonatomic, weak) IBOutlet UIButton* frequencyButton;
@property(nonatomic, weak) IBOutlet UIStepper* reminderStepper;
@property(nonatomic, weak) IBOutlet UIButton* reminder1Button;
@property(nonatomic, weak) IBOutlet UIButton* reminder2Button;
@property(nonatomic, weak) IBOutlet UIButton* reminder1DeleteButton;
@property(nonatomic, weak) IBOutlet UIButton* reminder2DeleteButton;
@property(nonatomic, weak) Bill* event;
@property(nonatomic, weak) WeekTotal* weekTotal;
@property(nonatomic, retain) id<FrequencyPicker> frequencyDelegate;
@property(nonatomic, retain) id<ReminderPicker> reminderDelegate;

-(IBAction)viewTapped;
-(IBAction)repeatButtonPressed:(id)sender;
-(IBAction)frequencyButtonPressed:(id)sender;
-(IBAction)stepperChanged:(id)sender;
-(IBAction)reminderButtonPressed:(id)sender;

@end

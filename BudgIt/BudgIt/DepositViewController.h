//
//  DepositViewController.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/6/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEditEventProtocols.h"
#import "BillViewController.h"
#import "PickerViewController.h"
@class Deposit;
@class WeekTotal;

@interface DepositViewController : UIViewController  <UITextFieldDelegate, CheckInput, PickerView>

@property(nonatomic, weak) IBOutlet UITextField* nameTextField;
@property(nonatomic, weak) IBOutlet UITextField* dateTextField;
@property(nonatomic, weak) IBOutlet UITextField* netAmountTextField;
@property(nonatomic, weak) IBOutlet UIButton* repeatButton;
@property(nonatomic, weak) IBOutlet UILabel* frequencyLabel;
@property(nonatomic, weak) IBOutlet UIButton* frequencyButton;
@property(nonatomic, weak) Deposit* event;
@property(nonatomic, weak) WeekTotal* weekTotal;
@property(nonatomic, retain) id<FrequencyPicker> frequencyDelegate;

-(IBAction)repeatButtonPressed:(id)sender;

@end

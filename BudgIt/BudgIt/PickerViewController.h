//
//  PickerViewController.h
//  BudgIt
//
//  Created by Eric Eisner on 6/19/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillDepositProtocols.h"

@protocol PickerView <NSObject>

-(void)pickerValueChoosen:(BOOL)isReminder WithValue:(NSString*)value;

@end

@interface PickerViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, weak) IBOutlet UIPickerView* picker;
@property(nonatomic, weak) IBOutlet UIButton* closeButton;
@property(nonatomic) BOOL isReminder;
@property(nonatomic, strong) NSString* value;
@property(nonatomic, retain) id<PickerView> pickerDelegate;

-(IBAction)closeWindow;

@end

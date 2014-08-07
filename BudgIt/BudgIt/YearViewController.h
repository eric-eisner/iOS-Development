//
//  YearViewController.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Month;
@class Year;

@protocol ChangeMonthYearDelegate <NSObject>
-(void)selectedDate;
@optional

@end

@interface YearViewController : UIViewController

@property(nonatomic, retain) IBOutletCollection(UIButton) NSMutableArray* monthButtons;
@property(nonatomic, weak) IBOutlet UIButton* yearButton;
@property(nonatomic, weak) IBOutlet UIView* yearView;
@property(nonatomic, weak) IBOutlet UIBarButtonItem* prevButton;
@property(nonatomic, weak) Year* year;
@property(nonatomic, weak) Month* month;
@property(nonatomic, weak) id <ChangeMonthYearDelegate> delegate;

-(IBAction)monthSelected:(id)sender;
-(IBAction)previousYear;
-(IBAction)nextYear;

@end

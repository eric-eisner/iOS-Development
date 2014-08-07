//
//  CalendarView.h
//  BudgIt
//
//  Created by Eric Eisner on 6/1/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView

@property(nonatomic, weak) IBOutletCollection(UIButton) NSMutableArray* days;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder;

@end

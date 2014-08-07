//
//  YearView.h
//  BudgIt
//
//  Created by Eric Eisner on 6/2/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearView : UIView

@property(nonatomic, weak) IBOutletCollection(UIButton) NSMutableArray* monthButtons;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)decodeRestorableStateWithCoder:(NSCoder *)coder;

@end

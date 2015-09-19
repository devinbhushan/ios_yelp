//
//  SwitchCell.h
//  Yelp
//
//  Created by Devin Bhushan on 9/18/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchCell;

@protocol SwitchCellDelegate <NSObject>

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value;

@end

@interface SwitchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) BOOL on;
@property(weak, nonatomic) id<SwitchCellDelegate> delegate;

-(void)setOn:(BOOL)on animated:(BOOL)animated;
@end

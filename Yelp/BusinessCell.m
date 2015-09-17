//
//  BusinessCellTableViewCell.m
//  Yelp
//
//  Created by Devin Bhushan on 9/16/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()

@property(weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property(weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property(weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property(weak, nonatomic) IBOutlet UILabel *addressLabel;
@property(weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business {
  _business = business;
  [self.thumbImageView
      setImageWithURL:[NSURL URLWithString:self.business.imageURL]];
  self.nameLabel.text = self.business.name;
  self.reviewLabel.text = [NSString
      stringWithFormat:@"%ld Reviews", (long)self.business.numReviews];
  // TODO Finish initializing here then fix table datasource funcs in main view
  // controller
}

@end

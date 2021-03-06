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
  self.thumbImageView.layer.cornerRadius = 3;
  self.thumbImageView.clipsToBounds = YES;
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
  [self.ratingImageView
      setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
  self.distanceLabel.text =
      [NSString stringWithFormat:@"%.2f mi", (float)self.business.distance];
  self.addressLabel.text = self.business.address;
  self.categoryLabel.text = self.business.categories;
}

@end

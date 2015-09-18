//
//  Business.m
//  Yelp
//
//  Created by Devin Bhushan on 9/16/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];

  if (self) {
    NSArray *categories = dictionary[@"categories"];
    NSMutableArray *categoryNames = [NSMutableArray array];
    [categories
        enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          [categoryNames addObject:obj[0]];
        }];
    self.categories = [categoryNames componentsJoinedByString:@", "];
    float milesPerMeter = 0.000621371;
    self.distance = ([dictionary[@"distance"] integerValue] * milesPerMeter);
    NSDictionary *location = dictionary[@"location"];
    NSString *address =
        [location[@"address"] count] > 0 ? location[@"address"][0] : @"";
    self.address =
        [NSString stringWithFormat:@"%@, %@", address, location[@"city"]];
    self.numReviews = [dictionary[@"review_count"] integerValue];
    self.ratingImageUrl = dictionary[@"rating_img_url"];
    self.name = dictionary[@"name"];
    self.imageURL = dictionary[@"image_url"];
  }
  return self;
}

+ (NSMutableArray *)businessesWithDictionaries:(NSMutableArray *)dictionaries {
  NSMutableArray *businesses = [NSMutableArray array];
  for (NSDictionary *dictionary in dictionaries) {
    Business *business = [[Business alloc] initWithDictionary:dictionary];
    [businesses addObject:business];
  }

  return businesses;
}

@end

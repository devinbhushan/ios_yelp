//
//  Business.h
//  Yelp
//
//  Created by Devin Bhushan on 9/16/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property(nonatomic, strong) NSString *imageURL;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *ratingImageUrl;
@property(nonatomic, assign) NSInteger numReviews;
@property(nonatomic, strong) NSString *address;
@property(nonatomic, strong) NSString *categories;
@property(nonatomic, assign) CGFloat distance;

+ (NSMutableArray *)businessesWithDictionaries:(NSMutableArray *)dictionaries;

@end

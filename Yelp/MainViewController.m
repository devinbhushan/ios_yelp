//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"

NSString *const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString *const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString *const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString *const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) YelpClient *client;
@property(weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property(nonatomic, strong) NSArray *businesses;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // You can register for Yelp API keys here:
    // http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey
                                           consumerSecret:kYelpConsumerSecret
                                              accessToken:kYelpToken
                                             accessSecret:kYelpTokenSecret];

    [self.client searchWithTerm:@"Thai"
        success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"response: %@", response);
          NSArray *businessDictionaries =
              [Business businessesWithDictionaries:response[@"businesses"]];
          NSLog(@"Got businesses: %@", businessDictionaries);
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"error: %@", [error description]);
        }];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.resultsTableView.delegate = self;
  self.resultsTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end

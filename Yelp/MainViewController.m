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
#import "BusinessCell.h"

NSString *const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString *const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString *const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString *const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate,
                                  UISearchBarDelegate>

@property(nonatomic, strong) YelpClient *client;
@property(weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property(nonatomic, strong) NSMutableArray *businesses;
@property(nonatomic, strong) NSMutableArray *filteredBusinesses;
@property(weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property(weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.searchBar.delegate = self;
  self.filteredBusinesses = self.businesses;

  self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey
                                         consumerSecret:kYelpConsumerSecret
                                            accessToken:kYelpToken
                                           accessSecret:kYelpTokenSecret];

  [self.client searchWithTerm:@""
      success:^(AFHTTPRequestOperation *operation, id response) {
        //        NSLog(@"Got response: %@", response);
        self.businesses =
            [Business businessesWithDictionaries:response[@"businesses"]];
        self.filteredBusinesses = self.businesses;
        [self.resultsTableView reloadData];
        //        NSLog(@"Got businesses: %@", self.businesses);
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
      }];

  self.resultsTableView.delegate = self;
  self.resultsTableView.dataSource = self;
  [self.resultsTableView
                 registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil]
      forCellReuseIdentifier:@"com.yahoo.BusinessCell"];
  self.resultsTableView.estimatedRowHeight = 87;
  self.resultsTableView.rowHeight = UITableViewAutomaticDimension;
  [self.resultsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.filteredBusinesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BusinessCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"com.yahoo.BusinessCell"];
  Business *business = self.filteredBusinesses[indexPath.row];
  [cell setBusiness:business];
  return cell;
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
  NSLog(@"TEXT DID CHANGE!");
  [self.filteredBusinesses removeAllObjects]; // remove all data that belongs to
  // previous
  // search
  if ([searchText isEqualToString:@""] || searchText == nil) {
    self.filteredBusinesses = self.businesses;
    [self.resultsTableView reloadData];
    return;
  }
  [self.client searchWithTerm:searchText
      success:^(AFHTTPRequestOperation *operation, id response) {
        self.businesses =
            [Business businessesWithDictionaries:response[@"businesses"]];
        self.filteredBusinesses = self.businesses;
        [self.resultsTableView reloadData];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
      }];
}

@end

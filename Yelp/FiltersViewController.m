//
//  FiltersViewController.m
//  Yelp
//
//  Created by Devin Bhushan on 9/18/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDelegate, UITableViewDataSource,
                                     SwitchCellDelegate>

@property(nonatomic, readonly) NSDictionary *filters;
@property(strong, nonatomic) IBOutlet UITableView *filterTableView;
@property(strong, nonatomic) NSArray *categories;
@property(strong, nonatomic) NSArray *sorts;
@property(strong, nonatomic) NSArray *distances;
@property(strong, nonatomic) NSMutableSet *selectedCategories;
@property(strong, nonatomic) NSMutableSet *selectedSorts;
@property(strong, nonatomic) NSMutableSet *selectedDistances;

- (void)setCategories;
- (void)setSorts;
- (void)setDistances;
@end

@implementation FiltersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self setCategories];
    [self setSorts];
    [self setDistances];
    self.selectedCategories = [NSMutableSet set];
    self.selectedSorts = [NSMutableSet set];
    self.selectedDistances = [NSMutableSet set];
  }
  return self;
}

- (void)setCategories {
  self.categories = [self getCategories];
}

- (void)setSorts {
  self.sorts = [self getSorts];
}

- (void)setDistances {
  self.distances = [self getDistances];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(onCancelButton)];
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(onApplyButton)];
  self.filterTableView.delegate = self;
  self.filterTableView.dataSource = self;

  [self.filterTableView
                 registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil]
      forCellReuseIdentifier:@"SwitchCell"];
  [self.filterTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  switch (section) {

  case 0:
    return [[self getSorts] count];

  case 1:
    return [[self getDistances] count];

  case 2:
    return [[self getCategories] count];

  default:
    return 0;
  }
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  switch (section) {
  case 0:
    return @"Sort By";
  case 1:
    return @"Distance";
  case 2:
    return @"Category";
  default:
    return @"";
  }
}
//- (NSString *)titleForHeaderInSection {

//}

- (void)onCancelButton {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
  [self.delegate filtersViewController:self didChangeFilters:self.filters];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section {
//  return self.categories.count;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SwitchCell *cell =
      [self.filterTableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
  cell.delegate = self;

  switch (indexPath.section) {
  case 0: {
    cell.titleLabel.text = self.sorts[indexPath.row][@"name"];
    cell.on = [self.selectedSorts
        containsObject:[self.sorts objectAtIndex:indexPath.row]];
    cell.delegate = self;
  }
  case 1: {
    cell.titleLabel.text = self.distances[indexPath.row][@"name"];
    cell.on = [self.selectedDistances
        containsObject:[self.distances objectAtIndex:indexPath.row]];
    cell.delegate = self;
  }
  case 2: {
    cell.titleLabel.text = self.categories[indexPath.row][@"name"];
    cell.on = [self.selectedCategories
        containsObject:[self.categories objectAtIndex:indexPath.row]];
    cell.delegate = self;
  }
  }

  return cell;
}

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
  NSIndexPath *indexPath = [self.filterTableView indexPathForCell:cell];

  switch (indexPath.section) {
  case 0: {
    if (value) {
      [self.selectedSorts addObject:[self.sorts objectAtIndex:indexPath.row]];
    } else {
      [self.selectedSorts
          removeObject:[self.sorts objectAtIndex:indexPath.row]];
    }
  }
  case 1: {
    if (value) {
      [self.selectedDistances
          addObject:[self.distances objectAtIndex:indexPath.row]];
    } else {
      [self.selectedDistances
          removeObject:[self.distances objectAtIndex:indexPath.row]];
    }
  }
  case 2: {
    if (value) {
      [self.selectedCategories
          addObject:[self.categories objectAtIndex:indexPath.row]];
    } else {
      [self.selectedCategories
          removeObject:[self.categories objectAtIndex:indexPath.row]];
    }
  }
  }
  //  NSDictionary *category = [self.categories objectAtIndex:indexPath.row];
  //  cell.titleLabel = category[@"name"];
}

- (NSDictionary *)filters {
  NSMutableDictionary *filters = [NSMutableDictionary dictionary];

  if (self.selectedCategories.count > 0) {
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *category in self.selectedCategories) {
      [names addObject:category[@"value"]];
    }
    NSString *categoryFilter = [names componentsJoinedByString:@","];
    [filters setObject:categoryFilter forKeyedSubscript:@"category_filter"];
  }

  return filters;
}

- (NSArray *)getSorts {
  NSArray *sorts = @[
    @{
      @"name" : @"Best",
      @"value" : @"0"
    },
    @{
      @"name" : @"Distance",
      @"value" : @"1"
    },
    @{
      @"name" : @"Highest Rated",
      @"value" : @"2"
    }
  ];

  return sorts;
}

- (NSArray *)getDistances {
  NSArray *distances = @[
    @{
      @"name" : @"5 miles",
      @"value" : @"8046"
    },
    @{
      @"name" : @"10 miles",
      @"value" : @"16093"
    },
    @{
      @"name" : @"20 miles",
      @"value" : @"32186"
    },
    @{
      @"name" : @"25 miles",
      @"value" : @"40233"
    }
  ];

  return distances;
}

- (NSArray *)getCategories {
  NSArray *categories = @[
    @{
      @"name" : @"Afghan",
      @"value" : @"afghani"
    },
    @{
      @"name" : @"African",
      @"value" : @"african"
    },
    @{
      @"name" : @"American (New)",
      @"value" : @"newamerican"
    },
    @{
      @"name" : @"American (Traditional)",
      @"value" : @"tradamerican"
    },
    @{
      @"name" : @"Argentine",
      @"value" : @"argentine"
    },
    @{
      @"name" : @"Asian Fusion",
      @"value" : @"asianfusion"
    },
    @{
      @"name" : @"Barbeque",
      @"value" : @"bbq"
    },
    @{
      @"name" : @"Basque",
      @"value" : @"basque"
    },
    @{
      @"name" : @"Belgian",
      @"value" : @"belgian"
    },
    @{
      @"name" : @"Brasseries",
      @"value" : @"brasseries"
    },
    @{
      @"name" : @"Brazilian",
      @"value" : @"brazilian"
    },
    @{
      @"name" : @"Breakfast & Brunch",
      @"value" : @"breakfast_brunch"
    },
    @{
      @"name" : @"British",
      @"value" : @"british"
    },
    @{
      @"name" : @"Buffets",
      @"value" : @"buffets"
    },
    @{
      @"name" : @"Burgers",
      @"value" : @"burgers"
    },
    @{
      @"name" : @"Burmese",
      @"value" : @"burmese"
    },
    @{
      @"name" : @"Cafes",
      @"value" : @"cafes"
    },
    @{
      @"name" : @"Cajun/Creole",
      @"value" : @"cajun"
    },
    @{
      @"name" : @"Cambodian",
      @"value" : @"cambodian"
    },
    @{
      @"name" : @"Caribbean",
      @"value" : @"caribbean"
    },
    @{
      @"name" : @"Cheesesteaks",
      @"value" : @"cheesesteaks"
    },
    @{
      @"name" : @"Chicken Wings",
      @"value" : @"chicken_wings"
    },
    @{
      @"name" : @"Chinese",
      @"value" : @"chinese"
    },
    @{
      @"name" : @"Creperies",
      @"value" : @"creperies"
    },
    @{
      @"name" : @"Cuban",
      @"value" : @"cuban"
    },
    @{
      @"name" : @"Delis",
      @"value" : @"delis"
    },
    @{
      @"name" : @"Diners",
      @"value" : @"diners"
    },
    @{
      @"name" : @"Ethiopian",
      @"value" : @"ethiopian"
    },
    @{
      @"name" : @"Fast Food",
      @"value" : @"hotdogs"
    },
    @{
      @"name" : @"Filipino",
      @"value" : @"filipino"
    },
    @{
      @"name" : @"Fish & Chips",
      @"value" : @"fishnchips"
    },
    @{
      @"name" : @"Fondue",
      @"value" : @"fondue"
    },
    @{
      @"name" : @"Food Stands",
      @"value" : @"foodstands"
    },
    @{
      @"name" : @"French",
      @"value" : @"french"
    },
    @{
      @"name" : @"Gastropubs",
      @"value" : @"gastropubs"
    },
    @{
      @"name" : @"German",
      @"value" : @"german"
    },
    @{
      @"name" : @"Gluten-Free",
      @"value" : @"gluten_free"
    },
    @{
      @"name" : @"Greek",
      @"value" : @"greek"
    },
    @{
      @"name" : @"Halal",
      @"value" : @"halal"
    },
    @{
      @"name" : @"Hawaiian",
      @"value" : @"hawaiian"
    },
    @{
      @"name" : @"Himalayan/Nepalese",
      @"value" : @"himalayan"
    },
    @{
      @"name" : @"Hot Dogs",
      @"value" : @"hotdog"
    },
    @{
      @"name" : @"Hungarian",
      @"value" : @"hungarian"
    },
    @{
      @"name" : @"Indian",
      @"value" : @"indpak"
    },
    @{
      @"name" : @"Indonesian",
      @"value" : @"indonesian"
    },
    @{
      @"name" : @"Irish",
      @"value" : @"irish"
    },
    @{
      @"name" : @"Italian",
      @"value" : @"italian"
    },
    @{
      @"name" : @"Japanese",
      @"value" : @"japanese"
    },
    @{
      @"name" : @"Korean",
      @"value" : @"korean"
    },
    @{
      @"name" : @"Kosher",
      @"value" : @"kosher"
    },
    @{
      @"name" : @"Latin American",
      @"value" : @"latin"
    },
    @{
      @"name" : @"Live/Raw Food",
      @"value" : @"raw_food"
    },
    @{
      @"name" : @"Malaysian",
      @"value" : @"malaysian"
    },
    @{
      @"name" : @"Mediterranean",
      @"value" : @"mediterranean"
    },
    @{
      @"name" : @"Mexican",
      @"value" : @"mexican"
    },
    @{
      @"name" : @"Middle Eastern",
      @"value" : @"mideastern"
    },
    @{
      @"name" : @"Modern European",
      @"value" : @"modern_european"
    },
    @{
      @"name" : @"Mongolian",
      @"value" : @"mongolian"
    },
    @{
      @"name" : @"Moroccan",
      @"value" : @"moroccan"
    },
    @{
      @"name" : @"Pakistani",
      @"value" : @"pakistani"
    },
    @{
      @"name" : @"Persian/Iranian",
      @"value" : @"persian"
    },
    @{
      @"name" : @"Peruvian",
      @"value" : @"peruvian"
    },
    @{
      @"name" : @"Pizza",
      @"value" : @"pizza"
    },
    @{
      @"name" : @"Polish",
      @"value" : @"polish"
    },
    @{
      @"name" : @"Portuguese",
      @"value" : @"portuguese"
    },
    @{
      @"name" : @"Russian",
      @"value" : @"russian"
    },
    @{
      @"name" : @"Salad",
      @"value" : @"salad"
    },
    @{
      @"name" : @"Sandwiches",
      @"value" : @"sandwiches"
    },
    @{
      @"name" : @"Scandinavian",
      @"value" : @"scandinavian"
    },
    @{
      @"name" : @"Seafood",
      @"value" : @"seafood"
    },
    @{
      @"name" : @"Singaporean",
      @"value" : @"singaporean"
    },
    @{
      @"name" : @"Soul Food",
      @"value" : @"soulfood"
    },
    @{
      @"name" : @"Soup",
      @"value" : @"soup"
    },
    @{
      @"name" : @"Southern",
      @"value" : @"southern"
    },
    @{
      @"name" : @"Spanish",
      @"value" : @"spanish"
    },
    @{
      @"name" : @"Steakhouses",
      @"value" : @"steak"
    },
    @{
      @"name" : @"Sushi Bars",
      @"value" : @"sushi"
    },
    @{
      @"name" : @"Taiwanese",
      @"value" : @"taiwanese"
    },
    @{
      @"name" : @"Tapas Bars",
      @"value" : @"tapas"
    },
    @{
      @"name" : @"Tapas/Small Plates",
      @"value" : @"tapasmallplates"
    },
    @{
      @"name" : @"Tex-Mex",
      @"value" : @"tex-mex"
    },
    @{
      @"name" : @"Thai",
      @"value" : @"thai"
    },
    @{
      @"name" : @"Turkish",
      @"value" : @"turkish"
    },
    @{
      @"name" : @"Ukrainian",
      @"value" : @"ukrainian"
    },
    @{
      @"name" : @"Vegan",
      @"value" : @"vegan"
    },
    @{
      @"name" : @"Vegetarian",
      @"value" : @"vegetarian"
    },
    @{
      @"name" : @"Vietnamese",
      @"value" : @"vietnamese"
    }
  ];

  return categories;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  ViewController.m
//  HW_35_UISearch
//
//

#import "ViewController.h"
#import "ASStudents.h"
#import "ASSection.h"

#import "ASNameFamalyAndImage.h"
#import "CustomCell.h"



typedef NS_ENUM(NSInteger, ASSortedSegment) {
    ASSortedDate = 0,
    ASSortedName = 1,
    ASSortedFamaly = 2
};


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic) NSMutableArray* arrayStudents;
@property (strong, nonatomic)  NSArray*        sectionsArray;

@property (strong, nonatomic)  NSOperation*     operation;

@property (strong, nonatomic) UIActivityIndicatorView* indicator;

- (IBAction)segmentControlAction:(id)sender;


@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Установка индектора кручения :)
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
     indicator.frame = CGRectMake(0, 0, 40, 40);
     indicator.center = self.view.center;
    
    self.indicator = indicator;
    [self.tableView addSubview: self.indicator];
    [self.indicator startAnimating];
    
    
    self.segmentControl.selectedSegmentIndex = 0;
    
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        ASNameFamalyAndImage* obj = [[ASNameFamalyAndImage alloc]init];
        NSMutableArray* array = [NSMutableArray array];

        
        for (int i=0; i<1500; i++) {
            NSString* name   = [obj.arrayNames objectAtIndex:   arc4random()%[obj.arrayNames count]];
            NSString* famaly = [obj.arrayFamaly objectAtIndex:  arc4random()%[obj.arrayFamaly count]];
            NSString* image  = [obj.arrayImages objectAtIndex:  arc4random()%[obj.arrayImages count]];
            
            ASStudents* student = [[ASStudents alloc] initWithName:name andFamaly:famaly andImage:image];
            [array addObject:student];
        }
        obj = nil;
        self.arrayStudents = array;

            NSSortDescriptor* sortByMonth = [NSSortDescriptor sortDescriptorWithKey:@"components.month" ascending:YES];
            NSSortDescriptor* sortByDay   = [NSSortDescriptor sortDescriptorWithKey:@"components.day"   ascending:YES];
            NSSortDescriptor* sortByYear  = [NSSortDescriptor sortDescriptorWithKey:@"components.year"  ascending:YES];

           [self.arrayStudents sortUsingDescriptors:[NSArray arrayWithObjects:sortByMonth,sortByDay,sortByYear,nil]];

           [self generateSectionsInBackgroundFromArray:self.arrayStudents withFilter:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.indicator stopAnimating];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) generateSectionsInBackgroundFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    
    
    [self.operation cancel];
    
    __weak ViewController* weakSelf = self;

    self.operation = [NSBlockOperation blockOperationWithBlock:^{
        
        [self.indicator startAnimating];
        weakSelf.sectionsArray = [NSArray array];
        [weakSelf.tableView reloadData];

        NSArray* sectionsArray = [weakSelf generateSectionFromArray:array withFilter:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionsArray = sectionsArray;
            [weakSelf.tableView reloadData];
            [self.indicator stopAnimating];

            self.operation = nil;
        });
    }];
    [self.operation start];

}

-(NSArray*) generateSectionFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    
  
    NSMutableArray* sectionArray = [NSMutableArray array];
    NSString*       currentMonth = nil;
    
    NSSortDescriptor* sortByName     = [NSSortDescriptor sortDescriptorWithKey:@"name"     ascending:YES];
    NSSortDescriptor* sortByFamaly   = [NSSortDescriptor sortDescriptorWithKey:@"famaly"   ascending:YES];
    NSSortDescriptor* sortByDay      = [NSSortDescriptor sortDescriptorWithKey:@"components.day"   ascending:YES];
    NSSortDescriptor* sortByYear     = [NSSortDescriptor sortDescriptorWithKey:@"components.year"  ascending:YES];
    NSSortDescriptor* sortByMonth    = [NSSortDescriptor sortDescriptorWithKey:@"components.month" ascending:YES];

    if (self.segmentControl.selectedSegmentIndex == ASSortedDate) {
        
    sortByName   = nil;
    sortByFamaly = nil;
    [self.arrayStudents sortUsingDescriptors:[NSArray arrayWithObjects:sortByMonth,sortByDay,sortByYear,nil]];
        
    }
    if (self.segmentControl.selectedSegmentIndex == ASSortedName) {
        
        sortByDay  = nil;
        sortByMonth = nil;
        sortByYear = nil;
        sortByFamaly = nil;
        [self.arrayStudents sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,nil]];
     }
    if (self.segmentControl.selectedSegmentIndex == ASSortedFamaly) {
        
        sortByDay  = nil;
        sortByMonth = nil;
        sortByYear = nil;
        sortByName = nil;
        [self.arrayStudents sortUsingDescriptors:[NSArray arrayWithObjects:sortByFamaly,nil]];
    }

     for (ASStudents* students in self.arrayStudents) {
        
         NSString* fullName;
         
         if (self.segmentControl.selectedSegmentIndex == ASSortedDate) {
             fullName = [NSString stringWithFormat:@"%@ %@",students.name,students.famaly];
         }
         
         if (self.segmentControl.selectedSegmentIndex == ASSortedName) {
             fullName = [NSString stringWithFormat:@"%@",students.name];
          }
         
         if (self.segmentControl.selectedSegmentIndex == ASSortedFamaly) {

            fullName = [NSString stringWithFormat:@"%@",students.famaly];
          }
         
         
        if ([filterString length] > 0 && [fullName rangeOfString:filterString].location == NSNotFound)
            continue;
         
         NSLog(@"Вот тебе фулнэйм сука = %@",fullName);
        
         NSString* firstMonth;
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"MMM"];
         
        if (self.segmentControl.selectedSegmentIndex == ASSortedDate) {
        
            firstMonth = [dateFormatter stringFromDate:students.date];
        }
        
        if (self.segmentControl.selectedSegmentIndex == ASSortedName) {
           firstMonth = [students.name substringToIndex:1];
        }
        
        if (self.segmentControl.selectedSegmentIndex == ASSortedFamaly) {
            firstMonth = [students.famaly substringToIndex:1];
        }
        
        ASSection* section = nil;
        
        if (![currentMonth isEqualToString:firstMonth]) {
            section = [[ASSection alloc] init];
            section.nameSection = firstMonth;
            section.arrayForStudents = [NSMutableArray array];
            currentMonth = firstMonth;
            [sectionArray addObject:section];

        } else {
            section = [sectionArray lastObject];
        }
        
        [section.arrayForStudents addObject:students];

        
        [section.arrayForStudents sortUsingDescriptors:[NSArray arrayWithObjects:sortByName,sortByFamaly,sortByDay,sortByMonth,sortByYear,nil]];

        NSInteger index = [sectionArray count]-1;
        [sectionArray removeLastObject];
        [sectionArray insertObject:section atIndex:index];
        
    }
    
    return sectionArray;
}




#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray* array = [NSMutableArray array];
    
    for (ASSection* section in self.sectionsArray) {
        [array addObject:section.nameSection];
    }
    
    return array;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.sectionsArray objectAtIndex:section] nameSection];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ASSection* sec = [self.sectionsArray objectAtIndex:section];
    return [sec.arrayForStudents count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static NSString* identifier = @"Cell";
    
    CustomCell* cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    
    // Распаковка

    ASSection*   section = [self.sectionsArray objectAtIndex:indexPath.section];
    
    NSString* name   = [[section.arrayForStudents objectAtIndex:indexPath.row] name];
    NSString* famaly = [[section.arrayForStudents objectAtIndex:indexPath.row] famaly];
    NSDate*   date   = [[section.arrayForStudents objectAtIndex:indexPath.row] date];
    NSString* image  = [[section.arrayForStudents objectAtIndex:indexPath.row] nameImage];

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString* dateOfString    = [dateFormatter stringFromDate:date];
    
    
    cell.nameLabel.text       = [NSString stringWithFormat:@"%@ %@",name,famaly];
    cell.dateLabel.text       = dateOfString;
    cell.img.image      = [UIImage imageNamed:image];
    cell.img.layer.cornerRadius = 17;
    cell.img.layer.masksToBounds = YES;
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    
    
    [self.operation cancel];
     self.operation = nil;
    
    [self.indicator startAnimating];
    self.sectionsArray = [NSArray array];
    [self.tableView reloadData];

    
    
    [self generateSectionsInBackgroundFromArray:self.arrayStudents withFilter:self.searchBar.text];
    
}







#pragma mark - UISegmentControl

- (IBAction)segmentControlAction:(id)sender {
    [self.operation cancel];
     self.operation = nil;
    
    [self generateSectionsInBackgroundFromArray:self.arrayStudents withFilter:self.searchBar.text];
}

@end

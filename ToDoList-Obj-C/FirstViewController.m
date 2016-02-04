//
//  FirstViewController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "FirstViewController.h"
#import "ToDoPendingListTableViewCell.h"
#import "ToDoBusinessController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController

+ (FirstViewController *)sharedInstance {
    static dispatch_once_t onceToken;
    static FirstViewController *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[FirstViewController alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _toDoPendingListViewModel = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.toDoPendingListTable setDelegate:self];
    [self.toDoPendingListTable setDataSource:self];
    self.toDoPendingListViewModel = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"])
        self.toDoPendingListViewModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    else {
        [[NSUserDefaults standardUserDefaults] setObject:self.toDoPendingListViewModel forKey:@"toDoPendingList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    self.toDoPendingListViewModel = [toDoBusiness setDate:self.toDoPendingListViewModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    self.toDoPendingListViewModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
    [self.toDoPendingListTable reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoPendingListViewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellView;
    ToDoPendingListTableViewCell *toDoPendingTableViewCell = (ToDoPendingListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ToDoPendingListViewCell" forIndexPath:indexPath];
    toDoPendingTableViewCell.leftUtilityButtons = [self leftButtons];
    toDoPendingTableViewCell.rightUtilityButtons = [self rightButtons];
    toDoPendingTableViewCell.delegate = self;
    SEL selector = @selector(setToDoPendingListModel:);
    if([toDoPendingTableViewCell respondsToSelector:selector]) {
        NSMutableDictionary *toDoPendingCellViewModel = [self.toDoPendingListViewModel objectAtIndex:indexPath.row];
        [toDoPendingTableViewCell setToDoPendingListModel:toDoPendingCellViewModel];
    }
    cellView = toDoPendingTableViewCell;
    cellView.backgroundColor = [UIColor clearColor];
    cellView.backgroundView = [[UIImageView alloc] init];
    cellView.selectedBackgroundView = [[UIImageView alloc] init];
    return cellView;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:[UIImage imageNamed:@"edit64x64.png"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:[UIImage imageNamed:@"delete64x64.png"]];
    return rightUtilityButtons;
}

- (NSArray *)leftButtons {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:[UIImage imageNamed:@"email64x64.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:[UIImage imageNamed:@"sms64x64.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:[UIImage imageNamed:@"facebook64x64.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor] icon:[UIImage imageNamed:@"twitter64x64.png"]];
    return leftUtilityButtons;
}

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"email button was pressed");
            break;
        case 1:
            NSLog(@"sms button was pressed");
            break;
        case 2:
            NSLog(@"facebook button was pressed");
            break;
        case 3:
            NSLog(@"twitter button was pressed");
        default:
            break;
    }
}

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"Edit button was pressed");
            break;
        case 1:
        {
            NSLog(@"Delete button was pressed");
            NSIndexPath *cellIndexPath = [self.toDoPendingListTable indexPathForCell:cell];
            [self.toDoPendingListViewModel removeObjectAtIndex:cellIndexPath.row];
            [self.toDoPendingListTable deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NSUserDefaults standardUserDefaults] setObject:self.toDoPendingListViewModel forKey:@"toDoPendingList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.toDoPendingListViewModel = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"] mutableCopy];
            [self.toDoPendingListTable reloadData];
            break;
        }
        default:
            break;
    }
}

// utility button open/close event
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state {
    
}

// prevent multiple cells from showing utilty buttons simultaneously
/*- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
}

// prevent cell(s) from displaying left/right utility buttons
- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
}*/

#pragma mark UITable Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end

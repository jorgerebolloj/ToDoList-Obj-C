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
    [self.mSearchBar setDelegate:self];
    UITextField *textField = [self.mSearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    [self.toDoPendingListTable setDelegate:self];
    [self.toDoPendingListTable setDataSource:self];
    
    self.toDoPendingListViewModel = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"]) {
        ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
        self.toDoPendingListViewModel = [toDoBusiness requestPendingModel];
        self.toDoPendingListViewModel = [toDoBusiness setDate:self.toDoPendingListViewModel];
        [toDoBusiness storePendingModel:self.toDoPendingListViewModel];
    } else {
        ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
        [toDoBusiness storePendingModel:self.toDoPendingListViewModel];
    }
    
    self.filteredModel = [[NSMutableArray alloc] init];
    //[self.filteredModel addObjectsFromArray:[self.toDoPendingListViewModel mutableCopy]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    self.toDoPendingListViewModel = [toDoBusiness requestPendingModel];
    [self.toDoPendingListTable reloadData];
}

- (void)keyboardShown:(NSNotification *)notification {
    CGRect keyboardFrame;
    [[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey]getValue:&keyboardFrame];
    CGRect tableViewFrame = self.toDoPendingListTable.frame;
    tableViewFrame.size.height -= keyboardFrame.size.height;
    [self.toDoPendingListTable setFrame:tableViewFrame];
}

- (void)keyboardHidden:(NSNotification *)notification {
    [self.toDoPendingListTable setFrame:self.view.bounds];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.filteredModel count] != 0)
        return [self.filteredModel count];
    else
        return [self.toDoPendingListViewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoPendingListTableViewCell *toDoPendingTableViewCell = (ToDoPendingListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ToDoPendingListViewCell" forIndexPath:indexPath];
    
    toDoPendingTableViewCell.leftUtilityButtons = [self leftButtons];
    toDoPendingTableViewCell.rightUtilityButtons = [self rightButtons];
    toDoPendingTableViewCell.delegate = self;
    
    SEL selector = @selector(setToDoPendingListModel:);
    if([toDoPendingTableViewCell respondsToSelector:selector]) {
        NSMutableDictionary *toDoPendingCellViewModel = [[NSMutableDictionary alloc]init];
        if ([self.filteredModel count] != 0)
            toDoPendingCellViewModel = [self.filteredModel objectAtIndex:indexPath.row];
        else
            toDoPendingCellViewModel = [self.toDoPendingListViewModel objectAtIndex:indexPath.row];
        [toDoPendingTableViewCell setToDoPendingListModel:toDoPendingCellViewModel];
    }
    
    UITableViewCell *cellView;
    cellView = toDoPendingTableViewCell;
    cellView.backgroundColor = [UIColor clearColor];
    cellView.backgroundView = [[UIImageView alloc] init];
    cellView.selectedBackgroundView = [[UIImageView alloc] init];
    return cellView;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.mSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.mSearchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.filteredModel removeAllObjects];
        //[self.filteredModel addObjectsFromArray:[self.toDoPendingListViewModel mutableCopy]];
    } else {
        [self.filteredModel removeAllObjects];
        for (NSString *itemToDo in self.toDoPendingListViewModel) {
            NSString *stringToDoTitle = [[itemToDo valueForKeyPath:@"title"] description];
            NSRange range = [stringToDoTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound )
                [self.filteredModel addObject:itemToDo];
        }
    }
    [self.toDoPendingListTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self.mSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self.mSearchBar resignFirstResponder];
    [self.filteredModel  removeAllObjects];
    [self.toDoPendingListTable reloadData];
}

#pragma mark - SWTableViewCell
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
        {
            NSLog(@"Edit button was pressed");
            NSIndexPath *cellIndexPath = [self.toDoPendingListTable indexPathForCell:cell];
            NSMutableDictionary *toDoPendingCellViewModel = [[NSMutableDictionary alloc]init];
            int toDoId = 0;
            if ([self.filteredModel count] != 0)
                toDoPendingCellViewModel = [[self.filteredModel objectAtIndex:cellIndexPath.row] mutableCopy];
            else
                toDoPendingCellViewModel = [[self.toDoPendingListViewModel objectAtIndex:cellIndexPath.row] mutableCopy];
            
            toDoId = [[toDoPendingCellViewModel valueForKeyPath:@"id"]intValue];
            ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
            [toDoBusiness setExitingItemToEdit:self.toDoPendingListViewModel withSelecteRow:toDoId];
            [self.filteredModel removeAllObjects];
            [self performSegueWithIdentifier:@"singleToDoViewSegue" sender:self];
            break;
        }
        case 1:
        {
            NSLog(@"Delete button was pressed");
            NSIndexPath *cellIndexPath = [self.toDoPendingListTable indexPathForCell:cell];
            NSMutableDictionary *toDoPendingCellViewModel = [[NSMutableDictionary alloc]init];
            int toDoId = 0;
            if ([self.filteredModel count] != 0) {
                toDoPendingCellViewModel = [[self.filteredModel objectAtIndex:cellIndexPath.row] mutableCopy];
                [self.filteredModel removeAllObjects];
            } else 
                toDoPendingCellViewModel = [[self.toDoPendingListViewModel objectAtIndex:cellIndexPath.row] mutableCopy];
            
            toDoId = [[toDoPendingCellViewModel valueForKeyPath:@"id"] intValue];
            [self.toDoPendingListViewModel removeObjectAtIndex:toDoId];
            [self.toDoPendingListTable deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.filteredModel removeAllObjects];
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

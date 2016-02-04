//
//  SecondViewController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "SecondViewController.h"
#import "ToDoCompletedListTableViewCell.h"
#import "ToDoBusinessController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.toDoCompletedListTable setDelegate:self];
    [self.toDoCompletedListTable setDataSource:self];
    self.toDoCompletedListViewModel = [NSMutableArray arrayWithArray:@[
                                                                     @{
                                                                         @"title"      : @"Buy nutella",
                                                                         @"modifiedDate" : @"2016/02/01 02:45 AM",
                                                                         @"status"    : @0,
                                                                         @"image"    : @"image512x512.png",
                                                                         },
                                                                     @{
                                                                         @"title"      : @"Learn english",
                                                                         @"modifiedDate" : @"2016/01/18 02:45 AM",
                                                                         @"status"    : @0,
                                                                         @"image"    : @"image512x512.png",
                                                                         },
                                                                     @{
                                                                         @"title"      : @"Play Dragon Age",
                                                                         @"modifiedDate" : @"2016/01/10 02:45 AM",
                                                                         @"status"    : @0,
                                                                         @"image"    : @"image512x512.png",
                                                                         },
                                                                     ]];
    ToDoBusinessController *toDoBusinessInstance = [[ToDoBusinessController alloc] init];
    self.toDoCompletedListViewModel = [toDoBusinessInstance setDate:self.toDoCompletedListViewModel];
    self.dateString = [toDoBusinessInstance dateTimeConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoCompletedListViewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellView;
    ToDoCompletedListTableViewCell *toDoCompletedTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCompletedListViewCell" forIndexPath:indexPath];
    SEL selector = @selector(setToDoCompletedListModel:);
    if([toDoCompletedTableViewCell respondsToSelector:selector]) {
        NSMutableDictionary *toDoCompletedCellViewModel = [self.toDoCompletedListViewModel objectAtIndex:indexPath.row];
        [toDoCompletedTableViewCell setToDoCompletedListModel:toDoCompletedCellViewModel];
    }
    cellView = toDoCompletedTableViewCell;
    cellView.backgroundColor = [UIColor clearColor];
    cellView.backgroundView = [[UIImageView alloc] init];
    cellView.selectedBackgroundView = [[UIImageView alloc] init];
    return cellView;
}


@end

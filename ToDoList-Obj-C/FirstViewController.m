//
//  FirstViewController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "FirstViewController.h"
#import "ToDoPendingListTableViewCell.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.toDoPendingListTable setDelegate:self];
    [self.toDoPendingListTable setDataSource:self];
    self.toDoPendingListViewModel = [NSMutableArray arrayWithArray:@[
                                                              @{
                                                                  @"title"      : @"Buy milk",
                                                                  @"modifiedDate" : @"12/02/2016",
                                                                  @"status"    : @0,
                                                                  @"image"    : @"image512x512.png",
                                                                  },
                                                              @{
                                                                  @"title"      : @"Learn Swift",
                                                                  @"modifiedDate" : @"12/02/2016",
                                                                  @"status"    : @0,
                                                                  @"image"    : @"image512x512.png",
                                                                  },
                                                              @{
                                                                  @"title"      : @"Play violin",
                                                                  @"modifiedDate" : @"12/02/2016",
                                                                  @"status"    : @0,
                                                                  @"image"    : @"image512x512.png",
                                                                  },
                                                              ]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoPendingListViewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cellView;
    ToDoPendingListTableViewCell *toDoPendingTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ToDoPendingListViewCell" forIndexPath:indexPath];
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

@end

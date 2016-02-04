//
//  FirstViewController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *toDoPendingListTable;
@property (nonatomic, strong) NSMutableArray *toDoPendingListViewModel;

@end


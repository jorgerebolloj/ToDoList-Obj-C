//
//  SecondViewController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *toDoCompletedListTable;
@property (nonatomic, strong) NSMutableArray *toDoCompletedListViewModel;
@property (nonatomic, strong) NSString *dateString;


@end


//
//  SecondViewController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailComposer;
}

@property (weak, nonatomic) IBOutlet UITableView *toDoCompletedListTable;
@property (nonatomic, strong) NSMutableArray *toDoCompletedListViewModel;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar2;
@property (strong, nonatomic) NSMutableArray *filteredModel2;


@end


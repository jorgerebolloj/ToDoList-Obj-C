//
//  FirstViewController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 03/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMailComposeViewControllerDelegate>
{
    MFMailComposeViewController *mailComposer;
}

@property (weak, nonatomic) IBOutlet UITableView *toDoPendingListTable;
@property (nonatomic, strong) NSMutableArray *toDoPendingListViewModel;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearchBar;
@property (strong, nonatomic) NSMutableArray *filteredModel;
- (IBAction)toDoNewItemBtn_Cmd:(id)sender;

+ (FirstViewController *)sharedInstance;

@end


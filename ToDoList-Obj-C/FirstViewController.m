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
    
    UIColor *greenBaseColor = [UIColor colorWithRed:161/255.0 green:212/255.0 blue:144/255.0 alpha:1];
    UIColor *greenMediumColor = [UIColor colorWithRed:151/255.0 green:199/255.0 blue:135/255.0 alpha:1];
    UIColor *greenDarkColor = [UIColor colorWithRed:138/255.0 green:181/255.0 blue:123/255.0 alpha:1];
    
    self.navigationController.navigationBar.tintColor = greenMediumColor;
    
    [self.mSearchBar setDelegate:self];
    UITextField *textField = [self.mSearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    [self.mSearchBar setBarTintColor:greenBaseColor];
    [self.mSearchBar setTintColor:greenDarkColor];
    
    [self.toDoPendingListTable setDelegate:self];
    [self.toDoPendingListTable setDataSource:self];
    self.toDoPendingListTable.backgroundColor = greenBaseColor;
    UIView *emptyCellsSeparatorStyle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    emptyCellsSeparatorStyle.backgroundColor = greenDarkColor;
    [self.toDoPendingListTable setTableFooterView:emptyCellsSeparatorStyle];
    
    self.toDoPendingListViewModel = [[NSMutableArray alloc]init];
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoPendingList"]) {
        self.toDoPendingListViewModel = [toDoBusiness requestPendingModel];
        self.toDoPendingListViewModel = [toDoBusiness setDate:self.toDoPendingListViewModel];
    }
    [toDoBusiness storePendingModel:self.toDoPendingListViewModel];
    
    self.filteredModel = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.filteredModel  removeAllObjects];
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    self.toDoPendingListViewModel = [toDoBusiness requestPendingModel];
    self.toDoPendingListViewModel = [toDoBusiness setDate:self.toDoPendingListViewModel];
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
    
    toDoPendingTableViewCell.statusItemButton.tag = indexPath.row;
    [toDoPendingTableViewCell.statusItemButton addTarget:self action:@selector(pendingButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    toDoPendingTableViewCell.fullImageBtn.tag = indexPath.row;
    [toDoPendingTableViewCell.fullImageBtn addTarget:self action:@selector(fullImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return toDoPendingTableViewCell;
}

- (void)pendingButtonClicked:(UIButton*)sender {
    NSMutableDictionary *toDoPendingCellViewModel = [[NSMutableDictionary alloc]init];
    int toDoId = 0;
    if ([self.filteredModel count] != 0) {
        toDoPendingCellViewModel = [[self.filteredModel objectAtIndex:sender.tag] mutableCopy];
        [self.filteredModel removeAllObjects];
    } else
        toDoPendingCellViewModel = [[self.toDoPendingListViewModel objectAtIndex:sender.tag] mutableCopy];
    
    toDoId = [[toDoPendingCellViewModel valueForKeyPath:@"id"]intValue];
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [toDoBusiness completeToDo:self.toDoPendingListViewModel[toDoId]];
    
    [self.toDoPendingListViewModel removeObjectAtIndex:toDoId];
    
    
    if (![[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoCompletedList"]) {
        NSMutableArray *toDoCompletedListViewModel = [[NSMutableArray alloc]init];
        [toDoBusiness storePendingModel:toDoCompletedListViewModel];
    }
    
    [toDoBusiness storePendingModel:self.toDoPendingListViewModel];
    self.toDoPendingListViewModel = [toDoBusiness requestPendingModel];
    self.toDoPendingListViewModel = [toDoBusiness setDate:self.toDoPendingListViewModel];
    [self.toDoPendingListTable reloadData];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"ToDo Completed"
                                  message:@""
                                  preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    [UIView animateWithDuration:7.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         alert.view.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:7.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              alert.view.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished){
                                              [alert dismissViewControllerAnimated:YES completion:nil];
                                          }];
                     }];
}

- (void)fullImageButtonClicked:(UIButton*)sender {
    NSMutableDictionary *toDoPendingCellViewModel = [[NSMutableDictionary alloc]init];
    int toDoId = 0;
    if ([self.filteredModel count] != 0) {
        toDoPendingCellViewModel = [[self.filteredModel objectAtIndex:sender.tag] mutableCopy];
        [self.filteredModel removeAllObjects];
    } else
        toDoPendingCellViewModel = [[self.toDoPendingListViewModel objectAtIndex:sender.tag] mutableCopy];
    
    toDoId = [[toDoPendingCellViewModel valueForKeyPath:@"id"]intValue];
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [toDoBusiness setExistingPendingItemToEditWithSelecteRow:toDoId andOriginList:@"PlaningList"];
    [self performSegueWithIdentifier:@"showPendingFullImage" sender:self];
}

#pragma mark UITable Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)toDoNewItemBtn_Cmd:(id)sender {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    toDoBusiness.originList = @"PlaningList";
    [self performSegueWithIdentifier:@"singleToDoViewSegue" sender:self];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.mSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.mSearchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0)
        [self.filteredModel removeAllObjects];
    else {
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
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:151/255.0 green:199/255.0 blue:135/255.0 alpha:1] title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons {
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:212/255.0 green:144/255.0 blue:161/255.0 alpha:1] icon:[UIImage imageNamed:@"email64x64.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:212/255.0 green:144/255.0 blue:161/255.0 alpha:1] icon:[UIImage imageNamed:@"sms64x64.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:212/255.0 green:144/255.0 blue:161/255.0 alpha:1] icon:[UIImage imageNamed:@"facebook64x64.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:212/255.0 green:144/255.0 blue:161/255.0 alpha:1] icon:[UIImage imageNamed:@"twitter64x64.png"]];
    return leftUtilityButtons;
}

// click event on left utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    __weak typeof(self) weakSelf = self;
    
    NSIndexPath *cellIndexPath = [self.toDoPendingListTable indexPathForCell:cell];
    NSMutableDictionary *toDoPendingCellViewModel = [[NSMutableDictionary alloc]init];
    if ([self.filteredModel count] != 0) {
        toDoPendingCellViewModel = [[self.filteredModel objectAtIndex:cellIndexPath.row] mutableCopy];
        [self.filteredModel removeAllObjects];
    } else
        toDoPendingCellViewModel = [[self.toDoPendingListViewModel objectAtIndex:cellIndexPath.row] mutableCopy];
    
    NSString *toDoTitle = [toDoPendingCellViewModel valueForKeyPath:@"title"];
    NSString *toDoDescription = [toDoPendingCellViewModel valueForKeyPath:@"description"];
    NSString *toDoModifiedDate = [toDoPendingCellViewModel valueForKeyPath:@"modifiedDate"];
    NSString *toDoStatus = [toDoPendingCellViewModel valueForKeyPath:@"status"];
    UIImage *image = [UIImage imageNamed:[toDoPendingCellViewModel valueForKeyPath:@"image"]];
    NSString *message = [NSString stringWithFormat:@"<h1>%@</h1> \n<h2>%@</h2> \nModified date: %@ \nToDo status: %@", toDoTitle, toDoDescription, toDoModifiedDate, [toDoStatus intValue] == 0 ? @"Pending": @"Completed"];
    
    switch (index) {
        case 0:
        {
            NSLog(@"email button was pressed");
            if (![MFMailComposeViewController canSendMail])
            {
                [self callAlertViewWithTitle:@"Error" andMessage:@"This device doesn't support email"];
                return;
            }
            NSData *pngData = UIImagePNGRepresentation(image);
            NSString *fileName = toDoTitle;
            fileName = [fileName stringByAppendingPathExtension:@"png"];
            [mailComposer addAttachmentData:pngData mimeType:@"image/png" fileName:fileName];
            NSArray *toRecipents = [NSArray arrayWithObject:@"jorgerebolloj@gmail.com"];
            mailComposer = [[MFMailComposeViewController alloc]init];
            mailComposer.mailComposeDelegate = self;
            [mailComposer setSubject:toDoTitle];
            [mailComposer setMessageBody:message isHTML:YES];
            [mailComposer setToRecipients:toRecipents];
            [self presentViewController:mailComposer animated:YES completion:NULL];
            break;
        }
        case 1:
        {
            NSLog(@"sms button was pressed");
            NSArray *recipents = @[@"+524491507933"];
            if(![MFMessageComposeViewController canSendText]) {
                [self callAlertViewWithTitle:@"Error" andMessage:@"This device doesn't support SMS"];
                return;
            }
            smsComposer.messageComposeDelegate = self;
            [smsComposer setRecipients:recipents];
            [smsComposer setBody:message];
            [self presentViewController:smsComposer animated:YES completion:nil];
            break;
        }
        case 2:
        {
            NSLog(@"facebook button was pressed");
            if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                [self callAlertViewWithTitle:@"Error" andMessage:@"This device doesn't support Facebook"];
                return;
            }
            facebookSLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [facebookSLComposerSheet setInitialText:[NSString stringWithFormat:message,facebookSLComposerSheet.serviceType]];
            [facebookSLComposerSheet addImage:image];
            [self presentViewController:facebookSLComposerSheet animated:YES completion:nil];
            
            [facebookSLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                NSString *output;
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        output = @"Action Cancelled";
                        break;
                    case SLComposeViewControllerResultDone:
                        output = @"Post Successfull";
                        break;
                    default:
                        break;
                }
                [weakSelf callAlertViewWithTitle:@"Facebook" andMessage:output];
            }];
        }
        case 3:
        {
            NSLog(@"twitter button was pressed");
            if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                [self callAlertViewWithTitle:@"Error" andMessage:@"This device doesn't support Twitter"];
                return;
            }
            twitterSLComposerSheet = [[SLComposeViewController alloc] init];
            twitterSLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [twitterSLComposerSheet setInitialText:[NSString stringWithFormat:message,twitterSLComposerSheet.serviceType]];
            [twitterSLComposerSheet addImage:image];
            [self presentViewController:twitterSLComposerSheet animated:YES completion:nil];
            
            [twitterSLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                NSString *output;
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        output = @"Action Cancelled";
                        break;
                    case SLComposeViewControllerResultDone:
                        output = @"Twitt Successfull";
                        break;
                    default:
                        break;
                }
                [weakSelf callAlertViewWithTitle:@"Twitter" andMessage:output];
            }];
        }
        default:
            break;
    }
}

#pragma mark - sms compose delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result error:(NSError *)error{
    switch (result) {
        case MessageComposeResultCancelled:
            [self callAlertViewWithTitle:@"SMS" andMessage:@"You cancelled sending this SMS"];
            break;
        case MessageComposeResultFailed:
            [self callAlertViewWithTitle:@"SMS" andMessage:@"SMS failed: An error occurred when trying to compose this SMS"];
            break;
        case MessageComposeResultSent:
            [self callAlertViewWithTitle:@"SMS" andMessage:@"You sent the SMS!"];
            break;
        default:
            [self callAlertViewWithTitle:@"SMS" andMessage:@"An error occurred when trying to compose this SMS"];
            break;
    }
    if (error)
        NSLog(@"Error : %@",error);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:
            [self callAlertViewWithTitle:@"Email" andMessage:@"You sent the email"];
            break;
        case MFMailComposeResultSaved:
            [self callAlertViewWithTitle:@"Email" andMessage:@"You saved a draft of this email"];
            break;
        case MFMailComposeResultCancelled:
            [self callAlertViewWithTitle:@"Email" andMessage:@"You cancelled sending this email"];
            break;
        case MFMailComposeResultFailed:
            [self callAlertViewWithTitle:@"Email" andMessage:@"Email failed: An error occurred when trying to compose this email"];
            break;
        default:
            [self callAlertViewWithTitle:@"Email" andMessage:@"An error occurred when trying to compose this email"];
            break;
    }
    if (error)
        NSLog(@"Error : %@",error);
    [self dismissViewControllerAnimated:YES completion:NULL];
    
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
            if ([self.filteredModel count] != 0) {
                toDoPendingCellViewModel = [[self.filteredModel objectAtIndex:cellIndexPath.row] mutableCopy];
                [self.filteredModel removeAllObjects];
            } else
                toDoPendingCellViewModel = [[self.toDoPendingListViewModel objectAtIndex:cellIndexPath.row] mutableCopy];
            
            toDoId = [[toDoPendingCellViewModel valueForKeyPath:@"id"]intValue];
            ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
            [toDoBusiness setExistingPendingItemToEditWithSelecteRow:toDoId andOriginList:@"PlaningList"];
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
            ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
            [toDoBusiness storePendingModel:self.toDoPendingListViewModel];
            self.toDoPendingListViewModel = [toDoBusiness requestPendingModel];
            self.toDoPendingListViewModel = [toDoBusiness setDate:self.toDoPendingListViewModel];
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

- (void)callAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
}


@end

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
#import "NewItemViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

+ (SecondViewController *)sharedInstance {
    static dispatch_once_t onceToken;
    static SecondViewController *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[SecondViewController alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _toDoCompletedListViewModel = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mSearchBar2 setDelegate:self];
    UITextField *textField = [self.mSearchBar2 valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    [self.toDoCompletedListTable setDelegate:self];
    [self.toDoCompletedListTable setDataSource:self];
    
    self.toDoCompletedListViewModel = [[NSMutableArray alloc]init];
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[NSUserDefaults standardUserDefaults] arrayForKey:@"toDoCompletedList"]) {
        self.toDoCompletedListViewModel = [toDoBusiness requestCompletedModel];
        self.toDoCompletedListViewModel = [toDoBusiness setDate:self.toDoCompletedListViewModel];
    }
    [toDoBusiness storeCompletedModel:self.toDoCompletedListViewModel];
    
    self.filteredModel2 = [[NSMutableArray alloc] init];
    //[self.filteredModel2 addObjectsFromArray:[self.toDoCompletedListViewModel mutableCopy]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    self.toDoCompletedListViewModel = [toDoBusiness requestCompletedModel];
    self.toDoCompletedListViewModel = [toDoBusiness setDate:self.toDoCompletedListViewModel];
    [self.toDoCompletedListTable reloadData];
}

- (void)keyboardShown:(NSNotification *)notification {
    CGRect keyboardFrame;
    [[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey]getValue:&keyboardFrame];
    CGRect tableViewFrame = self.toDoCompletedListTable.frame;
    tableViewFrame.size.height -= keyboardFrame.size.height;
    [self.toDoCompletedListTable setFrame:tableViewFrame];
}

- (void)keyboardHidden:(NSNotification *)notification {
    [self.toDoCompletedListTable setFrame:self.view.bounds];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.filteredModel2 count] != 0)
        return [self.filteredModel2 count];
    else
        return [self.toDoCompletedListViewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDoCompletedListTableViewCell *toDoCompletedTableViewCell = (ToDoCompletedListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ToDoCompletedListViewCell" forIndexPath:indexPath];
    
    toDoCompletedTableViewCell.leftUtilityButtons = [self leftButtons];
    toDoCompletedTableViewCell.rightUtilityButtons = [self rightButtons];
    toDoCompletedTableViewCell.delegate = self;
    
    SEL selector = @selector(setToDoCompletedListModel:);
    if([toDoCompletedTableViewCell respondsToSelector:selector]) {
        NSMutableDictionary *toDoCompletedCellViewModel = [[NSMutableDictionary alloc]init];
        if ([self.filteredModel2 count] != 0)
            toDoCompletedCellViewModel = [self.filteredModel2 objectAtIndex:indexPath.row];
        else
            toDoCompletedCellViewModel = [self.toDoCompletedListViewModel objectAtIndex:indexPath.row];
        [toDoCompletedTableViewCell setToDoCompletedListModel:toDoCompletedCellViewModel];
    }
    
    toDoCompletedTableViewCell.pendingToDoBtn.tag = indexPath.row;
    [toDoCompletedTableViewCell.pendingToDoBtn addTarget:self action:@selector(completedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableViewCell *cellView;
    cellView = toDoCompletedTableViewCell;
    cellView.backgroundColor = [UIColor clearColor];
    cellView.backgroundView = [[UIImageView alloc] init];
    cellView.selectedBackgroundView = [[UIImageView alloc] init];
    return cellView;
}

-(void)completedButtonClicked:(UIButton*)sender
{
    NSMutableDictionary *toDoCompletedCellViewModel = [[NSMutableDictionary alloc]init];
    int toDoId = 0;
    if ([self.filteredModel2 count] != 0) {
        toDoCompletedCellViewModel = [[self.filteredModel2 objectAtIndex:sender.tag] mutableCopy];
        [self.filteredModel2 removeAllObjects];
    } else
        toDoCompletedCellViewModel = [[self.toDoCompletedListViewModel objectAtIndex:sender.tag] mutableCopy];
    
    toDoId = [[toDoCompletedCellViewModel valueForKeyPath:@"id"]intValue];    
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [toDoBusiness storeNewItem:self.toDoCompletedListViewModel[toDoId]];
    
    [self.toDoCompletedListViewModel removeObjectAtIndex:toDoId];
    [toDoBusiness storeCompletedModel:self.toDoCompletedListViewModel];
    self.toDoCompletedListViewModel = [toDoBusiness requestCompletedModel];
    self.toDoCompletedListViewModel = [toDoBusiness setDate:self.toDoCompletedListViewModel];
    [self.toDoCompletedListTable reloadData];
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"ToDo Planned Again"
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

#pragma mark UITable Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.mSearchBar2 setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.mSearchBar2 setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        [self.filteredModel2 removeAllObjects];
        //[self.filteredModel2 addObjectsFromArray:[self.toDoCompletedListViewModel mutableCopy]];
    } else {
        [self.filteredModel2 removeAllObjects];
        for (NSString *itemToDo in self.toDoCompletedListViewModel) {
            NSString *stringToDoTitle = [[itemToDo valueForKeyPath:@"title"] description];
            NSRange range = [stringToDoTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound )
                [self.filteredModel2 addObject:itemToDo];
        }
    }
    [self.toDoCompletedListTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self.mSearchBar2 resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self.mSearchBar2 resignFirstResponder];
    [self.filteredModel2  removeAllObjects];
    [self.toDoCompletedListTable reloadData];
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
    NSIndexPath *cellIndexPath = [self.toDoCompletedListTable indexPathForCell:cell];
    NSMutableDictionary *toDoCompletedCellViewModel = [[NSMutableDictionary alloc]init];
    if ([self.filteredModel2 count] != 0) {
        toDoCompletedCellViewModel = [[self.filteredModel2 objectAtIndex:cellIndexPath.row] mutableCopy];
        [self.filteredModel2 removeAllObjects];
    } else
        toDoCompletedCellViewModel = [[self.toDoCompletedListViewModel objectAtIndex:cellIndexPath.row] mutableCopy];
    NSString *toDoTitle = [toDoCompletedCellViewModel valueForKeyPath:@"title"];
    NSString *toDoDescription = [toDoCompletedCellViewModel valueForKeyPath:@"description"];
    NSString *toDoModifiedDate = [toDoCompletedCellViewModel valueForKeyPath:@"modifiedDate"];
    NSString *toDoStatus = [toDoCompletedCellViewModel valueForKeyPath:@"status"];
    UIImage *image = [UIImage imageNamed:[toDoCompletedCellViewModel valueForKeyPath:@"image"]];
    NSString *message = [NSString stringWithFormat:@"<h1>%@</h1> \n<h2>%@</h2> \nModified date: %@ \nToDo status: %@", toDoTitle, toDoDescription, toDoModifiedDate, [toDoStatus intValue] == 0 ? @"Pending": @"Completed"];
    
    switch (index) {
        case 0:
        {
            NSLog(@"email button was pressed");
            if (![MFMailComposeViewController canSendMail])
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"This device doesn't support email"
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
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"This device doesn't support SMS"
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
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"This device doesn't support Facebook"
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
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Facebook"
                                              message:output
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
            }];
            break;
        }
        case 3:
        {
            NSLog(@"twitter button was pressed");
            if(![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"This device doesn't support Twitter"
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
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Twitter"
                                              message:output
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
            }];
        }
        default:
            break;
    }

}

#pragma mark - sms compose delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
        {
            NSLog(@"You cancelled sending this SMS");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"SMS"
                                          message:@"You cancelled sending this SMS"
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
            break;
        }
        case MessageComposeResultFailed:
        {
            NSLog(@"SMS failed: An error occurred when trying to compose this SMS");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"SMS"
                                          message:@"SMS failed: An error occurred when trying to compose this SMS"
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
            break;
        }
        case MessageComposeResultSent:
        {
            NSLog(@"You sent the SMS!");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"SMS"
                                          message:@"You sent the SMS!"
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
            break;
        }
        default:
        {
            NSLog(@"An error occurred when trying to compose this SMS");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"SMS"
                                          message:@"An error occurred when trying to compose this SMS"
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
            break;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - mail compose delegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultSent:
        {
            NSLog(@"You sent the email");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Email"
                                          message:@"You sent the email"
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
            break;
        }
        case MFMailComposeResultSaved:
        {
            NSLog(@"You saved a draft of this email");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Email"
                                          message:@"You saved a draft of this email"
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
            break;
        }
        case MFMailComposeResultCancelled:
        {
            NSLog(@"You cancelled sending this email");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Email"
                                          message:@"You cancelled sending this email"
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
            break;
        }
        case MFMailComposeResultFailed:
        {
            NSLog(@"Email failed: An error occurred when trying to compose this email");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Email"
                                          message:@"Email failed: An error occurred when trying to compose this email"
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
            break;
        }
        default:
        {
            NSLog(@"An error occurred when trying to compose this email");
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Email"
                                          message:@"An error occurred when trying to compose this email"
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
            break;
        }
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

// click event on right utility button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"Edit button was pressed");
            NSIndexPath *cellIndexPath = [self.toDoCompletedListTable indexPathForCell:cell];
            NSMutableDictionary *toDoCompletedCellViewModel = [[NSMutableDictionary alloc]init];
            int toDoId = 0;
            if ([self.filteredModel2 count] != 0) {
                toDoCompletedCellViewModel = [[self.filteredModel2 objectAtIndex:cellIndexPath.row] mutableCopy];
                [self.filteredModel2 removeAllObjects];
            } else
                toDoCompletedCellViewModel = [[self.toDoCompletedListViewModel objectAtIndex:cellIndexPath.row] mutableCopy];
            
            toDoId = [[toDoCompletedCellViewModel valueForKeyPath:@"id"]intValue];
            ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
            [toDoBusiness setExistingCompletedItemToEditWithSelecteRow:toDoId andOriginList:@"CompletedList"];
            [self performSegueWithIdentifier:@"singleCompletedToDoViewSegue" sender:self];
            break;
        }
        case 1:
        {
            NSLog(@"Delete button was pressed");
            NSIndexPath *cellIndexPath = [self.toDoCompletedListTable indexPathForCell:cell];
            NSMutableDictionary *toDoCompletedCellViewModel = [[NSMutableDictionary alloc]init];
            int toDoId = 0;
            if ([self.filteredModel2 count] != 0) {
                toDoCompletedCellViewModel = [[self.filteredModel2 objectAtIndex:cellIndexPath.row] mutableCopy];
                [self.filteredModel2 removeAllObjects];
            } else
                toDoCompletedCellViewModel = [[self.toDoCompletedListViewModel objectAtIndex:cellIndexPath.row] mutableCopy];
            
            toDoId = [[toDoCompletedCellViewModel valueForKeyPath:@"id"] intValue];
            [self.toDoCompletedListViewModel removeObjectAtIndex:toDoId];
            ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
            [toDoBusiness storeCompletedModel:self.toDoCompletedListViewModel];
            self.toDoCompletedListViewModel = [toDoBusiness requestCompletedModel];
            self.toDoCompletedListViewModel = [toDoBusiness setDate:self.toDoCompletedListViewModel];
            [self.toDoCompletedListTable reloadData];
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


@end

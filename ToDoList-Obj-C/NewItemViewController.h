//
//  NewItemViewController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewItemViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *toDoTitleTextField;
@property (weak, nonatomic) IBOutlet UIButton *toDoAddImageBtn;
@property (weak, nonatomic) IBOutlet UITextField *toDoDescriptionTextField;
@property (strong, nonatomic)   NSMutableDictionary *toDoNewItem;
@property (nonatomic, strong) NSString *dateString;
@property(nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) IBOutlet UIView *toDoNewItemView;
@property (strong, nonatomic)   NSMutableDictionary *toDoExistingItem;

- (IBAction)toDoAddImageBtn:(id)sender;
- (IBAction)toDoStoreNewItemBtn:(id)sender;

@end

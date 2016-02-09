//
//  ToDoInfoViewController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 08/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoInfoViewController : UIViewController

@property (strong, nonatomic)   NSMutableDictionary *toDoExistingPlaningItem;
@property (strong, nonatomic)   NSMutableDictionary *toDoExistingCompletedItem;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imagetView;

@end

//
//  FullImageViewController.h
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 08/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fullImageView;
@property (strong, nonatomic)   NSMutableDictionary *toDoExistingPlaningItem;
@property (strong, nonatomic)   NSMutableDictionary *toDoExistingCompletedItem;

@end

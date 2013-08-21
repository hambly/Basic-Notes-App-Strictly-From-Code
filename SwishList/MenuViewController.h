//
//  MenuViewController.h
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//
@class List;
@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

-(void) menuView:(MenuViewController*)menuViewController didSelectList:(List*)list atIndexPath:(NSIndexPath *)indexPath;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, strong) List *selectedList;
@property (nonatomic) BOOL isVisible;

@property (nonatomic, weak) id <MenuViewControllerDelegate> menuViewDelegate;

@end

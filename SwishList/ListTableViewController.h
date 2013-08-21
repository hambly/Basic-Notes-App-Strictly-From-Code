//
//  ListTableViewController.h
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

@class List;
@class ListTableViewController;
@class Note;

@protocol ListTableViewControllerDelegate <NSObject>
- (void) listTableViewController: (ListTableViewController *)controller didSelectNote: (Note *)note atIndexPath:(NSIndexPath *)indexPath;
@end

@interface ListTableViewController : UITableViewController

@property (nonatomic, strong) List *list;
@property (nonatomic, weak) id <ListTableViewControllerDelegate> listViewDelegate;
@property (readonly, nonatomic, retain) NSArray *allNotes;

-(void) refreshNotes;

@end

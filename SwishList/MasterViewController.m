//
//  MasterViewController.m
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "ListTableViewController.h"
#import "MenuViewController.h"
#import "NoteViewController.h"

#import "DataStore.h"
#import "Note.h"
#import "List.h"

typedef enum {
	kList,
	kMenu,
	kNote,
} ChildViews;

@interface MasterViewController () <ListTableViewControllerDelegate, MenuViewControllerDelegate>

@property (nonatomic, strong) ListTableViewController *listTableViewController;
@property (nonatomic, strong) MenuViewController *menuViewController;
@property (nonatomic, strong) NoteViewController *noteViewController;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIBarButtonItem *menuBarButtonItem;
@property (nonatomic, strong) UILabel *navigationBarTitleLabel;

@end

@implementation MasterViewController {
	// Constraints for Menu View
	NSLayoutConstraint *_hiddenMenuViewConstraint;
	NSArray *_visibleMenuViewConstraintsArray;
	
	// Constraints for Note View
	NSLayoutConstraint  *_hiddenNoteViewConstraint;
	NSArray *_visibleNoteViewConstraintsArray;
}

- (id) init {
	if (self = [super init]){
		if ([[[DataStore store] allLists] count] == 0) {
			List *list = [[DataStore store] createList];
			list.title = @"My Notes";
		}
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.listTableViewController = [[ListTableViewController alloc] initWithStyle:UITableViewStylePlain];
	self.menuViewController = [[MenuViewController alloc] init];
	self.noteViewController = [[NoteViewController alloc] init];
	
	[self prepareNavigationBar];
	
	[self addChildViewController:self.listTableViewController];
	[self addChildViewController:self.menuViewController];
	[self addChildViewController:self.noteViewController];
	
	self.listTableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
	self.menuViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
	self.noteViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
	
	self.listTableViewController.listViewDelegate = self;
	self.listTableViewController.list = self.menuViewController.selectedList;
	
	self.menuViewController.menuViewDelegate = self;
	
	[self prepareListTableView];
	
}

- (void) prepareNavigationBar {
	// This method should only be used as part of viewDidLoad, separated for cleanliness.
	
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
	self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
	// Top = 0 to super top
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar
														  attribute:NSLayoutAttributeTop
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeTop
														 multiplier:1.0f
														   constant:0.0f]];
	// Left = 0 to super left
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar
														  attribute:NSLayoutAttributeLeft
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeLeading
														 multiplier:1.0f
														   constant:0.0f]];
	// Right = 0 to super right
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0f
														   constant:0.0f]];
	// Height = 22
	[self.navigationBar addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar
																   attribute:NSLayoutAttributeHeight
																   relatedBy:NSLayoutRelationEqual
																	  toItem:nil
																   attribute:NSLayoutAttributeNotAnAttribute
																  multiplier:1.0f
																	constant:32.0f]];
	self.navigationBar.barStyle = UIBarStyleBlack;
	
	
	UIBarButtonItem *barButtonItemAddNewItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewNote:)];
	self.menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
	
	UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
	[navigationItem setRightBarButtonItems:@[barButtonItemAddNewItem]];
	[navigationItem setLeftBarButtonItems:@[self.menuBarButtonItem]];
	
	self.navigationBarTitleLabel = [[UILabel alloc] init];
	self.navigationBarTitleLabel.font = [UIFont fontWithName:@"AvenirNext-Light" size:12.0f];
	self.navigationBarTitleLabel.text = self.menuViewController.selectedList.title;
	self.navigationBarTitleLabel.textColor = [UIColor whiteColor];
	self.navigationBarTitleLabel.backgroundColor = [UIColor clearColor];
	[self.navigationBarTitleLabel sizeToFit];
	[navigationItem setTitleView:self.navigationBarTitleLabel];
	
	[self.navigationBar setItems:@[navigationItem]];
	
	[self.view addSubview:self.navigationBar];
	
}

-(void) prepareListTableView {
	UIView *listView = self.listTableViewController.view;
	listView.translatesAutoresizingMaskIntoConstraints = NO;
	
	// Listview Top = 0 to navbar.bottom
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:listView
													 attribute:NSLayoutAttributeTop
													 relatedBy:NSLayoutRelationEqual
														toItem:self.navigationBar
													 attribute:NSLayoutAttributeBottom
													multiplier:1.0f
													  constant:0.0f]];
	// Left = 0 to super left
	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:listView
																  attribute:NSLayoutAttributeLeft
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.view
																  attribute:NSLayoutAttributeLeading
																 multiplier:1.0f
																   constant:0.0f];
	constraint.priority = 950;
	[self.view addConstraint:constraint];
	// Right = 0 to super right
	constraint = [NSLayoutConstraint constraintWithItem:listView
														  attribute:NSLayoutAttributeRight
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeRight
														 multiplier:1.0f
														   constant:0.0f];
	constraint.priority = 950;
	[self.view addConstraint:constraint];
	// listView bottom = 0 to self.bottom
	[self.view addConstraint:[NSLayoutConstraint constraintWithItem:listView
													 attribute:NSLayoutAttributeBottom
														  relatedBy:NSLayoutRelationEqual
															 toItem:self.view
														  attribute:NSLayoutAttributeBottom
														 multiplier:1.0f
														   constant:0.0f]];	
	[self.view addSubview:self.listTableViewController.view];
	
}

-(void) addNewNote: (id) sender {
	Note *note = [[DataStore store] createNote];
	NSArray *allNotes = [[DataStore store] notesForList:self.menuViewController.selectedList];
	note.title = [NSString stringWithFormat:@"Note %i",allNotes.count];
	note.list = self.menuViewController.selectedList;
	[self.listTableViewController refreshNotes];
	if (self.noteViewController.isVisible){
		[self loadNoteWhileNoteViewIsVisible:note];
	}
	
	if (self.noteViewController.isVisible){
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.listTableViewController.allNotes.count -1 inSection:0];
		[self.listTableViewController.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	}
}

-(void) menuButtonPressed: (id) sender {
	if (!self.noteViewController.isVisible){
		[self showOrHideMenuView];
	} else {
		[self showOrHideNoteView];
		[UIView animateWithDuration:0.3f animations:^{
			self.menuBarButtonItem.title = @"Menu";
		}];
	}
	
}

-(void) showOrHideMenuView {
	if (self.noteViewController.isVisible){
		[self showOrHideNoteView];
	}
	
	//  shortcut pointers for brevity
	UIView *menuView = self.menuViewController.view;
	UIView *listView = self.listTableViewController.view;
	
	NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(menuView, listView);
	
	if (![self.view.subviews containsObject:menuView]){
		// Initial conditions
		[self.view addSubview:self.menuViewController.view];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:menuView
															  attribute:NSLayoutAttributeHeight
															  relatedBy:NSLayoutRelationEqual
																 toItem:listView
															  attribute:NSLayoutAttributeHeight
															 multiplier:1.0f
															   constant:0.0f]];
		[menuView addConstraint:[NSLayoutConstraint constraintWithItem:menuView
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:nil
															 attribute:NSLayoutAttributeNotAnAttribute
															multiplier:1.0f
															  constant:160.0f]];
		_hiddenMenuViewConstraint = [NSLayoutConstraint constraintWithItem:menuView
																 attribute:NSLayoutAttributeRight
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.view
																 attribute:NSLayoutAttributeLeft
																multiplier:1.0f
																  constant:0.0f];
		_hiddenMenuViewConstraint.priority = 950;
		[self.view addConstraint:_hiddenMenuViewConstraint];
		[self.view setNeedsUpdateConstraints];
		[self.view layoutIfNeeded];
	}
	
	if (self.menuViewController.isVisible){
		[self.view removeConstraints:_visibleMenuViewConstraintsArray];
		[self.view setNeedsUpdateConstraints];
		
		[UIView animateWithDuration:0.3f animations:^{
			[self.view layoutIfNeeded];
		} completion:^(BOOL finished) {
			[self.menuViewController.view removeFromSuperview];
		}];
		
		[UIView animateWithDuration:0.3f animations:^{
			self.menuBarButtonItem.title = @"Menu";
		}];
		self.menuViewController.isVisible = NO;
		
	} else {
		// Menu Visible Constraint
		_visibleMenuViewConstraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menuView]-0-[listView]-0-|"
																				   options:NSLayoutFormatAlignAllBottom
																				   metrics:nil
																					 views:viewsDictionary];
		[self.view addConstraints:_visibleMenuViewConstraintsArray];
		
		[UIView animateWithDuration:0.3f animations:^{
			self.menuBarButtonItem.title = @"Hide Menu";
		}];
		
		self.menuViewController.isVisible = YES;
		
		[self.view setNeedsUpdateConstraints];
		[UIView animateWithDuration:0.3f animations:^{
			[self.view layoutIfNeeded];
		}];
		
	}
}

-(void) showOrHideNoteView{
	if (self.menuViewController.isVisible){
		[self showOrHideMenuView];
	}
	
	// shortcut pointers for brevity
	UIView *noteView = self.noteViewController.view;
	UIView *listView = self.listTableViewController.view;
	
	NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(noteView, listView);
	
	if (![self.view.subviews containsObject:noteView]){
		//Initial conditions
		[self.view addSubview:self.noteViewController.view];
		[self.view addConstraint:[NSLayoutConstraint constraintWithItem:noteView
															  attribute:NSLayoutAttributeHeight
															  relatedBy:NSLayoutRelationEqual
																 toItem:listView
															  attribute:NSLayoutAttributeHeight
															 multiplier:1.0f
															   constant:0.0f]];
		[noteView addConstraint:[NSLayoutConstraint constraintWithItem:noteView
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:nil
															 attribute:NSLayoutAttributeNotAnAttribute
															multiplier:1.0f
															  constant:200.0f]];
		_hiddenNoteViewConstraint = [NSLayoutConstraint constraintWithItem:noteView
																 attribute:NSLayoutAttributeLeft
																 relatedBy:NSLayoutRelationEqual
																	toItem:self.view
																 attribute:NSLayoutAttributeRight
																multiplier:1.0f
																  constant:0.0f];
		_hiddenNoteViewConstraint.priority = 950;
		[self.view addConstraint:_hiddenNoteViewConstraint];
		[self.view setNeedsUpdateConstraints];
		[self.view layoutIfNeeded];
		
	}
	
	if (self.noteViewController.isVisible){
		[self.view removeConstraints:_visibleNoteViewConstraintsArray];
		[self.view setNeedsUpdateConstraints];
		
		[UIView animateWithDuration:0.3f animations:^{
			[self.view layoutIfNeeded];
			self.menuBarButtonItem.title = @"Menu";
		} completion:^(BOOL finished) {
			[self.noteViewController.view removeFromSuperview];
			[self.listTableViewController.tableView reloadData];
		}];
		
		self.navigationBarTitleLabel.text = self.menuViewController.selectedList.title;
		[self.navigationBarTitleLabel sizeToFit];
		self.noteViewController.isVisible = NO;
		[self.listTableViewController.tableView deselectRowAtIndexPath:self.listTableViewController.tableView.indexPathForSelectedRow animated:YES];
	} else {
		
		[UIView animateWithDuration:0.3f animations:^{
			self.menuBarButtonItem.title = [NSString stringWithFormat:@"%@",self.menuViewController.selectedList.title];
		}];
		
		// NoteView Visible Constraint
		_visibleNoteViewConstraintsArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[listView]-0-[noteView]-0-|"
																				   options:NSLayoutFormatAlignAllBottom
																				   metrics:nil
																					 views:viewsDictionary];
		[self.view addConstraints:_visibleNoteViewConstraintsArray];
		
		self.noteViewController.isVisible = YES;
		
		[self.view setNeedsUpdateConstraints];
		[UIView animateWithDuration:0.3f animations:^{
			[self.view layoutIfNeeded];
		}];
		
	}
	
}

-(void) loadNoteWhileNoteViewIsVisible:(Note *)note{
	
	if (note == self.noteViewController.note){
		[self showOrHideNoteView];
	} else {
		[self.noteViewController saveNote];
		[self.listTableViewController.tableView reloadData];
		[self.noteViewController setNote:note];
		self.navigationBarTitleLabel.text = note.title;
		[self.navigationBarTitleLabel sizeToFit];
		[self.noteViewController loadNote];
		
	}
	
}
	


#pragma mark - ListTableViewController Delegate Methods

-(void) listTableViewController:(ListTableViewController *)controller didSelectNote:(Note *)note atIndexPath:(NSIndexPath *)indexPath{
	
	if (self.noteViewController.isVisible){
		[self loadNoteWhileNoteViewIsVisible:note];
		[self.listTableViewController.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	} else {
		self.navigationBarTitleLabel.text = note.title;
		[self.navigationBarTitleLabel sizeToFit];
		self.noteViewController.note = note;
		[self showOrHideNoteView];
	}
	
}

#pragma mark - MenuViewController Delegate Methods

-(void) menuView:(MenuViewController *)menuViewController didSelectList:(List *)list atIndexPath:(NSIndexPath *)indexPath {
	self.listTableViewController.list = list;
	[self.listTableViewController refreshNotes];
	[self.listTableViewController.tableView reloadData];
}


@end

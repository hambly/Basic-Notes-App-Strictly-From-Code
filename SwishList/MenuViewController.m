//
//  MenuViewController.m
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MenuViewController.h"
#import "DataStore.h"
#import "List.h"
#import "ListTableViewCell.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MenuViewController

- (id)init {
	if (self = [super init]){
		_isVisible = NO;
		if ([[DataStore store] allLists].count != 0)
			_selectedList = [[DataStore store] allLists][0];
		_tableView = [[UITableView alloc] init];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.view.layer.borderWidth = 1.0f;
	self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
	
	UILabel *listsLabel = [[UILabel alloc] init];
	listsLabel.translatesAutoresizingMaskIntoConstraints = NO;
	listsLabel.text = @"Notebooks";
	listsLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
	listsLabel.textAlignment = NSTextAlignmentLeft;
	[listsLabel sizeToFit];
	
	UILabel *newListLabel = [[UILabel alloc] init];
	newListLabel.translatesAutoresizingMaskIntoConstraints = NO;
	newListLabel.text = @"New";
	newListLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
	newListLabel.textAlignment = NSTextAlignmentRight;
	newListLabel.userInteractionEnabled = YES;
	UITapGestureRecognizer *newListGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newList:)];
	[newListLabel addGestureRecognizer:newListGesture];
	[listsLabel sizeToFit];
	
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.view addSubview:self.tableView];
	[self.view addSubview:listsLabel];
	[self.view addSubview:newListLabel];
	
	NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(listsLabel, _tableView, newListLabel);
	
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
																	 options:NSLayoutFormatAlignAllBottom
																	 metrics:nil
																	   views:viewsDictionary]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(4)-[listsLabel]-(4)-[newListLabel(40)]-(4)-|"
																	  options:NSLayoutFormatAlignAllBaseline
																	  metrics:nil
																		views:viewsDictionary]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(4)-[listsLabel]-(4)-[_tableView]|"
																	  options:0
																	  metrics:nil
																		views:viewsDictionary]];
	
}

-(void) newList: (id)sender {
	List *list = [[DataStore store] createList];
	NSArray *allLists = [[DataStore store] allLists];
	list.title = [NSString stringWithFormat:@"List %i", allLists.count];
	[self.tableView reloadData];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:allLists.count inSection:0];
	[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
	
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[DataStore store] allLists] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 36;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!cell) {
		cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
    
    // Configure the cell...
	List *list = [[[DataStore store] allLists] objectAtIndex:indexPath.row];
	cell.textLabel.text = list.title;
	
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	self.selectedList = [[[DataStore store] allLists] objectAtIndex:indexPath.row];
	[self.menuViewDelegate menuView:self didSelectList:self.selectedList atIndexPath:indexPath];
}

@end

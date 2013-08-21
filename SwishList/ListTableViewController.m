//
//  ListTableViewController.m
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "ListTableViewController.h"
#import "DataStore.h"
#import "Note.h"
#import "List.h"
#import "ListTableViewCell.h"

@interface ListTableViewController ()

@property (nonatomic, retain) NSArray *allNotes;

@end

@implementation ListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.allNotes = [[DataStore store] notesForList:self.list];
	
}

-(void) refreshNotes {
	self.allNotes = [[DataStore store] notesForList:self.list];
	[self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.allNotes.count;
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
	cell.textLabel.text = [self.allNotes[indexPath.row] title];
	
    return cell;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

-(void) tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		Note *note = self.allNotes[indexPath.row];
		[[DataStore store] removeNote:note];
		self.allNotes = [[DataStore store] notesForList:self.list];
		[tableView deleteRowsAtIndexPaths:@[indexPath]
							  withRowAnimation:UITableViewRowAnimationAutomatic];
		
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.listViewDelegate listTableViewController:self didSelectNote:[self.allNotes objectAtIndex:indexPath.row] atIndexPath:indexPath];
	
}

@end

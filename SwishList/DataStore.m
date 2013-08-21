//
//  DataStore.m
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "DataStore.h"
#import "Note.h"
#import "List.h"

@interface DataStore ()

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation DataStore {
	NSMutableArray *_allNotes;
	NSMutableArray *_allLists;
}

+ (DataStore *) store{
	static DataStore *store = nil;
	if (!store)
		store = [[super allocWithZone:nil] init];
	return store;
}

+ (id) allocWithZone:(NSZone *)zone {
	return [self store];
}

- (id) init {
	if (self = [super init]) {
		_model = [NSManagedObjectModel mergedModelFromBundles:nil];
		NSPersistentStoreCoordinator *persistantStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
		NSError *error = nil;
		NSString *storePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		storePath = [storePath stringByAppendingPathComponent:@"swishliststore001.sqlite"];
		NSURL *storeURL = [NSURL fileURLWithPath:storePath];
		
		NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
		
		if (![persistantStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
													  configuration:nil
																URL:storeURL
															options:options
															  error:&error]) {
			[NSException raise:@"Open Failed"
						format:@"Reason: %@", [error localizedDescription]];
		}
		
		_context = [[NSManagedObjectContext alloc] init];
		[_context setPersistentStoreCoordinator:persistantStoreCoordinator];
		[_context setUndoManager:nil];
		
		// Not sure about if these should be here:
		[self loadAllNotes];
		[self loadAllLists];
	}
	return self;
}

- (void)saveContext {
	NSError *error = nil;
	if (![self.context save:&error])
		NSLog(@"Error saving: %@", error.localizedDescription);
}

- (Note *)createNote{
	Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
											   inManagedObjectContext:self.context];
	note.orderingValue = (_allNotes.count > 0) ? @([_allNotes.lastObject orderingValue].doubleValue + 1.0) : @(0.0);
	note.dateCreated = [NSDate date];
	note.dateLastEdited = [NSDate date];
	[_allNotes addObject:note];
	return note;
}

- (NSArray *) allNotes{
	return _allNotes;
}

- (void) loadAllNotes {
	if (!_allNotes) {
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [self.model entitiesByName][@"Note"];
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateLastEdited" ascending:NO]];
		
		NSError *error;
		NSArray *result = [self.context executeFetchRequest:request error:&error];
		if (!result)
			[NSException raise:@"Fetch Failed" format:@"Reason: %@",error.localizedDescription];
		
		_allNotes = [[NSMutableArray alloc] initWithArray:result];
	}
}

- (void) removeNote: (Note *)note{
	[self.context deleteObject:note];
	[_allNotes removeObjectIdenticalTo:note];
	NSLog(@"Note %@ deleted",note.title);
}

- (NSArray *) notesMatchingPredicate: (NSPredicate *) predicate {
	return [_allNotes filteredArrayUsingPredicate:predicate];
}

- (NSArray *) notesForList: (List *) list {
	// Convenience method to return notes in a list
	return [self notesMatchingPredicate:[NSPredicate predicateWithFormat:@"list = %@",list]];
}

- (List *)createList{
	List *list = [NSEntityDescription insertNewObjectForEntityForName:@"List"
											   inManagedObjectContext:self.context];
	list.orderingValue = (_allLists.count > 0) ? @([_allLists.lastObject orderingValue].doubleValue + 1.0) : @(0.0);
	[_allLists addObject:list];
	return list;
}
- (NSArray *)allLists{
	return _allLists;
}
- (void) loadAllLists {
	if (!_allLists) {
		NSFetchRequest *request = [[NSFetchRequest alloc] init];
		request.entity = [self.model entitiesByName][@"List"];
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES]];
		
		NSError *error;
		NSArray *result = [self.context executeFetchRequest:request error:&error];
		if (!result)
			[NSException raise:@"Fetch Failed" format:@"Reason: %@", error.localizedDescription];

		_allLists = [[NSMutableArray alloc] initWithArray:result];
	}
}
- (void) removeList: (List *)list{
	[self.context deleteObject:list];
	[_allLists removeObjectIdenticalTo:list];
	NSLog(@"List Deleted: %@", list.title);
}

-(void) moveListAtIndex: (int)fromIndex toIndex: (int)toIndex {
	if (fromIndex == toIndex)
		return;
	
	List *list = _allLists[fromIndex];
	[_allLists removeObjectAtIndex:fromIndex];
	[_allLists insertObject:list atIndex:toIndex];
	
	double lowerBound, upperBound;
	if (toIndex > 0)
		lowerBound = [_allLists[toIndex -1] orderingValue].doubleValue;
	else
		lowerBound = [_allLists[1] orderingValue].doubleValue - 2.0;

	if (toIndex < _allLists.count - 1)
		upperBound = [_allLists[toIndex +1] orderingValue].doubleValue;
	else
		upperBound = [_allLists[toIndex -1] orderingValue].doubleValue + 2.0;
	
	list.orderingValue = @((lowerBound + upperBound) / 2.0);
}


@end

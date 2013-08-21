//
//  DataStore.h
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	<CoreData/CoreData.h>

@class Note;
@class List;

@interface DataStore : NSObject

+ (DataStore *) store;

- (void)saveContext;

- (Note *)createNote;
- (NSArray *) allNotes;
- (void) removeNote: (Note *)note;
- (NSArray *) notesMatchingPredicate: (NSPredicate *) predicate;
- (NSArray *) notesForList: (List *) list;

- (List *)createList;
- (NSArray *)allLists;
- (void) removeList: (List *)list;



@end

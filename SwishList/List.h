//
//  List.h
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface List : NSManagedObject

@property (nonatomic, retain) NSNumber * orderingValue;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateLastViewed;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSSet *noteSet;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addNoteSetObject:(Note *)value;
- (void)removeNoteSetObject:(Note *)value;
- (void)addNoteSet:(NSSet *)values;
- (void)removeNoteSet:(NSSet *)values;

@end

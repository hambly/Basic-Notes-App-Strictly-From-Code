//
//  NoteViewController.h
//  SwishList
//
//  Created by Mark on 8/16/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

@class Note;

@interface NoteViewController : UIViewController
@property (nonatomic, strong) Note *note;
@property (nonatomic) BOOL isVisible;

-(void) loadNote;
-(void) saveNote;

@end

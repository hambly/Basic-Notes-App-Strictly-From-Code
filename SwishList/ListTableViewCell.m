//
//  ListTableViewCell.m
//  SwishList
//
//  Created by Mark on 8/21/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) layoutSubviews{
	[super layoutSubviews];
	self.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:14.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

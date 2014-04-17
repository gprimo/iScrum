//
//  SprintItem.m
//  ScrumRemote
//
//  Created by Glauco Primo on 05/02/14.
//
//

#import "SprintItem.h"

@implementation SprintItem

@synthesize item_title;
@synthesize tasks;
@synthesize view_titulo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  Task.m
//  ScrumRemote
//
//  Created by Glauco Primo on 05/02/14.
//
//

#import "Task.h"

@implementation Task
@synthesize task_title;
@synthesize task_description;
@synthesize task_id;
@synthesize task_start_date;
@synthesize task_status;
@synthesize ptcp_sigla;
@synthesize lb_tit;
@synthesize lb_ptcp;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.layer setCornerRadius:5.0f];
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setBorderWidth:1.0f];
        /*
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        */
        
        lb_tit = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 95)];
        [lb_tit setNumberOfLines:0];
        [self addSubview:lb_tit];
        
        lb_ptcp = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 100, 15)];
        [lb_ptcp setNumberOfLines:1];
        [self addSubview:lb_ptcp];
        
        
        // Initialization code
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

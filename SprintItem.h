//
//  SprintItem.h
//  ScrumRemote
//
//  Created by Glauco Primo on 05/02/14.
//
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface SprintItem : UITableViewCell

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic) int item_id;
@property (nonatomic, strong) NSString *item_title;

@property (nonatomic, strong) UIView *view_titulo;
@end

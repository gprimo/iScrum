//
//  Task.h
//  ScrumRemote
//
//  Created by Glauco Primo on 05/02/14.
//
//

#import <UIKit/UIKit.h>

@interface Task : UIView

@property (nonatomic) int task_id;
@property (nonatomic) int item_id;
@property (nonatomic, strong) NSString *task_title;
@property (nonatomic, strong) NSString *task_description;
@property (nonatomic, strong) NSString *task_status;
@property (nonatomic, strong) NSString *ptcp_sigla;
@property (nonatomic, strong) NSString *task_start_date;
@property (nonatomic, strong) UILabel *lb_tit;
@property (nonatomic, strong) UILabel *lb_ptcp;

@end

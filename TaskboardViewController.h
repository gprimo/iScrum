//
//  TaskboardViewController.h
//  ScrumRemote
//
//  Created by Glauco Primo on 30/01/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"
#import "DataBase.h"
#import "addTaskButton.h"

@interface TaskboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>
{
    DataBase *db;
    CGFloat firstX;
    CGFloat firstY;
    UIView *selected_view;
    UIAlertView *change_state_alert;
    int selected_task_id;
    int selected_fase_id;
}

@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, strong) NSString *proj_id;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

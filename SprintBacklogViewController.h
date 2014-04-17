//
//  SprintBacklogViewController.h
//  ScrumRemote
//
//  Created by Glauco Primo on 30/01/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"
#import "DataBase.h"

@interface SprintBacklogViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>
{
    DataBase *db;
}
@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *proj_id;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

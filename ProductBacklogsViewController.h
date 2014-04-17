//
//  ProjetoViewController.h
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"
#import "DataBase.h"
#import "EditItemBacklog.h"

@interface ProductBacklogsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>
{
    DataBase *db;
    BOOL is_po;
}
@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *proj_id;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

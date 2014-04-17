//
//  AddItemSprint.h
//  ScrumRemote
//
//  Created by Glauco Primo on 02/04/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"
#import "DataBase.h"

@interface AddItemSprint : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>
{
    DataBase *db;
}
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *selected_item;

@end

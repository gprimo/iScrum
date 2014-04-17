//
//  MenuViewController.h
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "WebServiceRequest.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,NSURLConnectionDelegate>{
    NSMutableData *_responseData;
    long long _totalFileSize;
    int _receivedDataBytes;
    int _progressReceivedBytes;
    DataBase *db;
    
}
//-(void) showSettings:(id)sender;

@property (nonatomic, retain) UIProgressView *progress_bar;
@property (nonatomic, retain) NSNumber *filesize;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *lb_nome;
@property (nonatomic, strong) IBOutlet UILabel *lb_proj;
@property (nonatomic, strong) IBOutlet UILabel *lb_sprint;
@property (nonatomic, strong) IBOutlet UITextView *txt_papeis;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *user_nome;
@property (nonatomic, strong) NSString *proj_padrao;



@end

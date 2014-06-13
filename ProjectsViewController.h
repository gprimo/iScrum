//
//  ProjetoViewController.h
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "WebServiceRequest.h"

@interface ProjectsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
    DataBase *db;
}
@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *proj_selected;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *summary_view;
@property (nonatomic, strong) IBOutlet UILabel *lb_nome;
@property (nonatomic, strong) IBOutlet UILabel *lb_data_inicio;
@property (nonatomic, strong) IBOutlet UILabel *lb_data_fim;
@property (nonatomic, strong) IBOutlet UILabel *lb_data_game;
@property (nonatomic, strong) IBOutlet UILabel *lb_total_sprints;
@property (nonatomic, strong) IBOutlet UILabel *lb_total_historias;
@property (nonatomic, strong) IBOutlet UILabel *lb_historias_concluidas;
@property (nonatomic, strong) IBOutlet UILabel *lb_num_releases;
@property (nonatomic, strong) IBOutlet UITextView *txt_descricao;
@property (nonatomic, strong) IBOutlet UIButton *bt_tornar_princ;

-(IBAction)set_default_project:(id)sender;

@end

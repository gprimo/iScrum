//
//  ViewController.h
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBase.h"
#import "WebServiceRequest.h"

@interface ViewController : UIViewController <NSURLConnectionDelegate>{
    
    DataBase *db;
    
}

-(IBAction)login_button_click:(id)sender;
@property (nonatomic, strong) NSArray *user_info;

@property IBOutlet UITextField *txt_login;
@property IBOutlet UITextField *txt_senha;
@property IBOutlet UIView *login_view;
@property IBOutlet UIButton *login_button;


@end

//
//  ViewController.m
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "MenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize txt_login;
@synthesize txt_senha;
@synthesize user_info;
@synthesize login_view;
@synthesize login_button;

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    
/*
    NSString *query = [[NSString alloc] initWithFormat:@"SELECT id FROM usuario"];
    sqlite3_stmt *rs = [db openRS:query];
    if (sqlite3_step(rs) == SQLITE_ROW) {
        [self performSegueWithIdentifier:@"Slogin" sender:self];
    }
    */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    db = [[DataBase alloc] init];
    
    NSMutableString* bundlePath = [NSMutableString stringWithCapacity:4];
    [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
    [bundlePath appendString:@"/scrumhalf.sql"];
    [db openDB:bundlePath];
    
    
    [self.login_view.layer setCornerRadius:5.0f];
    [self.login_view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.login_view.layer setBorderWidth:1.0f];
    
    [self.login_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.login_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.login_button setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    self.login_button.backgroundColor = [UIColor colorWithRed:159/255.0f green:202/255.0f blue:55/255.0f alpha:1.0f];
    
    self.login_button.layer.borderColor = [UIColor colorWithRed:115/255.0f green:153/255.0f blue:24/255.0f alpha:1.0f].CGColor;
    self.login_button.layer.borderWidth = 0.5f;
    self.login_button.layer.cornerRadius = 5.0f;
    
    self.txt_senha.layer.borderColor = [UIColor colorWithRed:115/255.0f green:153/255.0f blue:24/255.0f alpha:1.0f].CGColor;
    self.txt_senha.layer.borderWidth = 0.5f;
    self.txt_senha.layer.cornerRadius = 5.0f;
    
    self.txt_login.layer.borderColor = [UIColor colorWithRed:115/255.0f green:153/255.0f blue:24/255.0f alpha:1.0f].CGColor;
    self.txt_login.layer.borderWidth = 0.5f;
    self.txt_login.layer.cornerRadius = 5.0f;
    
    [self.txt_login setFont:[UIFont systemFontOfSize:20]];
    [self.txt_senha setFont:[UIFont systemFontOfSize:20]];
    
    
    
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [db closeDB];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) login_button_click:(id)sender{
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSString *login = [txt_login text];
    NSString *senha = [txt_senha text];
    
    if ([WebServiceRequest isOnline]) {
        
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *data_response = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/login.php?login=%@&senha=%@",url_basic,login,senha]];
        //NSLog(@"%@",data_response);
        if ([data_response  isEqual: @"FALSE"] || [data_response isEqual:@""]) {
            UIAlertView *empty_alert = [[UIAlertView alloc] initWithTitle:@"Erro ao fazer login" message:@"Login ou Senha inválidos" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [empty_alert show];
            return FALSE;
        }
        NSString *user_id = [web_service getTagValue:@"id" inText:data_response inInitialRange:0];
        NSString *user_nome = [web_service getTagValue:@"nome" inText:data_response inInitialRange:0];
        NSString *sigla = [web_service getTagValue:@"identificacao" inText:data_response inInitialRange:0];
        
        user_info = [NSArray arrayWithObjects:user_id,user_nome, sigla, nil];
        txt_login.text = @"";
        txt_senha.text = @"";

        NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO usuario(id,nome,login,senha) VALUES (%@,'%@','%@','%@')",user_id,user_nome,login,senha];
        sqlite3_stmt *rs = [db openRS:query];
        sqlite3_step(rs);
        sqlite3_finalize(rs);
    }
    else {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT id, nome FROM usuario WHERE login = '%@' AND senha = '%@'",login,senha];
        sqlite3_stmt *rs = [db openRS:query];
        if (sqlite3_step(rs) == SQLITE_ROW) {
            NSString *user_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
            NSString *user_nome = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
            user_info = [NSArray arrayWithObjects:user_id,user_nome, nil];
            txt_login.text = @"";
            txt_senha.text = @"";
            
            return TRUE;
        }
        else {
            NSString *query = [[NSString alloc] initWithFormat:@"SELECT id FROM usuario WHERE login = '%@'",login];
            sqlite3_stmt *rs = [db openRS:query];
            if (sqlite3_step(rs) == SQLITE_ROW) {
                UIAlertView *empty_alert = [[UIAlertView alloc] initWithTitle:@"Erro ao fazer login OFFLINE" message:@"Senha incorreta." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [empty_alert show];
            }
            else {
                UIAlertView *empty_alert = [[UIAlertView alloc] initWithTitle:@"Erro ao fazer login OFFLINE" message:@"Você não possui um perfil Offline nesta conta." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [empty_alert show];
            }
            
            return FALSE;
        }
        sqlite3_finalize(rs);
    }
    
    return TRUE;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Slogin"]) {
        UINavigationController *destViewController = segue.destinationViewController;
        MenuViewController *menu_view_controller = (MenuViewController *) destViewController.topViewController;
        menu_view_controller.user_id = [user_info objectAtIndex:0];
        menu_view_controller.user_nome = [user_info objectAtIndex:1];
        logged_user_id = [user_info objectAtIndex:0];
        logged_user_sigla = [user_info objectAtIndex:2];
    }
}
@end

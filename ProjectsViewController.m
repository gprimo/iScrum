//
//  ProjetoViewController.m
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ProjectsViewController.h"

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController{
    NSMutableArray *projects; 
    NSMutableArray *projects_ids;
}

@synthesize menuName;
@synthesize user_id;
@synthesize proj_selected;
@synthesize bt_tornar_princ;
@synthesize tableView;
@synthesize summary_view;
@synthesize lb_nome;
@synthesize lb_data_fim;
@synthesize lb_data_game;
@synthesize lb_data_inicio;
@synthesize txt_descricao;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrum_bg.png"]];
    
    [bt_tornar_princ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [bt_tornar_princ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[bt_tornar_princ setImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
    bt_tornar_princ.backgroundColor = [UIColor colorWithRed:159/255.0f green:202/255.0f blue:55/255.0f alpha:1.0f];
    
    bt_tornar_princ.layer.borderColor = [UIColor colorWithRed:115/255.0f green:153/255.0f blue:24/255.0f alpha:1.0f].CGColor;
    bt_tornar_princ.layer.borderWidth = 0.5f;
    bt_tornar_princ.layer.cornerRadius = 5.0f;
    
    db = [[DataBase alloc] init];
    
    NSMutableString* bundlePath = [NSMutableString stringWithCapacity:4];
    [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
    [bundlePath appendString:@"/scrumhalf.sql"];
    [db openDB:bundlePath];
    
    
    summary_view.hidden = true;
	// Do any additional setup after loading the view.
    
   
    self.navigationItem.title = menuName;
    projects = [[NSMutableArray alloc] init];
    projects_ids = [[NSMutableArray alloc] init];
    
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-projects.php?user=%@",url_basic,user_id]];
        NSRange pos1;
        NSRange pos2;
        
        int i = 0;
        while (TRUE) {
            NSString *projeto_info = [web_service getTagValue:@"projeto" inText:xmlData inInitialRange:i];
            pos1 = [web_service last_initial_range];
            pos2 = [web_service last_final_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            
            NSString *projeto_id = [web_service getTagValue:@"proj_id" inText:projeto_info inInitialRange:0];
            [projects_ids addObject:projeto_id];
            
            NSString *projeto_nome = [web_service getTagValue:@"proj_nome" inText:projeto_info inInitialRange:0];
            [projects addObject:projeto_nome];
            
            i = pos2.location + pos2.length;
        }
    }
    else {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT p.proj_id, p.proj_nome FROM projeto p, participacao pa WHERE p.proj_id = pa.proj_id AND pa.usr_id = %@",user_id];
        sqlite3_stmt *rs = [db openRS:query];
        while (sqlite3_step(rs) == SQLITE_ROW) {
            NSString *projeto_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
            [projects_ids addObject:projeto_id];
            
            NSString *projeto_nome = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
            [projects addObject:projeto_nome];
        }
        sqlite3_finalize(rs);
    }
    
    UIBarButtonItem *sync = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(sync:)];
    
    
    
    //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: sync, nil];
    
}

-(void) sync:(id)sender {
    NSLog(@"asdsa");
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *projetoIdentifier = @"projectDetailsCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:projetoIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:projetoIdentifier];
    }
    
    cell.textLabel.text = [projects objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	int idx=indexPath.row;
    summary_view.hidden = false;
    proj_selected = [projects_ids objectAtIndex:idx];
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-project-summary.php?proj_id=%@",url_basic,[projects_ids objectAtIndex:idx]]];
        
        lb_nome.text = [web_service getTagValue:@"proj_nome" inText:xmlData inInitialRange:0];
        txt_descricao.text = [web_service getTagValue:@"proj_descricao" inText:xmlData inInitialRange:0];
        lb_data_inicio.text = [web_service getTagValue:@"proj_data_inicio" inText:xmlData inInitialRange:0];
        lb_data_game.text = [web_service getTagValue:@"proj_data_inicio_game" inText:xmlData inInitialRange:0];
        lb_data_fim.text = [web_service getTagValue:@"proj_data_fim" inText:xmlData inInitialRange:0];
    }
    else {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT p.proj_nome, p.proj_descricao, p.proj_data_inicio, p.proj_data_inicio_game, p.proj_data_fim FROM projeto p WHERE p.proj_id = %@",[projects_ids objectAtIndex:idx]];
        sqlite3_stmt *rs = [db openRS:query];
        while (sqlite3_step(rs) == SQLITE_ROW) {
            lb_nome.text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
            txt_descricao.text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
            lb_data_inicio.text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 2)];
            lb_data_game.text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 3)];
            lb_data_fim.text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 4)];
            
        }
        sqlite3_finalize(rs);
    }
    
    
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

-(void) set_default_project:(id)sender{
    WebServiceRequest *web_service = [WebServiceRequest alloc];
    [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/set-default-project.php?user_id=%@&proj_id=%@",url_basic,user_id,proj_selected]];
    NSLog(@"%@",user_id);
    NSLog(@"%@",proj_selected);
    
    if ([web_service last_error] == nil) {
        NSString *query = [[NSString alloc] initWithFormat:@"update usuario SET proj_id_ultimo_acesso=%@ WHERE id=%@",proj_selected, self.user_id];
        [db execute:query];
        
        UIAlertView *empty_alert = [[UIAlertView alloc] initWithTitle:@"Projeto Padrão alterado" message:@"O seu projeto padrão foi alterado com sucesso." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [empty_alert show];
    }
    
    
}

@end

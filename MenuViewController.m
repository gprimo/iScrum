//
//  MenuViewController.m
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "ProjectsViewController.h"
#import "ProductBacklogsViewController.h"
#import "SprintBacklogViewController.h"
#import "TaskboardViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController {
    NSArray *menu;
}

@synthesize tableView;
@synthesize lb_nome;
@synthesize lb_proj;
@synthesize lb_sprint;
@synthesize txt_papeis;

@synthesize user_id;
@synthesize user_nome;
@synthesize proj_padrao;

@synthesize progress_bar;
@synthesize filesize;

#pragma mark NSURLConnection Delegate Methods

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"errooooo");
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //self.filesize = ;
    _responseData = [[NSMutableData alloc] init];
    
    //NSString *url = [[[connection currentRequest] URL] absoluteString];
    //NSLog(@"%@",url);
//    if ([url rangeOfString:@"get-taskboard"].location != NSNotFound) {
        //NSLog(@"recebeuu");
        //NSDictionary *respondeHeaders = ((NSHTTPURLResponse *) response).allHeaderFields;
        //_totalFileSize += [respondeHeaders[@"Content-Length"] longLongValue];
        //NSLog(@"%@",respondeHeaders);
        //_receivedDataBytes = 0;
    //long long length = [response expectedContentLength];
    //NSLog(@"tamanho: %lld",length);
    
        
        //self.progress_bar.progress = 0;
 //   }
    

}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_responseData appendData:data];
    
    //NSString *url = [[[connection currentRequest] URL] absoluteString];
    //NSLog(@"%@",url);
 //   if ([url rangeOfString:@"get-taskboard"].location != NSNotFound) {

        
        //NSNumber *resource_length = [NSNumber numberWithUnsignedInteger:[data length]];
        _receivedDataBytes += [data length];
        //self.progress_bar.progress = (float)_receivedDataBytes / (float)_totalFileSize;
        //NSLog(@"%f de %f", (float)_receivedDataBytes, (float)_totalFileSize);
        //NSLog(@"%f",self.progress_bar.progress);
  //  }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    
    NSString *url = [[[connection currentRequest] URL] absoluteString];
    //NSLog(@"%@",url);
    NSString *returnedData = [[NSString alloc] initWithData: _responseData encoding:NSUTF8StringEncoding];
    if ([url rangeOfString:@"get-projects-summary"].location != NSNotFound) {
        //NSLog(@"%@",returnedData);
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        
        
        
        
        NSRange pos1;
        NSRange pos2;
        
        
        int i = 0;
        while (TRUE) {
            NSString *projeto_info = [web_service getTagValue:@"info" inText:returnedData inInitialRange:i];
            pos1 = [web_service last_initial_range];
            pos2 = [web_service last_final_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            
            NSString *proj_id = [web_service getTagValue:@"proj_id" inText:projeto_info inInitialRange:0];
            NSString *proj_nome = [web_service getTagValue:@"proj_nome" inText:projeto_info inInitialRange:0];
            NSString *proj_desc = [web_service getTagValue:@"proj_descricao" inText:projeto_info inInitialRange:0];
            NSString *proj_data_inicio = [web_service getTagValue:@"proj_data_inicio" inText:projeto_info inInitialRange:0];
            NSString *proj_data_inicio_game = [web_service getTagValue:@"proj_data_inicio_game" inText:projeto_info inInitialRange:0];
            NSString *proj_data_fim = [web_service getTagValue:@"proj_data_fim" inText:projeto_info inInitialRange:0];
            
            //Checando se o usuário já está participando do projeto no banco de dados offline
            NSString *query = [NSString stringWithFormat:@"SELECT id FROM participacao WHERE proj_id = %@ AND usr_id = %@",proj_id,user_id];
            sqlite3_stmt *rs = [db openRS:query];
            //Se não estiver
            if (sqlite3_step(rs) != SQLITE_ROW) {
                //NSLog(@"%@",proj_id);
                //Tentar inserir projeto no banco de dados offline, se não existir
                query = [[NSString alloc] initWithFormat:@"INSERT INTO projeto (proj_id,proj_nome,proj_descricao,proj_data_inicio,proj_data_inicio_game,proj_data_fim) VALUES(%@,'%@','%@', '%@', '%@', '%@')",proj_id, proj_nome, proj_desc, proj_data_inicio, proj_data_inicio_game, proj_data_fim];
                NSLog(@"%@",query);
                rs = [db openRS:query];
                sqlite3_step(rs);
                sqlite3_finalize(rs);
                
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/scrum_services/get-participacao.php?proj_id=%@&user=%@",url_basic,proj_id, user_id]]];
                [NSURLConnection connectionWithRequest:request delegate:self];
                
                
                
                
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/scrum_services/get-product-backlog.php?user=%@&&project=%@&&option=propostas",url_basic,user_id, proj_id]]];
                [NSURLConnection connectionWithRequest:request delegate:self];
                
                
                query = [NSString stringWithFormat: @"DELETE FROM item_backlog WHERE proj_id=%@",proj_id];
                rs = [db openRS:query];
                sqlite3_step(rs);
                sqlite3_finalize(rs);
                
                
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/scrum_services/get-product-backlog.php?user=%@&&project=%@&&option=aceitas",url_basic,user_id, proj_id]]];
                [NSURLConnection connectionWithRequest:request delegate:self];
                
                
                query = [NSString stringWithFormat: @"DELETE FROM item_sprint_backlog WHERE proj_id=%@",proj_id];
                rs = [db openRS:query];
                sqlite3_step(rs);
                sqlite3_finalize(rs);
                
                
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/scrum_services/get-sprint-backlog.php?user=%@&&project=%@",url_basic,user_id,proj_id]]];
                [NSURLConnection connectionWithRequest:request delegate:self];
                
                
                request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/scrum_services/get-taskboard.php?project=%%20%@%%20",url_basic,proj_id]]];
                [NSURLConnection connectionWithRequest:request delegate:self];
                
            }
            i = pos2.location + pos2.length;
        }
    }
    else if ([url rangeOfString:@"get-taskboard"].location != NSNotFound) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        int i = 0;
        NSRange pos1;
        NSRange pos2;
        
        while (TRUE) {
            NSString *tarefa_info = [web_service getTagValue:@"tarefa" inText:returnedData inInitialRange:i];
            pos1 = web_service.last_initial_range;
            if (pos1.location == NSNotFound) {
                break;
            }
            pos2 = web_service.last_final_range;
            
            NSString *trfa_id = [web_service getTagValue:@"trfa_id" inText:tarefa_info inInitialRange:0];
            NSString *itspt_id = [web_service getTagValue:@"itbklg_id" inText:tarefa_info inInitialRange:0];
            NSString *trfa_titulo = [web_service getTagValue:@"trfa_titulo" inText:tarefa_info inInitialRange:0];
            
            NSString *trfa_descricao = [[web_service getTagValue:@"trfa_descricao" inText:tarefa_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"trfa_descricao" inText:tarefa_info inInitialRange:0]];
            
            NSString *trfa_impedimento = [web_service getTagValue:@"trfa_impedimento" inText:tarefa_info inInitialRange:0];
            
            NSString *trfa_data_exclusao = [[web_service getTagValue:@"trfa_data_exclusao" inText:tarefa_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"trfa_data_exclusao" inText:tarefa_info inInitialRange:0]];
            
            NSString *trfa_data_inicio = [[web_service getTagValue:@"trfa_data_inicio" inText:tarefa_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"trfa_data_inicio" inText:tarefa_info inInitialRange:0]];
            
            
            
            NSString *inic_id = [web_service getTagValue:@"inic_id" inText:tarefa_info inInitialRange:0];
            NSString *fase_id = [web_service getTagValue:@"fase_id" inText:tarefa_info inInitialRange:0];
            NSString *inic_data = [web_service getTagValue:@"inic_data" inText:tarefa_info inInitialRange:0];
            
            
            
            NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO tarefa VALUES(%@,%@,'%@', %@, %@, %@, NULL, %@, NULL)", trfa_id, itspt_id, trfa_titulo, trfa_descricao, trfa_impedimento, trfa_data_exclusao, trfa_data_inicio];
            //NSLog(@"%@",query);
            sqlite3_stmt *rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            
            query = [[NSString alloc] initWithFormat:@"UPDATE tarefa SET itspt_id = %@, trfa_titulo = '%@', trfa_descricao = %@, trfa_impedimento = %@, trfa_data_exclusao = %@, trfa_data_inicio = %@ WHERE trfa_id=%@", itspt_id, trfa_titulo, trfa_descricao, trfa_impedimento, trfa_data_exclusao, trfa_data_inicio,trfa_id];
            rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            
            query = [[NSString alloc] initWithFormat:@"INSERT INTO inicio_fase VALUES(%@,%@,%@,'%@')",inic_id, trfa_id, fase_id, inic_data];
            rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            query = [[NSString alloc] initWithFormat:@"UPDATE inicio_fase set trfa_id=%@, fase_id=%@, inic_data='%@' WHERE inic_id = %@", trfa_id, fase_id, inic_data, inic_id];
            rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            
            
            i = pos2.location + pos2.length;
        }
    }
    else if ([url rangeOfString:@"get-participacao"].location != NSNotFound) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        
        NSString *ptcp_id = [web_service getTagValue:@"ptcp_id" inText:returnedData inInitialRange:0];
        NSString *ptcp_status = [web_service getTagValue:@"ptcp_status" inText:returnedData inInitialRange:0];
        NSString *ptcp_sigla = [web_service getTagValue:@"ptcp_sigla" inText:returnedData inInitialRange:0];
        NSString *proj_id = [web_service getTagValue:@"proj_id" inText:returnedData inInitialRange:0];
        //inserir participação do usuário no projeto
        
        NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO participacao (ptcp_id, usr_id,proj_id, ptcp_status, ptcp_sigla) VALUES(%@,%@, %@, '%@', '%@')",ptcp_id, user_id, proj_id, ptcp_status, ptcp_sigla];
        //NSLog(@"%@",query);
        sqlite3_stmt *rs = [db openRS:query];
        sqlite3_step(rs);
        sqlite3_finalize(rs);
    }
    else if ([url rangeOfString:@"get-product-backlog"].location != NSNotFound && [url rangeOfString:@"propostas"].location != NSNotFound) {
        NSRange pos1;
        NSRange pos2;
        int i = 0;
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        
        while (TRUE) {
            NSString *item_backlog_info = [web_service getTagValue:@"historia" inText:returnedData inInitialRange:i];
            pos1 = web_service.last_initial_range;
            if (pos1.location == NSNotFound) {
                break;
            }
            pos2 = web_service.last_final_range;
            
            NSString *itbklg_id = [web_service getTagValue:@"itbklg_id" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_sequencial = [web_service getTagValue:@"itbklg_sequencial" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_id_real = [web_service getTagValue:@"itbklg_id_real" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_titulo = [web_service getTagValue:@"itbklg_titulo" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_descricao = [web_service getTagValue:@"itbklg_descricao" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_pontos_estimativa = [web_service getTagValue:@"itbklg_pontos_estimativa" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_data_aceitacao = [[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]];;
            NSString *itbklg_data_exclusao = [[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]];;
            
            NSString *ptcp_id = [web_service getTagValue:@"ptcp_id" inText:item_backlog_info inInitialRange:0];
            NSString *proj_id = [web_service getTagValue:@"proj_id" inText:item_backlog_info inInitialRange:0];
            
            NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO item_backlog VALUES(%@,%@,%@, '%@', '%@', '%@', '%@', %@, %@, '%@')",itbklg_id, proj_id, ptcp_id, itbklg_titulo, itbklg_descricao, itbklg_id_real, itbklg_pontos_estimativa, itbklg_data_aceitacao, itbklg_data_exclusao, itbklg_sequencial];
            sqlite3_stmt *rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            i = pos2.location + pos2.length;
        }
    }
    else if ([url rangeOfString:@"get-product-backlog"].location != NSNotFound && [url rangeOfString:@"aceitas"].location != NSNotFound) {
        NSRange pos1;
        NSRange pos2;
        int i = 0;
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        
        while (TRUE) {
            NSString *item_backlog_info = [web_service getTagValue:@"historia" inText:returnedData inInitialRange:i];
            pos1 = [web_service last_initial_range];
            pos2 = [web_service last_final_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            NSString *itbklg_id = [web_service getTagValue:@"itbklg_id" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_sequencial = [web_service getTagValue:@"itbklg_sequencial" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_id_real = [web_service getTagValue:@"itbklg_id_real" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_titulo = [web_service getTagValue:@"itbklg_titulo" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_descricao = [web_service getTagValue:@"itbklg_descricao" inText:item_backlog_info inInitialRange:0];
            NSString *itbklg_pontos_estimativa = [web_service getTagValue:@"itbklg_pontos_estimativa" inText:item_backlog_info inInitialRange:0];
            
            NSString *itbklg_data_aceitacao = [[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]];;
            NSString *itbklg_data_exclusao = [[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]];;
            
            NSString *ptcp_id = [web_service getTagValue:@"ptcp_id" inText:item_backlog_info inInitialRange:0];
            NSString *proj_id = [web_service getTagValue:@"proj_id" inText:item_backlog_info inInitialRange:0];
            
            NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO item_backlog VALUES(%@,%@,%@, '%@', '%@', '%@', '%@', %@, %@, '%@')",itbklg_id, proj_id, ptcp_id, itbklg_titulo, itbklg_descricao, itbklg_id_real, itbklg_pontos_estimativa, itbklg_data_aceitacao, itbklg_data_exclusao, itbklg_sequencial];
            sqlite3_stmt *rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            i = pos2.location + pos2.length;
        }
    }
    else if ([url rangeOfString:@"get-sprint-backlog"].location != NSNotFound) {
        NSRange pos1;
        NSRange pos2;
        int i = 0;
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        while (TRUE) {
            NSString *sprint_backlog_info = [web_service getTagValue:@"historia" inText:returnedData inInitialRange:i];
            pos1 = web_service.last_initial_range;
            if (pos1.location == NSNotFound) {
                break;
            }
            pos2 = web_service.last_final_range;
            
            NSString *spt_id = [web_service getTagValue:@"spt_id" inText:sprint_backlog_info inInitialRange:0];
            NSString *itspt_id = [web_service getTagValue:@"itspt_id" inText:sprint_backlog_info inInitialRange:0];
            NSString *itbklg_sequencial = [web_service getTagValue:@"itbklg_sequencial" inText:sprint_backlog_info inInitialRange:0];
            
            NSString *itspt_status = [[web_service getTagValue:@"itspt_status" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itspt_status" inText:sprint_backlog_info inInitialRange:0]];
            
            NSString *itspt_data_exclusao = [[web_service getTagValue:@"itspt_data_exclusao" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itspt_data_exclusao" inText:sprint_backlog_info inInitialRange:0]];
            
            NSString *itbklg_pontos_estimativa = [[web_service getTagValue:@"itbklg_pontos_estimativa" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_pontos_estimativa" inText:sprint_backlog_info inInitialRange:0]];
            
            NSString *itbklg_data_aceitacao = [[web_service getTagValue:@"itbklg_data_aceitacao" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_aceitacao" inText:sprint_backlog_info inInitialRange:0]];
            
            NSString *itbklg_data_exclusao = [[web_service getTagValue:@"itbklg_data_exclusao" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_exclusao" inText:sprint_backlog_info inInitialRange:0]];
            
            NSString *itbklg_titulo = [web_service getTagValue:@"itbklg_titulo" inText:sprint_backlog_info inInitialRange:0];
            
            NSString *sequencial = [web_service getTagValue:@"sequencial" inText:sprint_backlog_info inInitialRange:0];
            
            NSString *spt_data_final_real = [[web_service getTagValue:@"spt_data_final_real" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"spt_data_final_real" inText:sprint_backlog_info inInitialRange:0]];
            
            NSString *spt_data_cancelamento = [[web_service getTagValue:@"spt_data_cancelamento" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"spt_data_cancelamento" inText:sprint_backlog_info inInitialRange:0]];
            
            NSString *proj_id = [web_service getTagValue:@"proj_id" inText:sprint_backlog_info inInitialRange:0];
            
            NSString *query = [[NSString alloc] initWithFormat:@"INSERT INTO item_sprint_backlog VALUES(%@,%@,%@, %@, %@, %@, %@, %@, '%@', %@, %@)",spt_id, itspt_id, itbklg_sequencial, itspt_status, itspt_data_exclusao, itbklg_pontos_estimativa, itbklg_data_aceitacao, itbklg_data_exclusao, itbklg_titulo, sequencial, proj_id];
            sqlite3_stmt *rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            query = [[NSString alloc] initWithFormat:@"INSERT INTO sprint VALUES(%@,%@,%@)",spt_id, spt_data_final_real, spt_data_cancelamento];
            rs = [db openRS:query];
            sqlite3_step(rs);
            sqlite3_finalize(rs);
            
            i = pos2.location + pos2.length;
        }
    }
    //self.progress_bar.hidden = YES;
    //self.progress_bar.progress = 0;
    
    
    
}
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrum_bg.png"]];
    menu = [NSArray arrayWithObjects:@"Projects", @"Product Backlog", @"Sprint Backlog", @"Taskboard", @"Logout", nil];
    lb_nome.text = user_nome;
    _totalFileSize = 0;
    
    db = [[DataBase alloc] init];
    
    NSMutableString* bundlePath = [NSMutableString stringWithCapacity:4];
    [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
    [bundlePath appendString:@"/scrumhalf.sql"];
    [db openDB:bundlePath];
    
    
    
    
    UIBarButtonItem *sync = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(sync:)];
    
    //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: sync, nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

-(void) sync:(id)sender {
    NSString *query = [[NSString alloc] initWithFormat:@"update usuario SET proj_id_ultimo_acesso=%@ WHERE id=%@",proj_padrao, self.user_id];
    NSLog(@"%@",query);
    [db execute:query];
    
    
    //Inserindo projetos nos quais o usuário logado está participando
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/scrum_services/get-projects-summary.php?user=%@",url_basic,user_id]]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (void)viewWillAppear:(BOOL)animated{
    
    
    
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-default-project.php?user=%@",url_basic,user_id]];
        
        proj_padrao = [web_service getTagValue:@"proj_id_ultimo_acesso" inText:xmlData inInitialRange:0];
        logged_proj_padrao = proj_padrao;
        lb_proj.text = [web_service getTagValue:@"proj_nome" inText:xmlData inInitialRange:0];
        lb_sprint.text = [NSString stringWithFormat:@"Sprint %@",[web_service getTagValue:@"sequencial" inText:xmlData inInitialRange:0]] ;
        
        xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-papel.php?user=%@&project=%@",url_basic,user_id,logged_proj_padrao]];
        
        
        NSRange pos1;
        NSRange pos2;
        int i = 0;
        [txt_papeis setText:@""];
        while (TRUE) {
            NSString *projeto_info = [web_service getTagValue:@"papel" inText:xmlData inInitialRange:i];
            pos1 = web_service.last_initial_range;
            if (pos1.location == NSNotFound) {
                break;
            }
            pos2 = web_service.last_final_range;
            
            NSString *papel = [web_service getTagValue:@"pplusr_nome" inText:projeto_info inInitialRange:0];

            [txt_papeis setText:[txt_papeis.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",papel]]] ;
            NSLog(@"%@",papel);
            
            i = pos2.location + pos2.length;
        }
        
    }
    else {
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT u.proj_id_ultimo_acesso, p.proj_nome FROM usuario u, projeto p WHERE u.id = %@ AND p.proj_id = u.proj_id_ultimo_acesso",user_id];
        
        sqlite3_stmt *rs = [db openRS:query];
        if (sqlite3_step(rs) == SQLITE_ROW) {
            proj_padrao = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
            lb_proj.text = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
        }
        sqlite3_finalize(rs);
    }
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menu count];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *projetoIdentifier = @"projetoCell";
    static NSString *pBacklogIdentifier = @"pBacklogCell";
    static NSString *sBacklogIdentifier = @"sBacklogCell";
    static NSString *taskboardIdentifier = @"taskboardCell";
    static NSString *logoutIdentifier = @"logoutCell";
    UITableViewCell *cell;
    
    
    if (indexPath.row == 0){
        cell = [self.tableView dequeueReusableCellWithIdentifier:projetoIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:projetoIdentifier];
        }
    }
    else if (indexPath.row == 1){
        cell = [self.tableView dequeueReusableCellWithIdentifier:pBacklogIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pBacklogIdentifier];
        }
    }
    else if (indexPath.row == 2){
        cell = [self.tableView dequeueReusableCellWithIdentifier:sBacklogIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sBacklogIdentifier];
        }
    }
    else if (indexPath.row == 3){
        cell = [self.tableView dequeueReusableCellWithIdentifier:taskboardIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskboardIdentifier];
        }
    }
    else if (indexPath.row == 4){
        cell = [self.tableView dequeueReusableCellWithIdentifier:logoutIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutIdentifier];
        }
    }
    
    
    cell.textLabel.text = [menu objectAtIndex:indexPath.row];
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showProjects"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ProjectsViewController *destViewController = segue.destinationViewController;
        destViewController.menuName = [menu objectAtIndex:indexPath.row];
        destViewController.user_id = user_id;
    }
    else if ([segue.identifier isEqualToString:@"showPBackLog"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ProductBacklogsViewController *destViewController = segue.destinationViewController;
        destViewController.menuName = [menu objectAtIndex:indexPath.row];
        destViewController.user_id = user_id;
        destViewController.proj_id = proj_padrao;
    }
    else if ([segue.identifier isEqualToString:@"showSBackLog"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SprintBacklogViewController *destViewController = segue.destinationViewController;
        destViewController.menuName = [menu objectAtIndex:indexPath.row];
        destViewController.user_id = user_id;
        destViewController.proj_id = proj_padrao;
    }
    else if ([segue.identifier isEqualToString:@"showTaskboard"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TaskboardViewController *destViewController = segue.destinationViewController;
        destViewController.menuName = [menu objectAtIndex:indexPath.row];
        destViewController.proj_id = proj_padrao;
    }
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
	int idx=indexPath.row;
	if (idx == 4){
        
        /*self.progress_bar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [self.progress_bar setFrame:CGRectMake(400, 400, 200, 80)];
        [self.progress_bar setProgress:50];
        [[[[[self view] superview] superview] superview] addSubview:self.progress_bar];
        */
        /*INICIO - POPULANDO BANCO DE DADOS LOCAL PARA USUARIO LOGADO*/
        //WebServiceRequest *web_service = [WebServiceRequest alloc];
        /*NSLog(@"%@",[db getLastErrorMsg]);
        //Inserindo projeto padrão na tabela 'usuario'
        NSString *query = [[NSString alloc] initWithFormat:@"update usuario SET proj_id_ultimo_acesso=%@ WHERE id=%@",proj_padrao, self.user_id];
        NSLog(@"%@",query);
        [db execute:query];
        
        
        //Inserindo projetos nos quais o usuário logado está participando
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/scrum_services/get-projects-summary.php?user=%@",url_basic,user_id]]];
        [NSURLConnection connectionWithRequest:request delegate:self];
        */
        /*
        NSString *xmlData = [web_service getHTTPResponse:];
        NSRange pos1;
        NSRange pos2;
        
        int i = 0;
        while (TRUE) {
            NSString *projeto_info = [web_service getTagValue:@"info" inText:xmlData inInitialRange:i];
            pos1 = [web_service last_initial_range];
            pos2 = [web_service last_final_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            
            NSString *proj_id = [web_service getTagValue:@"proj_id" inText:projeto_info inInitialRange:0];
            NSString *proj_nome = [web_service getTagValue:@"proj_nome" inText:projeto_info inInitialRange:0];
            NSString *proj_desc = [web_service getTagValue:@"proj_descricao" inText:projeto_info inInitialRange:0];
            NSString *proj_data_inicio = [web_service getTagValue:@"proj_data_inicio" inText:projeto_info inInitialRange:0];
            NSString *proj_data_inicio_game = [web_service getTagValue:@"proj_data_inicio_game" inText:projeto_info inInitialRange:0];
            NSString *proj_data_fim = [web_service getTagValue:@"proj_data_fim" inText:projeto_info inInitialRange:0];
            
            //Checando se o usuário já está participando do projeto no banco de dados offline
            query = [NSString stringWithFormat:@"SELECT id FROM participacao WHERE proj_id = %@ AND usr_id = %@",proj_id,user_id];
            sqlite3_stmt *rs = [db openRS:query];
            //Se não estiver
            if (sqlite3_step(rs) != SQLITE_ROW) {
                
                //Tentar inserir projeto no banco de dados offline, se não existir
                query = [[NSString alloc] initWithFormat:@"INSERT INTO projeto (proj_id,proj_nome,proj_descricao,proj_data_inicio,proj_data_inicio_game,proj_data_fim) VALUES(%@,'%@','%@', '%@', '%@', '%@')",proj_id, proj_nome, proj_desc, proj_data_inicio, proj_data_inicio_game, proj_data_fim];
                rs = [db openRS:query];
                sqlite3_step(rs);
                sqlite3_finalize(rs);
                
                NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"http://amrtec.no-ip.biz:1888/scrum_services/get-participacao.php?proj_id=%@&user=%@",proj_id, user_id]];
                
                NSString *ptcp_id = [web_service getTagValue:@"ptcp_id" inText:xmlData inInitialRange:0];
                NSString *ptcp_status = [web_service getTagValue:@"ptcp_status" inText:xmlData inInitialRange:0];
                NSString *ptcp_sigla = [web_service getTagValue:@"ptcp_sigla" inText:xmlData inInitialRange:0];
                
                //inserir participação do usuário no projeto
                
                query = [[NSString alloc] initWithFormat:@"INSERT INTO participacao (ptcp_id, usr_id,proj_id, ptcp_status, ptcp_sigla) VALUES(%@,%@, %@, '%@', '%@')",ptcp_id, user_id, proj_id, ptcp_status, ptcp_sigla];
                rs = [db openRS:query];
                sqlite3_step(rs);
                sqlite3_finalize(rs);
                //Inserindo Product Backlog dos projetos do usuário
                
                
                
                 //ESTE É O LUGAR ONDE SERÁ FEITA A SINCRONIZAÇÃO
                 //(por enquanto ele não checa se foi alterado offline)
                
                query = [NSString stringWithFormat: @"DELETE FROM item_backlog WHERE proj_id=%@",proj_id];
                rs = [db openRS:query];
                sqlite3_step(rs);
                sqlite3_finalize(rs);
                
                
                NSString *url = [NSString stringWithFormat:@"http://amrtec.no-ip.biz:1888/scrum_services/get-product-backlog.php?user=%@&&project=%@&&option=propostas",user_id, proj_id];
                NSString *xmlIBData = [web_service getHTTPResponse:url];

                NSRange pos1;
                NSRange pos2;
                int i = 0;
                
                while (TRUE) {
                    NSString *item_backlog_info = [web_service getTagValue:@"historia" inText:xmlIBData inInitialRange:i];
                    pos1 = web_service.last_initial_range;
                    if (pos1.location == NSNotFound) {
                        break;
                    }
                    pos2 = web_service.last_final_range;
                    
                    NSString *itbklg_id = [web_service getTagValue:@"itbklg_id" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_sequencial = [web_service getTagValue:@"itbklg_sequencial" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_id_real = [web_service getTagValue:@"itbklg_id_real" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_titulo = [web_service getTagValue:@"itbklg_titulo" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_descricao = [web_service getTagValue:@"itbklg_descricao" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_pontos_estimativa = [web_service getTagValue:@"itbklg_pontos_estimativa" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_data_aceitacao = [[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]];;
                    NSString *itbklg_data_exclusao = [[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]];;
                    
                    NSString *ptcp_id = [web_service getTagValue:@"ptcp_id" inText:item_backlog_info inInitialRange:0];
                    
                    query = [[NSString alloc] initWithFormat:@"INSERT INTO item_backlog VALUES(%@,%@,%@, '%@', '%@', '%@', '%@', %@, %@, '%@')",itbklg_id, proj_id, ptcp_id, itbklg_titulo, itbklg_descricao, itbklg_id_real, itbklg_pontos_estimativa, itbklg_data_aceitacao, itbklg_data_exclusao, itbklg_sequencial];
                    rs = [db openRS:query];
                    sqlite3_step(rs);
                    sqlite3_finalize(rs);
                    
                    i = pos2.location + pos2.length;
                }
                
                
                WebServiceRequest *web_service = [WebServiceRequest alloc];
                xmlIBData = [web_service getHTTPResponse:[NSString stringWithFormat:@"http://amrtec.no-ip.biz:1888/scrum_services/get-product-backlog.php?user=%@&&project=%@&&option=aceitas",user_id,proj_id]];
                i = 0;
                while (TRUE) {
                    NSString *item_backlog_info = [web_service getTagValue:@"historia" inText:xmlIBData inInitialRange:i];
                    pos1 = [web_service last_initial_range];
                    pos2 = [web_service last_final_range];
                    if (pos1.location == NSNotFound) {
                        break;
                    }
                    NSString *itbklg_id = [web_service getTagValue:@"itbklg_id" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_sequencial = [web_service getTagValue:@"itbklg_sequencial" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_id_real = [web_service getTagValue:@"itbklg_id_real" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_titulo = [web_service getTagValue:@"itbklg_titulo" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_descricao = [web_service getTagValue:@"itbklg_descricao" inText:item_backlog_info inInitialRange:0];
                    NSString *itbklg_pontos_estimativa = [web_service getTagValue:@"itbklg_pontos_estimativa" inText:item_backlog_info inInitialRange:0];
                    
                    NSString *itbklg_data_aceitacao = [[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_aceitacao" inText:item_backlog_info inInitialRange:0]];;
                    NSString *itbklg_data_exclusao = [[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_exclusao" inText:item_backlog_info inInitialRange:0]];;
                    
                    NSString *ptcp_id = [web_service getTagValue:@"ptcp_id" inText:item_backlog_info inInitialRange:0];
                    
                    query = [[NSString alloc] initWithFormat:@"INSERT INTO item_backlog VALUES(%@,%@,%@, '%@', '%@', '%@', '%@', %@, %@, '%@')",itbklg_id, proj_id, ptcp_id, itbklg_titulo, itbklg_descricao, itbklg_id_real, itbklg_pontos_estimativa, itbklg_data_aceitacao, itbklg_data_exclusao, itbklg_sequencial];
                    rs = [db openRS:query];
                    sqlite3_step(rs);
                    sqlite3_finalize(rs);
                    
                    i = pos2.location + pos2.length;
                    
                }
                
                //Inserindo Sprint Backlog dos projetos do usuário
                
                
                
                 //ESTE É O LUGAR ONDE SERÁ FEITA A SINCRONIZAÇÃO
                 //(por enquanto ele não checa se foi alterado offline)
                
                query = [NSString stringWithFormat: @"DELETE FROM item_sprint_backlog WHERE proj_id=%@",proj_id];
                rs = [db openRS:query];
                sqlite3_step(rs);
                sqlite3_finalize(rs);
                
                
                
                NSString *xmlSBData = [web_service getHTTPResponse:[NSString stringWithFormat:@"http://amrtec.no-ip.biz:1888/scrum_services/get-sprint-backlog.php?user=%@&&project=%@",user_id,proj_id]];
                
                i = 0;
                while (TRUE) {
                    NSString *sprint_backlog_info = [web_service getTagValue:@"historia" inText:xmlSBData inInitialRange:i];
                    pos1 = web_service.last_initial_range;
                    if (pos1.location == NSNotFound) {
                        break;
                    }
                    pos2 = web_service.last_final_range;
                    
                    NSString *spt_id = [web_service getTagValue:@"spt_id" inText:sprint_backlog_info inInitialRange:0];
                    NSString *itspt_id = [web_service getTagValue:@"itspt_id" inText:sprint_backlog_info inInitialRange:0];
                    NSString *itbklg_sequencial = [web_service getTagValue:@"itbklg_sequencial" inText:sprint_backlog_info inInitialRange:0];

                    NSString *itspt_status = [[web_service getTagValue:@"itspt_status" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itspt_status" inText:sprint_backlog_info inInitialRange:0]];
                    
                    NSString *itspt_data_exclusao = [[web_service getTagValue:@"itspt_data_exclusao" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itspt_data_exclusao" inText:sprint_backlog_info inInitialRange:0]];
                    
                    NSString *itbklg_pontos_estimativa = [[web_service getTagValue:@"itbklg_pontos_estimativa" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_pontos_estimativa" inText:sprint_backlog_info inInitialRange:0]];
                    
                    NSString *itbklg_data_aceitacao = [[web_service getTagValue:@"itbklg_data_aceitacao" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_aceitacao" inText:sprint_backlog_info inInitialRange:0]];
                    
                    NSString *itbklg_data_exclusao = [[web_service getTagValue:@"itbklg_data_exclusao" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"itbklg_data_exclusao" inText:sprint_backlog_info inInitialRange:0]];
                    
                    NSString *itbklg_titulo = [web_service getTagValue:@"itbklg_titulo" inText:sprint_backlog_info inInitialRange:0];
                    
                    NSString *sequencial = [web_service getTagValue:@"sequencial" inText:sprint_backlog_info inInitialRange:0];
                    
                    NSString *spt_data_final_real = [[web_service getTagValue:@"spt_data_final_real" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"spt_data_final_real" inText:sprint_backlog_info inInitialRange:0]];
                    
                    NSString *spt_data_cancelamento = [[web_service getTagValue:@"spt_data_cancelamento" inText:sprint_backlog_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"spt_data_cancelamento" inText:sprint_backlog_info inInitialRange:0]];
                    
                    query = [[NSString alloc] initWithFormat:@"INSERT INTO item_sprint_backlog VALUES(%@,%@,%@, %@, %@, %@, %@, %@, '%@', %@, %@)",spt_id, itspt_id, itbklg_sequencial, itspt_status, itspt_data_exclusao, itbklg_pontos_estimativa, itbklg_data_aceitacao, itbklg_data_exclusao, itbklg_titulo, sequencial, proj_id];
                    rs = [db openRS:query];
                    sqlite3_step(rs);
                    sqlite3_finalize(rs);
                    
                    query = [[NSString alloc] initWithFormat:@"INSERT INTO sprint VALUES(%@,%@,%@)",spt_id, spt_data_final_real, spt_data_cancelamento];
                    rs = [db openRS:query];
                    sqlite3_step(rs);
                    sqlite3_finalize(rs);
                    
                    i = pos2.location + pos2.length;
                }
                //Inserindo tarefas das sprints referentes aos projetos do usuário
                
                NSString *xmlTData = [web_service getHTTPResponse:[NSString stringWithFormat:@"http://amrtec.no-ip.biz:1888/scrum_services/get-taskboard.php?project=%%20%@%%20",proj_id]];

                
                i = 0;
                while (TRUE) {
                    NSString *tarefa_info = [web_service getTagValue:@"tarefa" inText:xmlTData inInitialRange:i];
                    pos1 = web_service.last_initial_range;
                    if (pos1.location == NSNotFound) {
                        break;
                    }
                    pos2 = web_service.last_final_range;
                    
                    NSString *trfa_id = [web_service getTagValue:@"trfa_id" inText:tarefa_info inInitialRange:0];
                    NSString *itspt_id = [web_service getTagValue:@"itbklg_id" inText:tarefa_info inInitialRange:0];
                    NSString *trfa_titulo = [web_service getTagValue:@"trfa_titulo" inText:tarefa_info inInitialRange:0];
                    
                    NSString *trfa_descricao = [[web_service getTagValue:@"trfa_descricao" inText:tarefa_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"trfa_descricao" inText:tarefa_info inInitialRange:0]];
                    
                    NSString *trfa_impedimento = [web_service getTagValue:@"trfa_impedimento" inText:tarefa_info inInitialRange:0];
                    
                    NSString *trfa_data_exclusao = [[web_service getTagValue:@"trfa_data_exclusao" inText:tarefa_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"trfa_data_exclusao" inText:tarefa_info inInitialRange:0]];
                    
                    NSString *trfa_data_inicio = [[web_service getTagValue:@"trfa_data_inicio" inText:tarefa_info inInitialRange:0]  isEqual: @""] ? @"NULL": [NSString stringWithFormat:@"\"%@\"",[web_service getTagValue:@"trfa_data_inicio" inText:tarefa_info inInitialRange:0]];
                    
                    
                    
                    NSString *inic_id = [web_service getTagValue:@"inic_id" inText:tarefa_info inInitialRange:0];
                    
                    NSString *fase_id = [web_service getTagValue:@"fase_id" inText:tarefa_info inInitialRange:0];
                    
                    NSString *inic_data = [web_service getTagValue:@"inic_data" inText:tarefa_info inInitialRange:0];
                   
                    
                    query = [[NSString alloc] initWithFormat:@"INSERT INTO tarefa VALUES(%@,%@,'%@', %@, %@, %@, NULL, %@, NULL)", trfa_id, itspt_id, trfa_titulo, trfa_descricao, trfa_impedimento, trfa_data_exclusao, trfa_data_inicio];
                    //NSLog(@"%@",query);
                    rs = [db openRS:query];
                    sqlite3_step(rs);
                    sqlite3_finalize(rs);
                    
                    query = [[NSString alloc] initWithFormat:@"INSERT INTO inicio_fase VALUES(%@,%@,%@,'%@')",inic_id, trfa_id, fase_id, inic_data];
                    rs = [db openRS:query];
                    sqlite3_step(rs);
                    sqlite3_finalize(rs);
                    
                    i = pos2.location + pos2.length;
                }
                
                
            }
            
            
            //sqlite3_finalize(rs);
            i = pos2.location + pos2.length;
        }
        */
        
        
        
        /*FINAL - POPULANDO BANCO DE DADOS LOCAL PARA USUARIO LOGADO*/
        
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end

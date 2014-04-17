//
//  ProjetoViewController.m
//  ScrumRemote
//
//  Created by Tec Portal on 29/01/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "ProductBacklogsViewController.h"
@interface ProductBacklogsViewController ()

@end

@implementation ProductBacklogsViewController{
    NSMutableArray *product_backlog_p;
    NSMutableArray *product_backlog_p_id;
    NSMutableArray *product_backlog_p_desc;
    NSMutableArray *product_backlog_p_est;
    
    NSMutableArray *product_backlog_a;
    NSMutableArray *product_backlog_a_id;
    NSMutableArray *product_backlog_a_desc;
    NSMutableArray *product_backlog_a_est;
}
@synthesize menuName;
@synthesize user_id;
@synthesize proj_id;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = menuName;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrum_bg.png"]];

    [self loadData];
    
    
    UIBarButtonItem *sync = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(sync:)];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:add, nil];
}

-(void) loadData
{
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-papel.php?user=%@&project=%@",url_basic,user_id,proj_id]];
        
        
        NSRange pos1;
        NSRange pos2;
        int i = 0;
        
        while (TRUE) {
            NSString *projeto_info = [web_service getTagValue:@"papel" inText:xmlData inInitialRange:i];
            pos1 = web_service.last_initial_range;
            if (pos1.location == NSNotFound) {
                break;
            }
            pos2 = web_service.last_final_range;
            
            NSString *projeto_nome = [web_service getTagValue:@"pplusr_sigla" inText:projeto_info inInitialRange:0];
            
            if ([projeto_nome  isEqual: @"PO"]) {
                is_po = YES;
            }
            
            i = pos2.location + pos2.length;
        }
        
        
        WebServiceRequest *web_service_p = [WebServiceRequest alloc];
        xmlData = [web_service_p getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-product-backlog.php?user=%@&project=%@&option=propostas",url_basic,user_id,proj_id]];
        
        i = 0;
        product_backlog_p = [[NSMutableArray alloc] init];
        product_backlog_p_id = [[NSMutableArray alloc] init];
        product_backlog_p_desc = [[NSMutableArray alloc] init];
        product_backlog_p_est = [[NSMutableArray alloc] init];
        while (TRUE) {
            NSString *projeto_info = [web_service_p getTagValue:@"historia" inText:xmlData inInitialRange:i];
            pos1 = web_service_p.last_initial_range;
            if (pos1.location == NSNotFound) {
                break;
            }
            pos2 = web_service_p.last_final_range;
            
            NSString *projeto_id = [web_service_p getTagValue:@"itbklg_id" inText:projeto_info inInitialRange:0];
            NSString *projeto_nome = [web_service_p getTagValue:@"itbklg_titulo" inText:projeto_info inInitialRange:0];
            NSString *projeto_desc = [web_service_p getTagValue:@"itbklg_descricao" inText:projeto_info inInitialRange:0];
            NSString *projeto_est = [web_service_p getTagValue:@"itbklg_pontos_estimativa" inText:projeto_info inInitialRange:0];
            
            [product_backlog_p addObject:projeto_nome];
            [product_backlog_p_id addObject:projeto_id];
            [product_backlog_p_est addObject:projeto_est];
            [product_backlog_p_desc addObject:projeto_desc];
            i = pos2.location + pos2.length;
        }
        
        
        WebServiceRequest *web_service_a = [WebServiceRequest alloc];
        xmlData = [web_service_a getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-product-backlog.php?user=%@&project=%@&option=aceitas",url_basic,user_id,proj_id]];
        i = 0;
        product_backlog_a = [[NSMutableArray alloc] init];
        product_backlog_a_id = [[NSMutableArray alloc] init];
        product_backlog_a_desc = [[NSMutableArray alloc] init];
        product_backlog_a_est = [[NSMutableArray alloc] init];
        while (TRUE) {
            NSString *projeto_info = [web_service_a getTagValue:@"historia" inText:xmlData inInitialRange:i];
            pos1 = [web_service_a last_initial_range];
            pos2 = [web_service_a last_final_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            NSString *projeto_id = [web_service_a getTagValue:@"itbklg_id" inText:projeto_info inInitialRange:0];
            NSString *projeto_nome = [web_service_a getTagValue:@"itbklg_titulo" inText:projeto_info inInitialRange:0];
            NSString *projeto_desc = [web_service_a getTagValue:@"itbklg_descricao" inText:projeto_info inInitialRange:0];
            NSString *projeto_est = [web_service_a getTagValue:@"itbklg_pontos_estimativa" inText:projeto_info inInitialRange:0];
            
            [product_backlog_a addObject:projeto_nome];
            [product_backlog_a_id addObject:projeto_id];
            [product_backlog_a_est addObject:projeto_est];
            [product_backlog_a_desc addObject:projeto_desc];
            
            i = pos2.location + pos2.length;
            
        }
    }
    else {
        db = [[DataBase alloc] init];
        
        NSMutableString* bundlePath = [NSMutableString stringWithCapacity:4];
        [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
        [bundlePath appendString:@"/scrumhalf.sql"];
        [db openDB:bundlePath];
        
        product_backlog_p = [[NSMutableArray alloc] init];
        product_backlog_p_id = [[NSMutableArray alloc] init];
        product_backlog_p_desc = [[NSMutableArray alloc] init];
        product_backlog_p_est = [[NSMutableArray alloc] init];
        
        product_backlog_a = [[NSMutableArray alloc] init];
        product_backlog_a_id = [[NSMutableArray alloc] init];
        product_backlog_a_desc = [[NSMutableArray alloc] init];
        product_backlog_a_est = [[NSMutableArray alloc] init];
        
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT ib.itbklg_titulo, ib.itbklg_id, ib.itbklg_descricao, ib.itbklg_pontos_estimativa FROM item_backlog ib, participacao pa WHERE pa.usr_id = %@ AND pa.proj_id = ib.proj_id AND ib.proj_id = %@ AND ib.itbklg_data_aceitacao IS NULL AND ib.itbklg_data_exclusao IS NULL",user_id, proj_id];
        
        sqlite3_stmt *rs = [db openRS:query];
        while (sqlite3_step(rs) == SQLITE_ROW) {
            
            NSString *projeto_titulo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
            NSString *projeto_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
            NSString *projeto_desc = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 2)];
            NSString *projeto_est = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 3)];
            
            [product_backlog_p addObject:projeto_titulo];
            [product_backlog_p_id addObject:projeto_id];
            [product_backlog_a_est addObject:projeto_est];
            [product_backlog_a_desc addObject:projeto_desc];
        }
        sqlite3_finalize(rs);
        
        query = [[NSString alloc] initWithFormat:@"SELECT ib.itbklg_titulo, ib.itbklg_id, ib.itbklg_descricao, ib.itbklg_pontos_estimativa FROM item_backlog ib WHERE ib.proj_id = %@ AND ib.itbklg_data_aceitacao IS NOT NULL AND ib.itbklg_data_exclusao IS NULL", proj_id];
        rs = [db openRS:query];
        while (sqlite3_step(rs) == SQLITE_ROW) {
            NSString *projeto_titulo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
            NSString *projeto_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
            NSString *projeto_desc = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 2)];
            NSString *projeto_est = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 3)];
            [product_backlog_a addObject:projeto_titulo];
            [product_backlog_a_id addObject:projeto_id];
            [product_backlog_a_est addObject:projeto_est];
            [product_backlog_a_desc addObject:projeto_desc];
        }
        sqlite3_finalize(rs);
    }
    [tableView reloadData];
}

-(void) sync:(id)sender {
    NSLog(@"asdsa");
}

-(void) addItem:(id)sender {
    //[modal setHidden:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ModalDismissed" object:nil];
    [self performSegueWithIdentifier:@"addItemBacklogSegue" sender:sender];
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
    switch (section){
        case 0:
            return [product_backlog_p count];
            break;
        case 1:
            return [product_backlog_a count];
            break;
        default:
            return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:   (NSInteger)section
{
    switch (section){
        case 0:
            return @"Propostas";
            break;
        case 1:
            return @"Aceitas";
            break;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *projetoIdentifier = @"ibDetailsCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:projetoIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:projetoIdentifier];
    }
    switch (indexPath.section)
    {
            
        case 0:
            cell.textLabel.text = [product_backlog_p objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [product_backlog_a objectAtIndex:indexPath.row];
            break;
        default:
            cell.textLabel.text = @"Not Found";
            
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return is_po;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ModalDismissed" object:nil];
    [self performSegueWithIdentifier:@"EditItemBacklogSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditItemBacklogSegue"]) {
        EditItemBacklog *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%@",indexPath);
        switch (indexPath.section)
        {
                
            case 0:
                destViewController.item_title = [product_backlog_p objectAtIndex:indexPath.row];
                destViewController.item_id = [[product_backlog_p_id objectAtIndex:indexPath.row] intValue];
                destViewController.descricao = [product_backlog_p_desc objectAtIndex:indexPath.row];
                destViewController.estimativa = [product_backlog_p_est objectAtIndex:indexPath.row];
                //destViewController.tableView = self.tableView;
                destViewController.tipo = 'p';
                break;
            case 1:
                destViewController.item_title = [product_backlog_a objectAtIndex:indexPath.row];
                destViewController.item_id = [[product_backlog_a_id objectAtIndex:indexPath.row] intValue];
                destViewController.descricao = [product_backlog_a_desc objectAtIndex:indexPath.row];
                destViewController.estimativa = [product_backlog_a_est objectAtIndex:indexPath.row];
                destViewController.tipo = 'a';
                break;
        }
        
    }
}

@end

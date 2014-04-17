//
//  SprintBacklogViewController.m
//  ScrumRemote
//
//  Created by Glauco Primo on 30/01/14.
//
//

#import "SprintBacklogViewController.h"
#import "ViewItemSprint.h"
@interface SprintBacklogViewController ()

@end

@implementation SprintBacklogViewController{
    NSMutableArray *sprint_backlog_id;
    NSMutableArray *sprint_backlog_seq;
    NSMutableArray *sprint_backlog_titulo;
    NSMutableArray *sprint_backlog_desc;
    NSMutableArray *sprint_backlog_est;
}

@synthesize menuName;
@synthesize user_id;
@synthesize proj_id;
@synthesize tableView;



-(void) loadData
{
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-sprint-backlog.php?user=%@&project=%@",url_basic,user_id,proj_id]];
        
        NSRange pos1;
        NSRange pos2;
        int i = 0;
        sprint_backlog_seq = [[NSMutableArray alloc] init];
        sprint_backlog_titulo = [[NSMutableArray alloc] init];
        sprint_backlog_est = [[NSMutableArray alloc] init];
        sprint_backlog_id = [[NSMutableArray alloc] init];
        sprint_backlog_desc = [[NSMutableArray alloc] init];
        
        while (TRUE) {
            
            NSString *projeto_info = [web_service getTagValue:@"historia" inText:xmlData inInitialRange:i];
            pos2 = [web_service last_final_range];
            pos1 = [web_service last_initial_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            
            NSString *historia_id = [web_service getTagValue:@"itspt_id" inText:projeto_info inInitialRange:0];
            NSString *historia_sequencial = [web_service getTagValue:@"itbklg_sequencial" inText:projeto_info inInitialRange:0];
            NSString *historia_titulo = [web_service getTagValue:@"itbklg_titulo" inText:projeto_info inInitialRange:0];
            NSString *historia_pontos_estimativa = [web_service getTagValue:@"itbklg_pontos_estimativa" inText:projeto_info inInitialRange:0];
            NSString *historia_desc = [web_service getTagValue:@"itbklg_descricao" inText:projeto_info inInitialRange:0];
            
            //NSLog(@"location: %d / i: %d",pos1.location,i);
            
            [sprint_backlog_desc addObject: historia_desc];
            [sprint_backlog_seq addObject: historia_sequencial];
            [sprint_backlog_titulo addObject: historia_titulo];
            [sprint_backlog_est addObject: historia_pontos_estimativa];
            [sprint_backlog_id addObject: historia_id];
            
            i = pos2.location + pos2.length;
        }
    }
    else {
        db = [[DataBase alloc] init];
        
        NSMutableString* bundlePath = [NSMutableString stringWithCapacity:4];
        [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
        [bundlePath appendString:@"/scrumhalf.sql"];
        [db openDB:bundlePath];
        
        sprint_backlog_seq = [[NSMutableArray alloc] init];
        sprint_backlog_titulo = [[NSMutableArray alloc] init];
        sprint_backlog_est = [[NSMutableArray alloc] init];
        sprint_backlog_id = [[NSMutableArray alloc] init];
        sprint_backlog_desc = [[NSMutableArray alloc] init];
        
        NSString *query = [[NSString alloc] initWithFormat:@"SELECT isb.itbklg_sequencial, isb.itbklg_titulo, isb.itbklg_pontos_estimativa, isb.itspt_id, ib.itbklg_descricao FROM item_sprint_backlog isb, sprint sp, item_backlog ib WHERE ib.itbklg_id = isb.itspt_id isb.proj_id = %@ AND isb.itspt_data_exclusao IS NULL AND sp.spt_id = isb.spt_id AND sp.spt_data_final_real IS NULL AND sp.spt_data_cancelamento IS NULL ORDER BY isb.sequencial", proj_id];
        
        sqlite3_stmt *rs = [db openRS:query];
        while (sqlite3_step(rs) == SQLITE_ROW) {
            
            NSString *historia_sequencial = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
            NSString *historia_titulo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
            NSString *historia_pontos_estimativa = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 2)];
            NSString *historia_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 3)];
            NSString *historia_desc = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 4)];
            [sprint_backlog_desc addObject: historia_desc];
            [sprint_backlog_id addObject: historia_id];
            [sprint_backlog_seq addObject: historia_sequencial];
            [sprint_backlog_titulo addObject: historia_titulo];
            [sprint_backlog_est addObject: historia_pontos_estimativa];
        }
        sqlite3_finalize(rs);
        
        
    }
    [tableView reloadData];
}

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

-(void) sync:(id)sender {
    NSLog(@"asdsa");
}

-(void) addItem:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ModalDismissed" object:nil];
    [self performSegueWithIdentifier:@"addItemSprintSegue" sender:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ModalDismissed" object:nil];
    [self performSegueWithIdentifier:@"ViewItemSprintSegue" sender:self];
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"SectionHeader";
    UITableViewCell *headerView = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    UILabel *lb_itens = (UILabel *)[headerView viewWithTag:1];
    [lb_itens setText:@"ID"];
    
    UILabel *lb_todo = (UILabel *)[headerView viewWithTag:2];
    [lb_todo setText:@"Título"];
    
    UILabel *lb_doing = (UILabel *)[headerView viewWithTag:3];
    [lb_doing setText:@"Estimativa"];
    
    [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    return headerView;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [sprint_backlog_est count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: nil];
    }
    //UIView *cell_content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 900, 50)];
    UILabel *lb_seq = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 70, 48)];
    lb_seq.text = [sprint_backlog_seq objectAtIndex:indexPath.row];
    
    UILabel *lb_tit = [[UILabel alloc] initWithFrame:CGRectMake(100, 2, 900, 48)];
    lb_tit.text = [sprint_backlog_titulo objectAtIndex:indexPath.row];
    
    UILabel *lb_est = [[UILabel alloc] initWithFrame:CGRectMake(870, 2, 100, 48)];
    lb_est.text = [sprint_backlog_est objectAtIndex:indexPath.row];
    
    [cell.contentView addSubview:lb_seq];
    [cell.contentView addSubview:lb_tit];
    [cell.contentView addSubview:lb_est];
    
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewItemSprintSegue"]) {
        ViewItemSprint *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSLog(@"%d",indexPath.row);
        
        destViewController.item_title = [sprint_backlog_titulo objectAtIndex:indexPath.row];
        destViewController.item_id = [sprint_backlog_id objectAtIndex:indexPath.row];
        destViewController.descricao = [sprint_backlog_desc objectAtIndex:indexPath.row];
        destViewController.estimativa = [sprint_backlog_est objectAtIndex:indexPath.row];
    }
}

@end

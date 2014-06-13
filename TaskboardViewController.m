//
//  TaskboardViewController.m
//  ScrumRemote
//
//  Created by Glauco Primo on 30/01/14.
//
//

#import "TaskboardViewController.h"
#import "SprintItem.h"
#import "AddTask.h"
#import "EditTask.h"

#define MAX2(a,b) ( ((a) > (b)) ? (a) : (b)  )
#define MAX3(a,b,c) ( MAX(a, MAX(b,c))  )
@interface TaskboardViewController ()

@end

@implementation TaskboardViewController {
    NSMutableArray *sprint_items;
}
@synthesize tableView;

@synthesize menuName;
@synthesize proj_id;


-(void) clickTask:(id) sender {
    
    
    
    
}

-(void) moveTask:(id) sender{
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    //NSLog(@"%d",[[sender view] tag]);
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-task-ptcp.php?trfa_id=%d",url_basic,[[sender view] tag]]];
        
        NSString *sigla = [web_service getTagValue:@"ptcp_sigla" inText:xmlData inInitialRange:0];
        NSString *fase = [web_service getTagValue:@"fase_id" inText:xmlData inInitialRange:0];
        int fase_int = [fase intValue];
        NSLog(@"%@, %@",logged_user_sigla,sigla);
        
        NSLog(@"%@,%d",logged_user_sigla,[[sender view] tag]);
        if (![sigla isEqual: logged_user_sigla] && fase_int > 1) {
            can_move = NO;
            return;
        }
        else
        {
            can_move = YES;
        }
        
        if (can_move) {
            [sender view].layer.zPosition = MAXFLOAT;
            firstX = [[sender view] center].x;
            firstY = [[sender view] center].y;
            [selected_view setHidden:false];
        }
        
    }
    else if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded){
        if (can_move) {
            
                int estado_inicial = 0;
                if (firstX - [sender view].frame.size.height/2 >= 190 && firstX - [sender view].frame.size.height/2 < 465) {
                    estado_inicial = 1;
                }
                else if (firstX - [sender view].frame.size.height/2 >= 465 && firstX - [sender view].frame.size.height/2 < 730){
                    estado_inicial = 2;
                }
                else if (firstX - [sender view].frame.size.height/2 >= 730){
                    estado_inicial = 3;
                }
                
                //NSLog(@"%f",firstX+ translatedPoint.x - [sender view].frame.size.height/2);
                int estado_final = 0;
                if (firstX+translatedPoint.x - [sender view].frame.size.height/2 >= 190 && firstX+translatedPoint.x - [sender view].frame.size.height/2 < 465) {
                    estado_final = 1;
                }
                else if (firstX+translatedPoint.x - [sender view].frame.size.height/2 >= 465 && firstX+translatedPoint.x - [sender view].frame.size.height/2 < 730){
                    estado_final = 2;
                }
                else if (firstX+translatedPoint.x - [sender view].frame.size.height/2 >= 730){
                    estado_final = 3;
                }
                
                if (estado_final != estado_inicial) {
                    if (estado_final == 3 && estado_inicial == 1) {
                        change_state_alert = [[UIAlertView alloc] initWithTitle:@"Mudança de STATUS" message:@"Não é possível passar do estado \"TO DO\" para o estado \"DONE\"" delegate:self cancelButtonTitle:@"Não" otherButtonTitles: nil, nil];
                        [change_state_alert show];
                        [tableView reloadData];
                    }
                    else {
                        selected_fase_id = estado_final;
                        selected_task_id = [[sender view] tag];
                        change_state_alert = [[UIAlertView alloc] initWithTitle:@"Mudança de STATUS" message:@"Deseja alterar o estado da tarefa?" delegate:self cancelButtonTitle:@"Não" otherButtonTitles: @"Sim", nil];
                        [change_state_alert show];
                    }
                        
                    
                }
                else
                {
                    [tableView reloadData];
                }
                [selected_view setHidden:true];
                [sender view].layer.zPosition = 0;
            can_move = NO;
        }
    }
    if (can_move) {
        translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
        //NSLog(@"%f, %f : (0,%f)",translatedPoint.x - [sender view].frame.size.width/2, translatedPoint.y - [sender view].frame.size.height/2,[sender view].superview.frame.size.height - [sender view].frame.size.height);
        
        if (translatedPoint.y - [sender view].frame.size.height/2 > 0 && translatedPoint.y - [sender view].frame.size.height/2 < [sender view].superview.frame.size.height - [sender view].frame.size.height && translatedPoint.x - [sender view].frame.size.width/2 >= 200) {
            [[sender view] setCenter:translatedPoint];
        }
        
        
        if (translatedPoint.x - [sender view].frame.size.width/2 >= 190 && translatedPoint.x - [sender view].frame.size.width/2 < 465) {
            [selected_view setFrame:CGRectMake(190, 0, 265, [sender view].superview.frame.size.height)];
            [[sender view].superview addSubview:selected_view];
            //NSLog(@"%d: TO DO",[[sender view] tag]);
        }
        else if (translatedPoint.x - [sender view].frame.size.width/2 >= 465 && translatedPoint.x - [sender view].frame.size.width/2 < 730) {
            
            [selected_view setFrame:CGRectMake(455, 0, 265, [sender view].superview.frame.size.height)];
            [[sender view].superview addSubview:selected_view];
            //NSLog(@"%d: DOING",[[sender view] tag]);
        }
        else if (translatedPoint.x - [sender view].frame.size.width/2 >= 730) {
            [selected_view setFrame:CGRectMake(720, 0, 265, [sender view].superview.frame.size.height)];
            [[sender view].superview addSubview:selected_view];
            //NSLog(@"%d: DONE",[[sender view] tag]);
        }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == change_state_alert) {
        if (buttonIndex == 0) {
            for (int i = 0; i < [sprint_items count]; i++) {
                for (Task *task in [[sprint_items objectAtIndex:i] tasks]) {
                    if (task.tag == selected_task_id)
                        [task setFrame:CGRectMake(firstX - 60, firstY - 60, 120, 120)];
                   
                }
            }
            
        }
        else {
            if ([WebServiceRequest isOnline]) {
                NSLog(@"%d",selected_task_id);
                WebServiceRequest *web_service = [WebServiceRequest alloc];
                if (selected_fase_id == 1) {
                    NSLog(@"%@/scrum_services/delete-inicio-fase-ptcp.php?trfa_id=%d",url_basic, selected_task_id);
                    [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/delete-inicio-fase-ptcp.php?trfa_id=%d",url_basic, selected_task_id]];
                }
                else
                {
                    [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/update-inicio-fase.php?user_id=%@&proj_id=%@&trfa_id=%d&fase_id=%d",url_basic,logged_user_id, logged_proj_padrao, selected_task_id,selected_fase_id]];
                }
            }
            [self loadData];
            [tableView reloadData];
        }
    }
}

-(void) loadData
{
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-taskboard.php?project=%@",url_basic,proj_id]];
        
        NSRange pos1;
        NSRange pos2;
        
        int i = 0;
        sprint_items = [[NSMutableArray alloc] init];
        
        while (TRUE) {
            NSString *item_content = [web_service getTagValue:@"item" inText:xmlData inInitialRange:i];
            pos2 = [web_service last_final_range];
            pos1 = [web_service last_initial_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            
            NSRange pos3;
            NSRange pos4;
            int j = 0;
            
            NSString *item_titulo;
            NSString *item_id;
            
            item_id = [web_service getTagValue:@"id" inText:item_content inInitialRange:0];
            item_titulo = [web_service getTagValue:@"titulo" inText:item_content inInitialRange:0];
            
            NSMutableArray *tarefas = [[NSMutableArray alloc] init];
            
            while (TRUE) {
                NSString *tarefa_content = [web_service getTagValue:@"tarefa" inText:item_content inInitialRange:j];
                pos4 = [web_service last_final_range];
                pos3 = [web_service last_initial_range];
                if (pos3.location == NSNotFound) {
                    break;
                }
                /*item_id = [web_service getTagValue:@"itbklg_id" inText:tarefa_content inInitialRange:0];
                item_titulo = [web_service getTagValue:@"itbklg_titulo" inText:tarefa_content inInitialRange:0];*/
                NSString *tarefa_titulo = [web_service getTagValue:@"trfa_titulo" inText:tarefa_content inInitialRange:0];
                NSString *fase = [web_service getTagValue:@"fase_nome" inText:tarefa_content inInitialRange:0];
                NSString *data_inicio = [web_service getTagValue:@"trfa_data_inicio" inText:tarefa_content inInitialRange:0];
                NSString *trfa_id = [web_service getTagValue:@"trfa_id" inText:tarefa_content inInitialRange:0];
                NSString *sigla = [web_service getTagValue:@"ptcp_sigla" inText:tarefa_content inInitialRange:0];
                
                NSString *tipo;
                
                if ([[web_service getTagValue:@"trfa_impedimento" inText:tarefa_content inInitialRange:0]  isEqual: @"1"])
                {
                    tipo = @"Impedimento";
                }
                else if ([[web_service getTagValue:@"trfa_bug" inText:tarefa_content inInitialRange:0]  isEqual: @"1"])
                {
                    tipo = @"Bug";
                }
                else
                {
                    tipo = @"Tarefa";
                }
                
                Task *tarefa = [[Task alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                
                if ([tipo isEqual: @"Tarefa"]) {
                    [tarefa setBackgroundColor:[UIColor colorWithRed:255/255.0f green:253/255.0f blue:225/255.0f alpha:1.0f]];
                }
                else if ([tipo isEqual:@"Impedimento"]) {
                    [tarefa setBackgroundColor:[UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1.0f]];
                }
                else {
                    [tarefa setBackgroundColor:[UIColor colorWithRed:250/255.0f green:192/255.0f blue:192/255.0f alpha:1.0f]];
                }
                
                /*NSString *ptcp_data = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-task-ptcp.php?trfa_id=%d",url_basic,[trfa_id intValue]]];
                */
                
                
                
                //[tarefa setBackgroundColor:[UIColor yellowColor]];
                tarefa.task_title = tarefa_titulo;
                tarefa.task_status = fase;
                tarefa.task_start_date = data_inicio;
                tarefa.ptcp_sigla = sigla;
                tarefa.tag = [trfa_id intValue];
                
                UITapGestureRecognizer *tapTask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTask:)];
                UIPanGestureRecognizer *moveTask = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTask:)];
                [moveTask setMinimumNumberOfTouches:1];
                [moveTask setMaximumNumberOfTouches:1];
                
                [tarefa addGestureRecognizer:tapTask];
                [tarefa addGestureRecognizer:moveTask];
                
                [tarefas addObject:tarefa];
                
                j = pos4.location + pos4.length;
                
            }
            
            
            SprintItem *sprint_item = [[SprintItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: nil];
            sprint_item.item_title = item_titulo;
            sprint_item.item_id = [item_id intValue];
            sprint_item.tasks = tarefas;
            
            sprint_item.view_titulo  = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 180, 170)];
            [sprint_item.view_titulo setBackgroundColor:[UIColor whiteColor]];
            [sprint_item.view_titulo.layer setCornerRadius:5.0f];
            [sprint_item.view_titulo.layer setBorderColor:[UIColor lightGrayColor].CGColor];
            [sprint_item.view_titulo.layer setBorderWidth:1.0f];
            [sprint_item.view_titulo.layer setShadowColor:[UIColor lightGrayColor].CGColor];
            [sprint_item.view_titulo.layer setShadowOpacity:0.8];
            [sprint_item.view_titulo.layer setShadowRadius:3.0];
            [sprint_item.view_titulo.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
            
            
            addTaskButton *bt_add = [[addTaskButton alloc] initWithFrame:CGRectMake(0, 150, 180, 20)];
            [bt_add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [bt_add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [bt_add setTitle:@"+" forState:UIControlStateNormal];
            bt_add.backgroundColor = [UIColor colorWithRed:159/255.0f green:202/255.0f blue:55/255.0f alpha:1.0f];
            bt_add.layer.borderColor = [UIColor colorWithRed:115/255.0f green:153/255.0f blue:24/255.0f alpha:1.0f].CGColor;
            bt_add.layer.borderWidth = 0.5f;
            bt_add.layer.cornerRadius = 5.0f;
            [bt_add addTarget:self action:@selector(addTarefa:) forControlEvents:UIControlEventTouchUpInside];
            bt_add.item_title = item_titulo;
            bt_add.item_id = item_id;
            
            /*UILabel *lb_bt = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 180, 10)];
             lb_bt.text = @"+";
             lb_bt.numberOfLines = 0;
             [lb_bt sizeToFit];*/
            
            UILabel *lb_tit = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 160, 180)];
            lb_tit.text = sprint_item.item_title;
            lb_tit.numberOfLines = 0;
            [lb_tit sizeToFit];
            [sprint_item.view_titulo addSubview:bt_add];
            [sprint_item.view_titulo addSubview:lb_tit];
            
            [sprint_items addObject: sprint_item];
            
            
            i = pos2.location + pos2.length;
            
        }
        
    }
    else {
        db = [[DataBase alloc] init];
        
        NSMutableString* bundlePath = [NSMutableString stringWithCapacity:4];
        [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
        [bundlePath appendString:@"/scrumhalf.sql"];
        [db openDB:bundlePath];
        
        NSString *query = [NSString stringWithFormat:@"SELECT ta.itspt_id, isb.itbklg_titulo, ta.trfa_titulo, fa.fase_nome, ta.trfa_data_inicio, ta.trfa_id FROM tarefa ta, item_sprint_backlog isb, sprint sp, fase fa, inicio_fase infa WHERE ta.itspt_id = isb.itspt_id AND isb.proj_id = %@ AND sp.spt_id = isb.spt_id AND sp.spt_data_final_real IS NULL AND sp.spt_data_cancelamento IS NULL AND isb.itspt_data_exclusao IS NULL AND ta.trfa_data_exclusao IS NULL AND infa.trfa_id = ta.trfa_id AND fa.fase_id = infa.fase_id AND infa.inic_id = (SELECT MAX(inic_id) FROM inicio_fase WHERE trfa_id = ta.trfa_id) ORDER BY isb.itspt_id",proj_id];
        
        sqlite3_stmt *rs = [db openRS:query];
        int id_ant = nil;
        int i = 0;
        sprint_items = [[NSMutableArray alloc] init];
        while (sqlite3_step(rs) == SQLITE_ROW) {
            if (sqlite3_column_int(rs, 0) != id_ant) {
                NSMutableArray *tarefas = [[NSMutableArray alloc] init];
                
                NSString *item_id = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
                NSString *item_titulo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
                NSString *tarefa_titulo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 2)];
                NSString *fase = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 3)];
                NSString *data_inicio;
                if (sqlite3_column_text(rs, 4) == nil) {
                    data_inicio = @"";
                }
                else
                    data_inicio = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 4)];
                
                Task *tarefa = [[Task alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                [tarefa setBackgroundColor:[UIColor yellowColor]];
                tarefa.task_title = tarefa_titulo;
                tarefa.task_status = fase;
                tarefa.task_start_date = data_inicio;
                tarefa.tag = sqlite3_column_int(rs, 5);
                
                UIPanGestureRecognizer *moveTask = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTask:)];
                [moveTask setMinimumNumberOfTouches:1];
                [moveTask setMaximumNumberOfTouches:1];
                
                UITapGestureRecognizer *tapTask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTask:)];
                [tarefa addGestureRecognizer:tapTask];
                [tarefa addGestureRecognizer:moveTask];
                
                [tarefas addObject:tarefa];
                
                SprintItem *sprint_item = [[SprintItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: nil];
                sprint_item.item_title = item_titulo;
                sprint_item.item_id = [item_id intValue];
                sprint_item.tasks = tarefas;
                
                sprint_item.view_titulo  = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 180, 180)];
                [sprint_item.view_titulo setBackgroundColor:[UIColor colorWithRed:255/255.0f green:253/255.0f blue:225/255.0f alpha:1.0f]];
                [sprint_item.view_titulo.layer setCornerRadius:5.0f];
                [sprint_item.view_titulo.layer setBorderColor:[UIColor lightGrayColor].CGColor];
                [sprint_item.view_titulo.layer setBorderWidth:1.0f];
                
                UIButton *bt_add = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 180, 20)];
                [bt_add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [bt_add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [bt_add setTitle:@"+" forState:UIControlStateNormal];
                bt_add.backgroundColor = [UIColor colorWithRed:159/255.0f green:202/255.0f blue:55/255.0f alpha:1.0f];
                bt_add.layer.borderColor = [UIColor colorWithRed:115/255.0f green:153/255.0f blue:24/255.0f alpha:1.0f].CGColor;
                bt_add.layer.borderWidth = 0.5f;
                bt_add.layer.cornerRadius = 5.0f;
                [bt_add addTarget:self action:@selector(addTarefa:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *lb_tit = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 180)];
                lb_tit.text = sprint_item.item_title;
                lb_tit.numberOfLines = 0;
                [lb_tit sizeToFit];
                [sprint_item.view_titulo addSubview:lb_tit];
                
                [sprint_items addObject: sprint_item];
                i++;
            }
            else {
                NSString *tarefa_titulo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 2)];
                NSString *fase = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 3)];
                NSString *data_inicio;
                if (sqlite3_column_text(rs, 4) == nil) {
                    data_inicio = @"";
                }
                else
                    data_inicio = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 4)];
                
                Task *tarefa = [[Task alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                
                [tarefa setBackgroundColor:[UIColor colorWithRed:255/255.0f green:253/255.0f blue:225/255.0f alpha:1.0f]];
                //[tarefa setBackgroundColor:[UIColor yellowColor]];
                
                tarefa.task_title = tarefa_titulo;
                tarefa.task_status = fase;
                tarefa.task_start_date = data_inicio;
                tarefa.tag = sqlite3_column_int(rs, 5);
                
                UIPanGestureRecognizer *moveTask = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTask:)];
                [moveTask setMinimumNumberOfTouches:1];
                [moveTask setMaximumNumberOfTouches:1];
                
                UITapGestureRecognizer *tapTask = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTask:)];
                [tarefa addGestureRecognizer:tapTask];
                [tarefa addGestureRecognizer:moveTask];
                
                [[[sprint_items objectAtIndex:i-1] tasks] addObject:tarefa];
            }
            id_ant = sqlite3_column_int(rs, 0);
            
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
    selected_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [selected_view setBackgroundColor:[UIColor colorWithRed:255/255.0f green:253/255.0f blue:225/255.0f alpha:0.0f]];
    [selected_view.layer setCornerRadius:5.0f];
    [selected_view.layer setBorderColor:[UIColor colorWithRed:161/255.0f green:204/255.0f blue:59/255.0f alpha:1.0f].CGColor];
    [selected_view.layer setBorderWidth:2.0f];
    
    [self loadData];
    
    
}

-(void) editTask:(id)sender {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ModalDismissed" object:nil];
    [self performSegueWithIdentifier:@"editTaskSegue" sender:sender];
}


-(void) sync:(id)sender {
    NSLog(@"asdsa");
}

-(void) encerrarSprint:(id)sender {
    NSLog(@"asdsa");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"SectionHeader";
    UITableViewCell *headerView = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    UILabel *lb_itens = (UILabel *)[headerView viewWithTag:1];
    [lb_itens setText:@"Itens"];
    
    UILabel *lb_todo = (UILabel *)[headerView viewWithTag:2];
    [lb_todo setText:@"A Fazer"];
    
    UILabel *lb_doing = (UILabel *)[headerView viewWithTag:3];
    [lb_doing setText:@"Em Execução"];
    
    UILabel *lb_done = (UILabel *)[headerView viewWithTag:4];
    [lb_done setText:@"Pronto"];
    [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [sprint_items count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        int i_todo = 0;
        int i_doing = 0;
        int i_done = 0;
        for (Task *task in [[sprint_items objectAtIndex:indexPath.row] tasks]) {
            if ([task.task_status  isEqual: @"TO DO"])
                i_todo++;
            else if ([task.task_status  isEqual: @"DOING"])
                i_doing++;
            else if ([task.task_status  isEqual: @"DONE"])
                i_done++;
        }
        int max_number_of_tasks_in_status = MAX3(i_todo, i_doing, i_done);
        if (max_number_of_tasks_in_status%2 > 0)
            max_number_of_tasks_in_status++;
        max_number_of_tasks_in_status = max_number_of_tasks_in_status/2;
        if ((125*max_number_of_tasks_in_status) > 200)
            return 125*max_number_of_tasks_in_status + 10;
    return 200;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [sprint_items objectAtIndex:indexPath.row];
    }
    
    UIView* vertLineView1 = [[UIView alloc] initWithFrame:CGRectMake(189, 0, 2.5, [self.tableView rectForRowAtIndexPath:indexPath].size.height)];
    vertLineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell.contentView addSubview:vertLineView1];
    
    UIView* vertLineView2 = [[UIView alloc] initWithFrame:CGRectMake(454, 0, 2.5, [self.tableView rectForRowAtIndexPath:indexPath].size.height)];
    vertLineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell.contentView addSubview:vertLineView2];
    
    UIView* vertLineView3 = [[UIView alloc] initWithFrame:CGRectMake(719, 0, 2.5, [self.tableView rectForRowAtIndexPath:indexPath].size.height)];
    vertLineView3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [cell.contentView addSubview:vertLineView3];
    
    [cell.contentView addSubview:[[sprint_items objectAtIndex:indexPath.row] view_titulo]];
    int i_todo_v = 0,i_todo_h = 0;
    int i_doing_v = 0,i_doing_h = 0;
    int i_done_v = 0,i_done_h = 0;
    
    for (Task *task in [[sprint_items objectAtIndex:indexPath.row] tasks]) {
        if ([task.task_status  isEqual: @"TO DO"])
        {
            [task setFrame:CGRectMake(200 + (124 * (i_todo_h%2)), 10 + (124 * i_todo_v), 120, 120)];
            if (i_todo_h%2 > 0)
                i_todo_v++;
            i_todo_h++;
        }
        else if ([task.task_status  isEqual: @"DOING"])
        {
            [task setFrame:CGRectMake(465 + (124 * (i_doing_h%2)), 10 + (124 * i_doing_v), 120, 120)];
            if (i_doing_h%2 > 0)
                i_doing_v++;
            i_doing_h++;
        }
        else if ([task.task_status  isEqual: @"DONE"])
        {
            [task setFrame:CGRectMake(730 + (124 * (i_done_h%2)), 10 + (124 * i_done_v), 120, 120)];
           
            if (i_done_h%2 > 0)
                i_done_v++;
            i_done_h++;
        }
        task.lb_tit.text = task.task_title;
        task.lb_ptcp.text = task.ptcp_sigla;
        
        [task.lb_tit sizeToFit];
        [task.lb_ptcp sizeToFit];
        
        
        
        
        
        //[task setBackgroundColor:[UIColor colorWithRed:255/255.0f green:253/255.0f blue:225/255.0f alpha:1.0f]];
        [cell.contentView addSubview:task];
        
        
    }
    
    
    
    return cell;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addTaskSegue"]) {
        AddTask *destViewController = segue.destinationViewController;
        
        destViewController.item_title = [(addTaskButton *)sender item_title];
        destViewController.item_id = [(addTaskButton *)sender item_id];
    }
    else if ([segue.identifier isEqualToString:@"editTaskSegue"]){
        EditTask *destViewController = segue.destinationViewController;
        destViewController.task_title = [ (Task *)[(UITapGestureRecognizer *)sender view] task_title];
        destViewController.task_id = [ (Task *)[(UITapGestureRecognizer *)sender view] tag];

    }
}
-(void) addTarefa:(id)sender{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"ModalDismissed" object:nil];
    [self performSegueWithIdentifier:@"addTaskSegue" sender:sender];
    
}

@end

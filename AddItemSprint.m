//
//  AddItemSprint.m
//  ScrumRemote
//
//  Created by Glauco Primo on 02/04/14.
//
//

#import "AddItemSprint.h"

@interface AddItemSprint ()

@end

@implementation AddItemSprint{
    NSMutableArray *product_backlog_a;
    NSMutableArray *product_backlog_a_id;
}
@synthesize tableView;
@synthesize selected_item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service_a = [WebServiceRequest alloc];
        NSString *xmlData = [web_service_a getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-product-backlog.php?user=4&project=867&option=aceitas",url_basic]];
        int i = 0;
        product_backlog_a = [[NSMutableArray alloc] init];
        product_backlog_a_id = [[NSMutableArray alloc] init];
        while (TRUE) {
            NSString *projeto_info = [web_service_a getTagValue:@"historia" inText:xmlData inInitialRange:i];
            NSRange pos1 = [web_service_a last_initial_range];
            NSRange pos2 = [web_service_a last_final_range];
            if (pos1.location == NSNotFound) {
                break;
            }
            NSString *item_id = [web_service_a getTagValue:@"itbklg_id" inText:projeto_info inInitialRange:0];
            NSString *projeto_nome = [web_service_a getTagValue:@"itbklg_titulo" inText:projeto_info inInitialRange:0];
            
            [product_backlog_a addObject:projeto_nome];
            [product_backlog_a_id addObject:item_id];
            
            i = pos2.location + pos2.length;
            
        }
    }
    
    UIButton *bt_salvar = [[UIButton alloc] initWithFrame:CGRectMake(310, 550, 100, 50)];
    
    [bt_salvar.layer setCornerRadius:5.0f];
    [bt_salvar.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [bt_salvar.layer setBorderWidth:1.0f];
    
    [bt_salvar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [bt_salvar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt_salvar.backgroundColor = [UIColor colorWithRed:99/255.0f green:147/255.0f blue:184/255.0f alpha:1.0f];
    
    bt_salvar.layer.borderColor = [UIColor colorWithRed:99/255.0f green:147/255.0f blue:184/255.0f alpha:1.0f].CGColor;
    bt_salvar.layer.borderWidth = 0.5f;
    bt_salvar.layer.cornerRadius = 5.0f;
    
    
    [bt_salvar setTitle:@"Salvar" forState:UIControlStateNormal];
    [bt_salvar addTarget:self action:@selector(salvar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt_salvar];
    
    
    
    
    UIButton *bt_cancel = [[UIButton alloc] initWithFrame:CGRectMake(420, 550, 100, 50)];
    
    [bt_cancel.layer setCornerRadius:5.0f];
    [bt_cancel.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [bt_cancel.layer setBorderWidth:1.0f];
    
    [bt_cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [bt_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bt_cancel.backgroundColor = [UIColor colorWithRed:153/255.0f green:57/255.0f blue:20/255.0f alpha:1.0f];
    
    bt_cancel.layer.borderColor = [UIColor colorWithRed:153/255.0f green:57/255.0f blue:20/255.0f alpha:1.0f].CGColor;
    bt_cancel.layer.borderWidth = 0.5f;
    bt_cancel.layer.cornerRadius = 5.0f;
    
    
    
    [bt_cancel setTitle:@"Cancelar" forState:UIControlStateNormal];
    [bt_cancel addTarget:self action:@selector(cancelar:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bt_cancel];
}
-(void) cancelar:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) salvar:(id)sender{
    
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        
        NSString *query = [NSString stringWithFormat:@"%@/scrum_services/add-item-sprint.php?id=%@&proj_id=%@",url_basic, selected_item, logged_proj_padrao];
        
        NSString *data = [web_service getHTTPResponse:query];
        NSLog(@"%@",query);
        
        if (![data  isEqual: @""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalDismissed" object:nil userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [product_backlog_a count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:   (NSInteger)section
{
    return @"Histórias aprovadas";
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *projetoIdentifier = @"ibDetailsCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:projetoIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:projetoIdentifier];
    }
    
    cell.textLabel.text = [product_backlog_a objectAtIndex:indexPath.row];
    
    
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    selected_item = [product_backlog_a_id objectAtIndex:indexPath.row];
}

@end

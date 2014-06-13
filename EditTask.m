//
//  EditTask.m
//  ScrumRemote
//
//  Created by Glauco Primo on 10/04/14.
//
//

#import "EditTask.h"

@interface EditTask ()

@end

@implementation EditTask
@synthesize task_id;
@synthesize task_title;
@synthesize descricao;
@synthesize tipo;
@synthesize navbar;
@synthesize txt_task_title;
@synthesize txt_descricao;
@synthesize pck_tipo;

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

    

    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-task-summary.php?task_id=%d",url_basic,task_id]];
        NSLog(@"%@",xmlData);
        descricao = [web_service getTagValue:@"trfa_descricao" inText:xmlData inInitialRange:0];
        
        if ([[web_service getTagValue:@"trfa_impedimento" inText:xmlData inInitialRange:0]  isEqual: @"1"])
        {
            tipo = @"Impedimento";
        }
        else if ([[web_service getTagValue:@"trfa_bug" inText:xmlData inInitialRange:0]  isEqual: @"1"])
        {
            tipo = @"Bug";
        }
        else
        {
            tipo = @"Tarefa";
        }
     
     
     }
     else {
     
    /*db = [[DataBase alloc] init];
     
     NSMutableString* bundlePath = [NSMutableString stringWithCapacity:4];
     [bundlePath appendString:[[NSBundle mainBundle] bundlePath]];
     [bundlePath appendString:@"/scrumhalf.sql"];
     [db openDB:bundlePath];
     
     NSString *query = [NSString stringWithFormat:@"SELECT ta.trfa_titulo, ta.trfa_descricao FROM tarefa ta WHERE ta.trfa_id=%d",[[sender view] tag]];
     
     sqlite3_stmt *rs = [db openRS:query];
     while (sqlite3_step(rs) == SQLITE_ROW) {
     NSString *trfa_titulo = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 0)];
     NSString *trfa_descricao = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(rs, 1)];
     UIAlertView *tarefa_popup = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@",trfa_titulo] message:[NSString stringWithFormat:@"\n%@",trfa_descricao] delegate:self cancelButtonTitle:@"Fechar" otherButtonTitles: nil, nil];
     
     [tarefa_popup show];
     }*/
    
    
    
    
    }
    
    dataArray = [[NSMutableArray alloc] init];
    
    // Add some data for demo purposes.
    [dataArray addObject:@"Tarefa"];
    [dataArray addObject:@"Bug"];
    [dataArray addObject:@"Impedimento"];
    
	// Do any additional setup after loading the view.
    
    UILabel *lb_titulo = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 40)];
    [lb_titulo setText:@"Título"];
    txt_task_title = [[UITextField alloc] initWithFrame:CGRectMake(170, 140, 350, 40)];
    [txt_task_title setBorderStyle:UITextBorderStyleRoundedRect];
    [txt_task_title setText:task_title];
    [self.view addSubview:lb_titulo];
    [self.view addSubview:txt_task_title];
    
    
    UILabel *lb_descricao = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200, 50)];
    [lb_descricao setText:@"Descrição"];
    txt_descricao = [[UITextView alloc] initWithFrame:CGRectMake(170, 210, 350, 200)];
    [txt_descricao setFont:[UIFont systemFontOfSize:18]];
    [txt_descricao.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [txt_descricao.layer setBorderWidth:1];
    txt_descricao.layer.cornerRadius = 5;
    txt_descricao.clipsToBounds = YES;
    [txt_descricao setText:descricao];
    NSLog(@"%@",descricao);
    [self.view addSubview:txt_descricao];
    [self.view addSubview:lb_descricao];
    
    
    pck_tipo = [[UIPickerView alloc] initWithFrame:CGRectMake(310, 410, 210, 100)];
    [pck_tipo.layer setFrame:CGRectMake(310, 410, 210, 100)];
    pck_tipo.showsSelectionIndicator = YES;
    pck_tipo.delegate = self;
    
    NSLog(@"%@",tipo);
    
    if ([tipo  isEqual: @"Bug"])
    {
        [pck_tipo selectRow:1 inComponent:0 animated:YES];
    }
    else if ([tipo  isEqual: @"Impedimento"])
    {
        [pck_tipo selectRow:2 inComponent:0 animated:YES];
    }
    else
    {
        [pck_tipo selectRow:0 inComponent:0 animated:YES];
    }
    
    [self.view addSubview:pck_tipo];
    
    
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
    
    
    UIBarButtonItem *bt_delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTask:)];
    UINavigationItem *navitem = [[UINavigationItem alloc] initWithTitle:self.task_title];
    navitem.rightBarButtonItem = bt_delete;
    navitem.hidesBackButton = YES;
    [navbar pushNavigationItem:navitem animated:NO];
    
    
	// Do any additional setup after loading the view.
}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [dataArray count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [dataArray objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"You selected this: %@", [dataArray objectAtIndex: row]);
}

-(void) deleteTask:(id)sender{
    
    
        
        UIAlertView *delete_alert = [[UIAlertView alloc] initWithTitle:@"Exclusão de tarefa" message:@"Deseja excluir a tarefa?" delegate:self cancelButtonTitle:@"Não" otherButtonTitles: @"Sim", nil];
        [delete_alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"nao");
    }
    else {
        if ([WebServiceRequest isOnline]) {
            WebServiceRequest *web_service = [WebServiceRequest alloc];
            NSString *query = [NSString stringWithFormat:@"%@/scrum_services/delete-task.php?id=%d",url_basic,task_id];
            
            NSLog(@"%@",query);
            
            NSString *data = [web_service getHTTPResponse:query];
            
            if (![data  isEqual: @""]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalDismissed" object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
        
    }
}

-(void) salvar:(id)sender{
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];

        NSString *query = [NSString stringWithFormat:@"%@/scrum_services/update-task.php?id=%d&titulo=%@&descricao=%@&tipo=%@",url_basic,task_id,[[txt_task_title text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[txt_descricao text]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[self pickerView:pck_tipo titleForRow:[pck_tipo selectedRowInComponent:0] forComponent:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"%@",query);
        
        NSString *data = [web_service getHTTPResponse:query];
        
        if (![data  isEqual: @""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalDismissed" object:nil userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void) cancelar:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

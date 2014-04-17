//
//  AddTask.m
//  ScrumRemote
//
//  Created by Glauco Primo on 02/04/14.
//
//

#import "AddTask.h"

@interface AddTask ()

@end

@implementation AddTask
@synthesize item_id;
@synthesize item_title;
@synthesize txt_descricao;
@synthesize txt_titulo;
@synthesize tipo_tarefa;

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
    
    dataArray = [[NSMutableArray alloc] init];
    
    // Add some data for demo purposes.
    [dataArray addObject:@"Tarefa"];
    [dataArray addObject:@"Bug"];
    [dataArray addObject:@"Impedimento"];
    
	// Do any additional setup after loading the view.
    UILabel *lb_historia = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 200, 40)];
    [lb_historia setText:@"História"];
    
    UILabel *lb_historia_content = [[UILabel alloc] initWithFrame:CGRectMake(170, 80, 350, 40)];
    [lb_historia_content setText:self.item_title];
    
    [self.view addSubview:lb_historia];
    [self.view addSubview:lb_historia_content];
    
    UILabel *lb_titulo = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 40)];
    [lb_titulo setText:@"Título"];
    txt_titulo = [[UITextField alloc] initWithFrame:CGRectMake(170, 140, 350, 40)];
    [txt_titulo setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:lb_titulo];
    [self.view addSubview:txt_titulo];
    
    
    UILabel *lb_descricao = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 200, 50)];
    [lb_descricao setText:@"Descrição"];
    txt_descricao = [[UITextView alloc] initWithFrame:CGRectMake(170, 210, 350, 200)];
    [txt_descricao setFont:[UIFont systemFontOfSize:18]];
    [txt_descricao.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [txt_descricao.layer setBorderWidth:1];
    txt_descricao.layer.cornerRadius = 5;
    txt_descricao.clipsToBounds = YES;
    [self.view addSubview:txt_descricao];
    [self.view addSubview:lb_descricao];
    
    
    tipo_tarefa = [[UIPickerView alloc] initWithFrame:CGRectMake(310, 410, 210, 100)];
    [tipo_tarefa.layer setFrame:CGRectMake(310, 410, 210, 100)];
    tipo_tarefa.showsSelectionIndicator = YES;
    tipo_tarefa.delegate = self;
    [self.view addSubview:tipo_tarefa];
    
    
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

-(void) cancelar:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) salvar:(id)sender{
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        int bug = 0;
        int impedimento = 0;
        NSString *tipo = [self pickerView:tipo_tarefa titleForRow:[tipo_tarefa selectedRowInComponent:0] forComponent:0];
        if ([tipo  isEqual: @"Bug"]) {
            bug = 1;
        }
        else if ([tipo isEqual:@"Impedimento"]) {
            impedimento = 1;
        }
        
        NSString *query = [NSString stringWithFormat:@"%@/scrum_services/add-task.php?proj_id=%@&item_id=%@&titulo=%@&descricao=%@&bug=%d&imp=%d",url_basic,logged_proj_padrao, item_id, [[txt_titulo text]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[txt_descricao text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],bug,impedimento];
        
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

@end

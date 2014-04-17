//
//  addItemBacklog.m
//  ScrumRemote
//
//  Created by Glauco Primo on 02/04/14.
//
//

#import "addItemBacklog.h"

@interface addItemBacklog ()

@end

@implementation addItemBacklog
@synthesize txt_titulo;
@synthesize txt_descricao;
@synthesize txt_estimativa;

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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 600, 23)];
    label.textColor = [UIColor blackColor];
    label.text = @"Propor nova história";
    
    
    UILabel *lb_titulo = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 200, 40)];
    [lb_titulo setText:@"Título da história"];
    txt_titulo = [[UITextField alloc] initWithFrame:CGRectMake(170, 80, 350, 40)];
    [txt_titulo setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:lb_titulo];
    [self.view addSubview:txt_titulo];
    
    
    UILabel *lb_descricao = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 50)];
    [lb_descricao setText:@"Descrição"];
    txt_descricao = [[UITextView alloc] initWithFrame:CGRectMake(170, 150, 350, 200)];
    [txt_descricao setFont:[UIFont systemFontOfSize:18]];
    [txt_descricao.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [txt_descricao.layer setBorderWidth:1];
    txt_descricao.layer.cornerRadius = 5;
    txt_descricao.clipsToBounds = YES;
    [self.view addSubview:txt_descricao];
    [self.view addSubview:lb_descricao];
    
    
    UILabel *lb_estimativa = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, 200, 40)];
    [lb_estimativa setText:@"Estimativa"];
    txt_estimativa = [[UITextField alloc] initWithFrame:CGRectMake(170, 380, 100, 40)];
    [txt_estimativa setBorderStyle:UITextBorderStyleRoundedRect];
    [txt_estimativa setKeyboardType:UIKeyboardTypePhonePad];
    [txt_estimativa setKeyboardAppearance:UIKeyboardAppearanceDefault];
    [self.view addSubview:lb_estimativa];
    [self.view addSubview:txt_estimativa];
    
    
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

-(void) salvar:(id)sender{
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        
        
        NSString *query = [NSString stringWithFormat:@"%@/scrum_services/add-item-backlog.php?proj_id=%@&user_id=%@&titulo=%@&descricao=%@&estimativa=%@",url_basic, logged_proj_padrao,logged_user_id, [[txt_titulo text]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[txt_descricao text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[txt_estimativa text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *data = [web_service getHTTPResponse:query];
        NSLog(@"%@",query);
        
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

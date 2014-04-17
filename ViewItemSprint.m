//
//  ViewItemSprint.m
//  ScrumRemote
//
//  Created by Glauco Primo on 11/04/14.
//
//

#import "ViewItemSprint.h"

@interface ViewItemSprint ()

@end

@implementation ViewItemSprint
@synthesize item_id;
@synthesize item_title;
@synthesize descricao;
@synthesize autor;
@synthesize estimativa;
@synthesize navbar;

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
        NSString *xmlData = [web_service getHTTPResponse:[NSString stringWithFormat:@"%@/scrum_services/get-papel.php?user=%@&project=%@",url_basic,logged_user_id,logged_proj_padrao]];
        
        
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
    }
    
	// Do any additional setup after loading the view.
    
    
    navbar.topItem.title = item_title;
    
    UILabel *lb_titulo = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 200, 40)];
    [lb_titulo setText:@"Título"];
    UITextField *txt_titulo = [[UITextField alloc] initWithFrame:CGRectMake(170, 80, 350, 40)];
    [txt_titulo setBorderStyle:UITextBorderStyleRoundedRect];
    [txt_titulo setUserInteractionEnabled:NO];
    [txt_titulo setText:item_title];
    [self.view addSubview:lb_titulo];
    [self.view addSubview:txt_titulo];
    
    
    UILabel *lb_descricao = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 200, 50)];
    [lb_descricao setText:@"Descrição"];
    UITextView *txt_descricao = [[UITextView alloc] initWithFrame:CGRectMake(170, 150, 350, 200)];
    [txt_descricao setFont:[UIFont systemFontOfSize:18]];
    txt_descricao.editable = NO;
    [txt_descricao setText:descricao];
    [txt_descricao.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [txt_descricao.layer setBorderWidth:1];
    txt_descricao.layer.cornerRadius = 5;
    txt_descricao.clipsToBounds = YES;
    [self.view addSubview:txt_descricao];
    [self.view addSubview:lb_descricao];
    
    
    UILabel *lb_estimativa = [[UILabel alloc] initWithFrame:CGRectMake(20, 380, 200, 40)];
    [lb_estimativa setText:@"Estimativa"];
    UITextField *txt_estimativa = [[UITextField alloc] initWithFrame:CGRectMake(170, 380, 100, 40)];
    [txt_estimativa setText:estimativa];
    [txt_estimativa setBorderStyle:UITextBorderStyleRoundedRect];
    [txt_estimativa setUserInteractionEnabled:NO];
    [txt_estimativa setKeyboardType:UIKeyboardTypePhonePad];
    [txt_estimativa setKeyboardAppearance:UIKeyboardAppearanceDefault];
    [self.view addSubview:lb_estimativa];
    [self.view addSubview:txt_estimativa];
    
    UILabel *lb_autor = [[UILabel alloc] initWithFrame:CGRectMake(20, 440, 200, 40)];
    [lb_autor setText:@"Autor"];
    UITextField *txt_autor = [[UITextField alloc] initWithFrame:CGRectMake(170, 440, 100, 40)];
    [txt_autor setBorderStyle:UITextBorderStyleRoundedRect];
    [txt_autor setUserInteractionEnabled:NO];
    [self.view addSubview:lb_autor];
    [self.view addSubview:txt_autor];
    
    
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
    if (is_po) {
        UIBarButtonItem *bt_delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteItem:)];
        UINavigationItem *navitem = [[UINavigationItem alloc] initWithTitle:self.item_title];
        navitem.rightBarButtonItem = bt_delete;
        navitem.hidesBackButton = YES;
        [navbar pushNavigationItem:navitem animated:NO];
    }
    
}

-(void) cancelar:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) deleteItem:(id)sender{
    //colocar uma confirmaçao antes disso
    if ([WebServiceRequest isOnline]) {
        WebServiceRequest *web_service = [WebServiceRequest alloc];
        
        NSString *query = [NSString stringWithFormat:@"%@/scrum_services/delete-item-sprint.php?id=%@",url_basic,item_id];
        
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

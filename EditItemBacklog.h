//
//  EditItemBacklog.h
//  ScrumRemote
//
//  Created by Glauco Primo on 03/04/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"

@interface EditItemBacklog : UIViewController{
    BOOL is_po;
}
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic) int item_id;
@property (nonatomic) char tipo;
@property (nonatomic, strong) NSString *item_title;
@property (nonatomic, strong) NSString *descricao;
@property (nonatomic, strong) NSString *autor;
@property (nonatomic, strong) NSString *estimativa;

@property (nonatomic, strong) UITextField *txt_titulo;
@property (nonatomic, strong) UITextView *txt_descricao;
@property (nonatomic, strong) UITextField *txt_estimativa;
@property (nonatomic, strong) UISwitch *sw_proposto_aceito;

@property (nonatomic, strong) IBOutlet UINavigationBar *navbar;

@end

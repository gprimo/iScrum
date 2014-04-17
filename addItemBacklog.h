//
//  addItemBacklog.h
//  ScrumRemote
//
//  Created by Glauco Primo on 02/04/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"

@interface addItemBacklog : UIViewController

@property (nonatomic, strong) UITextField *txt_titulo;
@property (nonatomic, strong) UITextView *txt_descricao;
@property (nonatomic, strong) UITextField *txt_estimativa;

@end

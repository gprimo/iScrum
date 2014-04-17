//
//  AddTask.h
//  ScrumRemote
//
//  Created by Glauco Primo on 02/04/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"

@interface AddTask : UIViewController<UIPickerViewDelegate>
{
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) NSString *item_title;
@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) UITextField *txt_titulo;
@property (nonatomic, strong) UITextView *txt_descricao;
@property (nonatomic, strong) UIPickerView *tipo_tarefa;
@end

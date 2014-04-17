//
//  ViewItemSprint.h
//  ScrumRemote
//
//  Created by Glauco Primo on 11/04/14.
//
//

#import <UIKit/UIKit.h>
#import "WebServiceRequest.h"

@interface ViewItemSprint : UIViewController{
    BOOL is_po;
}

@property (nonatomic, strong) NSString *item_id;
@property (nonatomic, strong) NSString *item_title;
@property (nonatomic, strong) NSString *descricao;
@property (nonatomic, strong) NSString *autor;
@property (nonatomic, strong) NSString *estimativa;

@property (nonatomic, strong) IBOutlet UINavigationBar *navbar;

@end

//
//  WebServiceRequest.h
//  ScrumRemote
//
//  Created by Glauco Primo on 10/02/14.
//
//

#import <Foundation/Foundation.h>

@interface WebServiceRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;

}

extern NSString *const url_basic;
extern NSString * logged_user_id;
extern NSString * logged_proj_padrao;
@property (nonatomic) NSError *last_error;
@property (nonatomic) NSRange last_initial_range;
@property (nonatomic) NSRange last_final_range;


+(BOOL) isOnline;


-(NSString *) getHTTPResponse: (NSString *) url;
-(NSString *) getTagValue: (NSString *) tag inText: (NSString *) xmlData inInitialRange: (int) i;
-(NSError *) last_error;
-(NSRange) last_initial_range;
-(NSRange) last_final_range;
@end

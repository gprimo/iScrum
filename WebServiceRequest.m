//
//  WebServiceRequest.m
//  ScrumRemote
//
//  Created by Glauco Primo on 10/02/14.
//
//

#import "WebServiceRequest.h"

@implementation WebServiceRequest

@synthesize last_error;
@synthesize last_final_range;
@synthesize last_initial_range;

NSString * const url_basic = @"http://amrtec.no-ip.biz:1888";
NSString * logged_user_id;
NSString * logged_proj_padrao;
NSString * logged_user_sigla;

+(BOOL) isOnline
{
    NSError *error=nil;
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:url_basic] encoding:NSASCIIStringEncoding error:&error];
    return ( URLString != NULL ) ? YES : NO;
}

-(NSString *) getHTTPResponse:(NSString *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse: &response error:&error];
    NSString *xmlData = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
    last_error = error;
    return xmlData;
}



-(NSString *) getTagValue:(NSString *)tag inText:(NSString *)xmlData inInitialRange:(int)i{
    NSRange pos1;
    NSRange pos2;
    NSString *info;

    pos1 = [xmlData rangeOfString:[NSString stringWithFormat:@"<%@>",tag] options:NSCaseInsensitiveSearch range:NSMakeRange(i, [xmlData length] - i)];
    last_initial_range = pos1;
    if (pos1.location == NSNotFound)
        return @"";
    
    pos2 = [xmlData rangeOfString:[NSString stringWithFormat:@"</%@>",tag] options:NSCaseInsensitiveSearch range:NSMakeRange(i, [xmlData length] - i)];
    last_final_range = pos2;
    
    info = [xmlData substringWithRange:NSMakeRange(pos1.length + pos1.location, pos2.location - pos1.length - pos1.location)];
    [info UTF8String];
    return info;
}

@end

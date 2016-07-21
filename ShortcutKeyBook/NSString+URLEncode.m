

#import "NSString+URLEncode.h"

@implementation NSString (URLEncode)

+ (NSString *)encodeURIComponent:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding
{
    if ([aURIString length] == 0) {
        return @"";
    }
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                (__bridge CFStringRef)aURIString,
                                                                                CFSTR("-_.!~*'()"),
                                                                                CFSTR(";/?:@&=+$,#"),
                                                                                CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
}

+ (NSString *)decodeURIComponent:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding
{
    if ([aURIString length] == 0) {
        return @"";
    }
    return (NSString*)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                (__bridge CFStringRef)aURIString,
                                                                                                CFSTR(""),
                                                                                                CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
}

+ (NSString *)encodeURI:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding
{
    if ([aURIString length] == 0) {
        return @"";
    }
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                (__bridge CFStringRef)aURIString,
                                                                                CFSTR("-_.!~*'();/?:@&=+$,#"),
                                                                                CFSTR(""),
                                                                                CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
}

+ (NSString *)decodeURI:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding
{
    if ([aURIString length] == 0) {
        return @"";
    }
    return (NSString*)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                (__bridge CFStringRef)aURIString,
                                                                                                CFSTR(""),
                                                                                                CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
}

- (NSString *)stringByEncodingURIComponent
{
    return [NSString encodeURIComponent:self stringEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringByDecodingURIComponent
{
    return [NSString decodeURIComponent:self stringEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringByEncodingURI
{
    return [NSString encodeURI:self stringEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringByDecodingURI
{
    return [NSString decodeURI:self stringEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringByEncodingURIPath
{
    if ([self length] == 0) {
        return @"";
    }
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                (__bridge CFStringRef)self,
                                                                                CFSTR("-_.!~*'()"),
                                                                                CFSTR(";?:@&=+$,#"),
                                                                                CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
}

@end

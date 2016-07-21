

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)

/**
 * @brief 把字符串编码为 URI 组件
 *
 * @param aURIString        一个字符串，含有 URI 组件或其他要编码的文本
 * @param stringEncoding    字符集编码
 *
 * @return aURIString 的副本，其中的某些字符将被十六进制的转义序列进行替换
 *
 * @discussion 该方法不会对 ASCII 字母和数字进行编码，也不会对这些 ASCII 标点符号进行编码： - _ . ! ~ * ' ( ) 。
 * 其他字符（比如 ：;/?:@&=+$,# 这些用于分隔 URI 组件的标点符号），都是由一个或多个十六进制的转义序列替换的。
 *
 * @note 请注意 \c encodeURIComponent() 函数 与 \c encodeURI() 函数的区别之处，前者假定它的参数是 URI 的一部分
 * （比如协议、主机名、路径或查询字符串）。因此 \c encodeURIComponent() 函数将转义用于分隔 URI 各个部分的标点符号。
 *
 */
+ (NSString *)encodeURIComponent:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding;

/**
 * @brief 解码一个编码的 URI 组件
 *
 * @param aURIString        一个字符串，含有编码 URI 组件或其他要解码的文本
 * @param stringEncoding    字符集编码
 *
 * @return aURIString 的副本，其中的十六进制转义序列将被它们表示的字符替换
 */
+ (NSString *)decodeURIComponent:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding;

/**
 * @brief 把字符串编码为 URI
 *
 * @param aURIString        一个字符串，含有 URI 或其他要编码的文本
 * @param stringEncoding    字符集编码
 *
 * @return aURIString 的副本，其中的某些字符将被十六进制的转义序列进行替换
 *
 * @discussion 该方法不会对 ASCII 字母和数字进行编码，也不会对这些 ASCII 标点符号进行编码： - _ . ! ~ * ' ( ) 。
 * 该方法的目的是对 URI 进行完整的编码，因此对以下在 URI 中具有特殊含义的 ASCII 标点符号，\c encodeURI() 函数
 * 是不会进行转义的：;/?:@&=+$,#
 *
 * @note 如果 URI 组件中含有分隔符，比如 ? 和 #，则应当使用 \c encodeURIComponent() 方法分别对各组件进行编码。
 *
 */
+ (NSString *)encodeURI:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding;

/**
 * @brief 解码一个编码的 URI
 *
 * @param aURIString        一个字符串，含有编码 URI 或其他要解码的文本
 * @param stringEncoding    字符集编码
 *
 * @return aURIString 的副本，其中的十六进制转义序列将被它们表示的字符替换
 */
+ (NSString *)decodeURI:(NSString *)aURIString stringEncoding:(NSStringEncoding)stringEncoding;

/**
 * @brief 把字符串编码为 URI 组件
 */
- (NSString *)stringByEncodingURIComponent;

/**
 * @brief 解码一个编码的 URI 组件
 */
- (NSString *)stringByDecodingURIComponent;

/**
 * @brief 把字符串编码为 URI
 */
- (NSString *)stringByEncodingURI;

/**
 * @brief 解码一个编码的 URI
 */
- (NSString *)stringByDecodingURI;

/**
 * @brief 把字符串编码为 URI 路径
 *
 * @discussion 该方法不会对 “/” 编码，其他编码规则同 -stringByEncodingURIComponent ; 解码用 -stringByDecodingURI 方法即可。
 */
- (NSString *)stringByEncodingURIPath;

@end

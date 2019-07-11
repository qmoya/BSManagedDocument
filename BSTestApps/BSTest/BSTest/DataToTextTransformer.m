#import "DataToTextTransformer.h"

@implementation DataToTextTransformer

+ (Class)transformedValueClass {
    return [NSString class] ;
}

+ (BOOL)allowsReverseTransformation {
    return NO ;
}

- (id)transformedValue:(id)data {
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    [string autorelease];
#endif

    if (!string) {
        string = @"Data in this file cannot be decoded as UTF8";
    }

    return string;
}

@end

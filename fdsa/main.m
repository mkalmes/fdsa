#import <Foundation/Foundation.h>

// clang -g -fobjc-arc -Wall -framework Foundation -o nonnull-warning nonnull-warning.m
// clang -g -fobjc-arc -Wall -Wnullable-to-nonnull-conversion -framework Foundation -o nonnull-warning nonnull-warning.m

@interface Demo : NSObject
@end

@implementation Demo

+ (void)shizzleFrizzle:(NSString * _Nonnull)drizzle {
    NSAssert(drizzle != nil, @"drizzle can not be nil");
    NSArray *foo = @[ drizzle ];
    NSLog(@"%@", foo);
}

int main (int args, char *argv[]) {

    [Demo shizzleFrizzle:nil]; // Generates a warning.

    NSString *nilString;
    [Demo shizzleFrizzle:nilString]; // Doesn't generate a warning.

    NSString *explicitNilString = nil;
    [Demo shizzleFrizzle:explicitNilString]; // Doesn't generate a warning, either.

    NSString * _Nullable foo = nil;
    [Demo shizzleFrizzle:foo]; // Does generate a warning w/ -Wnullable-to-nonnull-conversion

    NSString *bar = foo;
    [Demo shizzleFrizzle:bar]; // Should generate a warning but doesn't.

    return 0;
}

@end

#ifdef OUTPUT
> clang -g -fobjc-arc -Wall -framework Foundation -o nonnull-warning nonnull-warning.m
nonnull-warning.m:17:11: warning: null passed to a callee that requires a
non-null argument [-Wnonnull]
[Demo shizzleFrizzle:nil]; // Generates a warning.
^              ~~~
1 warning generated.
> clang -E nonnull-warning.m
[...]
int main (int args, char *argv[]) {

    [Demo shizzleFrizzle:((void *)0)];

    NSString *nilString;
    [Demo shizzleFrizzle:nilString];

    NSString *explicitNilString = ((void *)0);
    [Demo shizzleFrizzle:explicitNilString];

    return 0;
}
#endif

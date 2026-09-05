#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "matter" asset catalog image resource.
static NSString * const ACImageNameMatter AC_SWIFT_PRIVATE = @"matter";

#undef AC_SWIFT_PRIVATE

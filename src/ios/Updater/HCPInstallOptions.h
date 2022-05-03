//
//  HCPFetchUpdateOptions.h
//
//  Created by Nikolay Demyankov on 24.05.16.
//

#import <Foundation/Foundation.h>

/**
 *  Model for fetch update options.
 */
@interface HCPInstallOptions : NSObject

/**
 *  Reload bool
 */
@property (nonatomic) BOOL reload;

/**
 *  Constructor.
 *  Used internally in the plugin.
 *
 *  @param dictionary dictionary with options from the JS side
 *
 *  @return object instance
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

//
//  SSConcurrentOperation.h
//  Astronomy
//
//  Created by Shawn Gee on 5/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SSConcurrentOperationState) {
    SSConcurrentOperationStateReady,
    SSConcurrentOperationStateExecuting,
    SSConcurrentOperationStateFinished
};

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ConcurrentOperation)
@interface SSConcurrentOperation : NSOperation

- (void)finish;

@end

NS_ASSUME_NONNULL_END

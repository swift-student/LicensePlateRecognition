//
//  SSConcurrentOperation.m
//  Astronomy
//
//  Created by Shawn Gee on 5/19/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

#import "SSConcurrentOperation.h"

@interface SSConcurrentOperation ()

@property (nonatomic) SSConcurrentOperationState state;

- (NSString *)keyForState:(SSConcurrentOperationState)state;

@end

@implementation SSConcurrentOperation

- (BOOL)isReady {
    return super.isReady && self.state == SSConcurrentOperationStateReady;
}

- (BOOL)isExecuting {
    return self.state == SSConcurrentOperationStateExecuting;
}

- (BOOL)isFinished {
    return self.state == SSConcurrentOperationStateFinished;
}

- (BOOL)isAsynchronous {
    return true;
}

@synthesize state = _state;

- (SSConcurrentOperationState)state {
    // lazy var
    if (!_state) {
        _state = SSConcurrentOperationStateReady;
    }
    
    return _state;
}

- (void)setState:(SSConcurrentOperationState)state {
    // Make sure we are changing the state
    if (state == _state) { return; }
    
    // Get the corresponding keys
    NSString *oldKey = [self keyForState:_state];
    NSString *newKey = [self keyForState:state];
 
    // willSet
    [self willChangeValueForKey:oldKey];
    [self willChangeValueForKey:newKey];
    
    // set
    _state = state;
    
    // didSet
    [self didChangeValueForKey:oldKey];
    [self didChangeValueForKey:newKey];
}

- (NSString *)keyForState:(SSConcurrentOperationState)state {
    switch (state) {
        case SSConcurrentOperationStateReady:
            return @"ready";
            break;
        case SSConcurrentOperationStateExecuting:
            return @"executing";
            break;
        case SSConcurrentOperationStateFinished:
            return @"finished";
            break;
        default:
            break;
    }
    return nil;
}

- (void)start {
    if (self.isCancelled) {
        [self finish];
        return;
    }
    
    if (!self.isExecuting) {
        self.state = SSConcurrentOperationStateExecuting;
    }
    
    [self main];
}

- (void)finish {
    if (self.isExecuting) {
        self.state = SSConcurrentOperationStateFinished;
    }
}

- (void)cancel {
    [super cancel];
    [self finish];
}


@end

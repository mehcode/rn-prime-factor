#import "RNPrimeFactor.h"
#include <stdint.h>
#include <string.h>
#include "pf.h"

@implementation RNPrimeFactor

RCT_REMAP_METHOD(findFactors,
                 pqHexStr:(NSString *)pqHexStr
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    uint64_t pq = (uint64_t)strtoull([pqHexStr UTF8String], NULL, 16);
    uint32_t p = factorizeValue(pq);
    
    uint32_t q = pq / p;
    
    if (p > q) {
        uint32_t tmp = p;
        p = q;
        q = tmp;
    }
    
    NSString *pHex = [NSString stringWithFormat:@"%lX",
                     (unsigned long)p];
    
    NSString *qHex = [NSString stringWithFormat:@"%lX",
                      (unsigned long)q];
    
    resolve(@[pHex, qHex]);
}

@end

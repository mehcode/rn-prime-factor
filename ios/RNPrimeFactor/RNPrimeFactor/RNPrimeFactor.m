#import "RNPrimeFactor.h"
#include <stdint.h>
#include <string.h>


#include <stdint.h>
#include <stdint.h>
#include <stdlib.h>

static uint64_t gcd(uint64_t a, uint64_t b) {
    while (a != 0 && b != 0) {
        while ((b & 1) == 0) {
            b >>= 1;
        }
        while ((a & 1) == 0) {
            a >>= 1;
        }
        if (a > b) {
            a -= b;
        } else {
            b -= a;
        }
    }
    return b == 0 ? a : b;
}

static uint32_t factorizeValue(uint64_t what) {
    int32_t it = 0, i, j;
    uint64_t g = 0;
    for (i = 0; i < 3 || it < 1000; i++) {
        uint64_t t = ((lrand48() & 15) + 17) % what;
        uint64_t x = (uint64_t) lrand48() % (what - 1) + 1, y = x;
        int32_t lim = 1 << (i + 18);
        for (j = 1; j < lim; j++) {
            ++it;
            uint64_t a = x, b = x, c = t;
            while (b) {
                if (b & 1) {
                    c += a;
                    if (c >= what) {
                        c -= what;
                    }
                }
                a += a;
                if (a >= what) {
                    a -= what;
                }
                b >>= 1;
            }
            x = c;
            uint64_t z = x < y ? what + x - y : x - y;
            g = gcd(z, what);
            if (g != 1) {
                break;
            }
            if (!(j & (j - 1))) {
                y = x;
            }
        }
        if (g > 1 && g < what) {
            break;
        }
    }
    
    return g;
}



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

RCT_EXPORT_MODULE();

@end

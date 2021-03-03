//
//  common.h
//  Runner
//
//  Created by W E on 2020/8/18.
//

#ifndef common_h
#define common_h

static FlutterError *getFlutterError(NSError *error) {
  return [FlutterError errorWithCode:[NSString stringWithFormat:@"Error %d", (int)error.code]
                             message:error.localizedDescription
                             details:error.domain];
}



// Mirrors ResolutionPreset in camera.dart
typedef enum {
  veryLow,
  low,
  medium,
  high,
  veryHigh,
  ultraHigh,
  max,
} ResolutionPreset;

static ResolutionPreset getResolutionPresetForString(NSString *preset) {
  if ([preset isEqualToString:@"veryLow"]) {
    return veryLow;
  } else if ([preset isEqualToString:@"low"]) {
    return low;
  } else if ([preset isEqualToString:@"medium"]) {
    return medium;
  } else if ([preset isEqualToString:@"high"]) {
    return high;
  } else if ([preset isEqualToString:@"veryHigh"]) {
    return veryHigh;
  } else if ([preset isEqualToString:@"ultraHigh"]) {
    return ultraHigh;
  } else if ([preset isEqualToString:@"max"]) {
    return max;
  } else {
    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:NSURLErrorUnknown
                                     userInfo:@{
                                       NSLocalizedDescriptionKey : [NSString
                                           stringWithFormat:@"Unknown resolution preset %@", preset]
                                     }];
    @throw error;
  }
}

#endif /* common_h */

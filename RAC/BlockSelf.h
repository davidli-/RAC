//
//  BlockSelf.h
//  RAC
//
//  Created by Macmafia on 2019/1/17.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#ifndef BlockSelf_h
#define BlockSelf_h

#define weakSelf() __weak typeof(self) weakSelf = self;
#define strongSelf() __strong typeof(weakSelf) strongSelf = weakSelf;

#endif /* BlockSelf_h */

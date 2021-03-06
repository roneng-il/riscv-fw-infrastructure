/* 
* SPDX-License-Identifier: Apache-2.0
* Copyright 2019 Western Digital Corporation or its affiliates.
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
* http:*www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
/**
* @file   comrv.h
* @author Ronen Haen
* @date   11.06.2019
* @brief  The defines COM-RV private interfaces
* 
*/
#ifndef  __COMRV_H__
#define  __COMRV_H__

/**
* include files
*/

/**
* definitions
*/

/**
* macros
*/
#define M_COMRV_ENTER_CRITICAL_SECTION()
#define M_COMRV_EXIT_CRITICAL_SECTION()
/* __builtin_expect instruction provides branch
   prediction information. The condition parameter is the expected
   comparison value. If it is equal to 1 (true), the condition
   is likely to be true, in other case condition is likely to be false.
   this provides us a way to take rare cases out of the critical execution path */
// TODO: use our psp
#define _BUILTIN_EXPECT(condition, expected)  __builtin_expect(condition, expected)

/**
* types
*/

/**
* local prototypes
*/

/**
* external prototypes
*/

/**
* global variables
*/

#endif /* __COMRV_H__ */

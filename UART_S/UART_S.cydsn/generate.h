/* ========================================
 *
 * Copyright YOUR COMPANY, THE YEAR
 * All Rights Reserved
 * UNPUBLISHED, LICENSED SOFTWARE.
 *
 * CONFIDENTIAL AND PROPRIETARY INFORMATION
 * WHICH IS THE PROPERTY OF your company.
 *
 * ========================================
*/

#ifndef GENERATE_H
#define GENERATE_H

#include <boost/preprocessor.hpp>

#define COM_GET_COM(com, func, arg) com
#define COM_GET_FUNC(com, func, arg) func
#define COM_GET_ARG(com, func, arg) arg

#define COM_NAME(com, func, n) (BOOST_PP_CAT(com, BOOST_PP_CAT(_, BOOST_PP_CAT(n, BOOST_PP_CAT(_, func)))))

#define COM_REP(z, n, d) COM_NAME(COM_GET_COM d, COM_GET_FUNC d, n) COM_GET_ARG d;
#define COM_REPEAT(n, com, func, ret, arg) BOOST_PP_REPEAT(n, ret COM_REP, (com, func, arg))

#define COM_REP_ARG(z, n, d) COM_NAME(COM_GET_COM d, COM_GET_FUNC d, n) COM_GET_ARG d (COM_GET_COM d, COM_GET_FUNC d, n)
#define COM_REPEAT_ARG(n, com, func, ret, arg) BOOST_PP_REPEAT(n, ret COM_REP_ARG, (com, func, arg))
	
#endif // GENERATE_H

/* [] END OF FILE */

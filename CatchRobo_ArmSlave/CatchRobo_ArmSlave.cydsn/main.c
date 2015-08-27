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
#include <project.h>
#include <stdio.h>

int main()
{
    uint8 str[20];
    uint8 result;
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    Debug_Start();
    LIN_Start();
    for(;;)
    {
        if(l_flg_tst_motor_frame() == 1)
		{
            result = (uint8)l_u8_rd_motor();
        }
        /*デバック*/
        sprintf(str,"helloworld = %d\n",(int)result);
        Debug_PutString(str);
    }
}

/* [] END OF FILE */

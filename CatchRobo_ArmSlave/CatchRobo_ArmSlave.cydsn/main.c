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

enum machine_state
{
    default_state,
    first_state,
    second_state,
    end_state
};

int main()
{
    uint8 str[20];
    uint8 ReceiveData;
    uint8 debug_val1;
    enum machine_state motor_state;
    uint8 status;
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    Debug_Start();
    LIN_Start();
    
    /*デバッグ*/
    sprintf(str,"program start\n");
    Debug_PutString(str);
    
    for(;;)
    {
        if(l_flg_tst_motor_frame() == 1)
		{
            ReceiveData = (uint8)l_u8_rd_motor();
        }
        
        /*motor_state*/
        if(ReceiveData == default_state){
            status = default_state;
        }else if(ReceiveData == first_state){
            status = first_state;
        }else if(ReceiveData == second_state){
            status = second_state;
        }else{
        
        }
        
        /*デバッグ*/
        if(debug_val1 != status){
            debug_val1 = status;
            sprintf(str,"status = %d\n",(int)status);
            Debug_PutString(str);
        }
    }
}

/* [] END OF FILE */

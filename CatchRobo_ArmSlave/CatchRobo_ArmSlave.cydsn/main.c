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
    stop_state,
    up_state,
    down_state,
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
    MOTOR_Start();
    ENABLE_Write(1);
    
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
        if(ReceiveData == stop_state){
            MOTOR_WriteCompare1(0);
            MOTOR_WriteCompare2(0);
        }else if(ReceiveData == up_state){
            if(UP_LIMIT_Read() == 0){
                MOTOR_WriteCompare1(50);
                MOTOR_WriteCompare2(0);
            }else{
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(0);            
            }
        }else if(ReceiveData == down_state){
            if(DOWN_LIMIT_Read() == 0){
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(50);
            }else{
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(0);            
            }
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

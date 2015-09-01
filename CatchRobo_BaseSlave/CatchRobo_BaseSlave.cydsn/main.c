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

void LINSlaveInit()
{
    if(0u != l_sys_init())
    {
        CyHalt(0x00);
    }
    
    if(0u != l_ifc_init(LIN_IFC_HANDLE))
    {
        CyHalt(0x00);
    }
}

int main()
{
//    uint8 str[20];
    uint8 ReceiveData;
    uint8 ArmData;
//    uint8 debug_val1;
//    uint8 status;
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    LINSlaveInit();
    MOTOR_Start();
    ENABLE_Write(1);
    

    for(;;)
    {
        if(l_flg_tst_motor_frame() == 1)
		{
            ReceiveData = (uint8)l_u8_rd_Base();
            l_flg_clr_motor_frame();
        }
        
        /*motor_state*/
        if(ReceiveData == 1){
            if(UP_LIMIT_Read() == 0){
                MOTOR_WriteCompare1(80);
                MOTOR_WriteCompare2(0);
            }else{
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(0);            
            }
        }
        else if(ReceiveData == 2){
            if(DOWN_LIMIT_Read() == 0){
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(80);
            }else{
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(0);            
            }
        }
        else{
            MOTOR_WriteCompare1(0);
            MOTOR_WriteCompare2(0);
        }
    }
}

/* [] END OF FILE */

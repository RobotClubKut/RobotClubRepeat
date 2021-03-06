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

#define arm_go_up  0x01
#define arm_go_down 0x02

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
//    uint8 BaseData;
//    uint8 debug_val1;
//    uint8 status;
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    Debug_Start();
    LINSlaveInit();
    MOTOR_Start();
    ENABLE_Write(1);
    
    //move to the initial position
    while(UP_LIMIT_Read() == 0){
        MOTOR_WriteCompare1(100);
        MOTOR_WriteCompare2(0);
    }
    MOTOR_WriteCompare1(0);
    MOTOR_WriteCompare2(0);
    
    
    for(;;)
    {
        if(l_flg_tst_motor_frame() == 1)
		{
            ReceiveData = (uint8)l_u8_rd_Arm();
            l_flg_clr_motor_frame();
        }
        
        /*motor_state*/
        if(ReceiveData == arm_go_up){
            if(UP_LIMIT_Read() == 0){
                MOTOR_WriteCompare1(200);
                MOTOR_WriteCompare2(0);
            }
            else{
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(0);            
            }
        }
        else if(ReceiveData == arm_go_down){
            if(DOWN_LIMIT_Read() == 0){
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(200);
            }
            else{
                MOTOR_WriteCompare1(0);
                MOTOR_WriteCompare2(0);            
            }
        }
        else{
            MOTOR_WriteCompare1(0);
            MOTOR_WriteCompare2(0);
        }
        
        /*デバッグ*/
        /*
        sprintf(str,"UP = %d\n",(int)UP_LIMIT_Read());
        Debug_PutString(str);
        */
    }
}

/* [] END OF FILE */

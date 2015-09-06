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

#define back_position 0
#define mid_position 1
#define front_position 2

#define base_go_front 1
#define base_go_back 2
#define base_go_mid 4

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

void MotorStop()
{
    MOTOR_WriteCompare1(0);
    MOTOR_WriteCompare2(0); 
}

void MotorFront()
{
    MOTOR_WriteCompare1(0);
    MOTOR_WriteCompare2(200);
}

void MotorBack()
{
    MOTOR_WriteCompare1(200);
    MOTOR_WriteCompare2(0);
}

int main()
{
//    uint8 str[23];
    uint8 ReceiveData;
    CYBIT MIDPOINT;
    uint8 position;
    CyGlobalIntEnable; /* Enable global interrupts. */

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */
    LINSlaveInit();
    MOTOR_Start();
    ENABLE_Write(1);
//    Debug_Start();
    Comp_Start();
    
    //move to the initial position
    while(BACK_LIMIT_Read() == 0){
        MotorBack();
    }
    MotorStop();
    position = back_position;

    for(;;)
    {
        if(l_flg_tst_motor_frame() == 1)
		{
            ReceiveData = (uint8)l_u8_rd_Base();
            l_flg_clr_motor_frame();
        }
        
        
        MIDPOINT = Comp_GetCompare();
        
        if(position == back_position){
            if(ReceiveData == base_go_front){
                while(FRONT_LIMIT_Read() == 0){
                    MotorFront();
//                    sprintf(str,"point1\n");
//                    Debug_PutString(str);
                }
                MotorStop();
                position = front_position;
            }
            if(ReceiveData == base_go_mid){
                while(MIDPOINT == 1){
                    MIDPOINT = Comp_GetCompare();
                    MotorFront();
//                    sprintf(str,"point2\n");
//                    Debug_PutString(str);
                }
                MotorStop();
                position = mid_position;
            }
        }
        
        if(position == mid_position){
            if(ReceiveData == base_go_front){
                while(FRONT_LIMIT_Read() == 0){
                    MotorFront();
//                    sprintf(str,"point3\n");
//                    Debug_PutString(str);
                }
                MotorStop();
                position = front_position;
            }
            if(ReceiveData == base_go_back){
                while(BACK_LIMIT_Read() == 0){
                    MotorBack();
//                    sprintf(str,"point4\n");
//                    Debug_PutString(str);
                }
                MotorStop();
                position = back_position;
            }
        }
        
        
        if(position == front_position){
            if(ReceiveData == base_go_mid){
                while(MIDPOINT == 1){
                    MIDPOINT = Comp_GetCompare();
                    MotorBack();
//                    sprintf(str,"point5\n");
//                    Debug_PutString(str);
                }
                MotorStop();
                position = mid_position;
            }
            if(ReceiveData == base_go_back){
                while(BACK_LIMIT_Read() == 0){
                    MotorBack();
//                    sprintf(str,"point6\n");
//                    Debug_PutString(str);
                }
                MotorStop();
                position = back_position;
            }
        }
        
//        sprintf(str,"position = %d data = %d\n",(int) position,(int) ReceiveData);
//        Debug_PutString(str);
        
    }
}

/* [] END OF FILE */

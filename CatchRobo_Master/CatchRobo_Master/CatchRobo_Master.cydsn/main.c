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
#include "ps2_controller.h"
#include "lin_master.h"

#define Open 0x01
#define Close 0x02

#define arm_stop 0x00
#define arm_up  0x01
#define arm_down 0x02
#define base_stop 0x00
#define base_front 0x10
#define base_back 0x20

int main()
{
    PS2Controller psData;
    char str[20];
    uint8 L1,L2,UP,DOWN;
    uint8 arm_stop_flag = 0;
    uint8 base_stop_flag = 0;
    uint8 PutData[6] = {arm_stop,arm_up,arm_down,base_stop,base_front,base_back};
    
    CyGlobalIntEnable; /* Enable global interrupts. */
    PS2_Start();
    Debug_Start();
    initLin();

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */

    while(1){
        
        psData = PS2_Controller_get();
        
        /*Arm*/
        if(psData.L1 != L1){
            L1 = psData.L1;
            if(L1 == 1){
                arm_stop_flag = 0;
                LIN_Master_PutArray(2,1,PutData+1);
                sprintf(str,"L1\n");
                Debug_PutString(str);
            }
        }
        if(psData.L2 != L2){
            L2 = psData.L2;
            if(L2 == 1){
                arm_stop_flag = 0;
                LIN_Master_PutArray(2,1,PutData+2);
                sprintf(str,"L2\n");
                Debug_PutString(str);
            }
        }
        if(L1 == L2){
            if(arm_stop_flag == 0)
            {
                arm_stop_flag = 1;
                LIN_Master_PutArray(2,1,PutData);
                sprintf(str,"L1 L2 stop\n");
                Debug_PutString(str);
            }
        }
        
        /*Base*/
        if(psData.UP != UP){
            UP = psData.UP;
            if(UP == 1){
                base_stop_flag = 0;
                LIN_Master_PutArray(2,1,PutData+4);
                sprintf(str,"UP\n");
                Debug_PutString(str);
            }
        }
        if(psData.DOWN != DOWN){
            DOWN = psData.DOWN;
            if(DOWN == 1){
                base_stop_flag = 0;
                LIN_Master_PutArray(2,1,PutData+5);
                sprintf(str,"DOWN\n");
                Debug_PutString(str);
            }
        }
        
        if(UP == DOWN){
            if(base_stop_flag == 0)
            {
                base_stop_flag = 1;
                LIN_Master_PutArray(2,1,PutData+3);
                sprintf(str,"UP DOWN stop\n");
                Debug_PutString(str);
            }
        }
        
        /*Air*/
        if(psData.TRIANGLE){
            Pantograph_Write(Open);
        }
        else{
            Pantograph_Write(Close);
        }
        
        if(psData.CIRCLE){
            PantographHand_Write(Open);
        }
        else{
            PantographHand_Write(Close);    
        }
        
        if(psData.SQUARE){
            MainHand_Write(Open);
        }
        else{
            MainHand_Write(Close);
        }
        
        if(psData.CROSS){
            SidesHands_Write(Open);
        }
        else{
            SidesHands_Write(Close);
        }
     
    }
}

/* [] END OF FILE */

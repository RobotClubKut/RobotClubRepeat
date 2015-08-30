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

enum machine_state
{
    stop_state,
    up_state,
    down_state,
    end_state
};


int main()
{
    PS2Controller psData;
    char str[20];
    uint8 debug_val1;
    enum machine_state motor_state;
    uint8 PutData[3] = {0,1,2};
    
    CyGlobalIntEnable; /* Enable global interrupts. */
    PS2_Start();
    Debug_Start();
    initLin();

    /* Place your initialization/startup code here (e.g. MyInst_Start()) */

while(1)
    {
        psData = PS2_Controller_get();
        if(psData.CIRCLE){
            //○ボタンが押されているときの処理
            motor_state = up_state;
        }
        
        if(psData.SQUARE){
            //○ボタンが押されているときの処理
            motor_state = down_state;
        }
        
        if((psData.CIRCLE == 0) && (psData.SQUARE == 0)){
            motor_state = stop_state;
        }
        
        if(psData.TRIANGLE){
            Pantograph_Write(Open);
            PantographHand_Write(Open);
            MainHand_Write(Open);
            SidesHands_Write(Open);
        }else{
            Pantograph_Write(Close);
            PantographHand_Write(Close);
            MainHand_Write(Close);
            SidesHands_Write(Close);
        }
        
        /*motor_state*/
        if(motor_state == stop_state){
            LIN_Master_PutArray(0x02,1,PutData);
        }else if(motor_state == up_state){
            LIN_Master_PutArray(0x02,1,PutData+1);
        }else if(motor_state == down_state){
            LIN_Master_PutArray(0x02,1,PutData+2);
        }else{
        
        }
        
        /*デバック*/
        if(debug_val1 != motor_state){
            debug_val1 = motor_state;
            sprintf(str,"motor_state = %d\n",(int)motor_state);
            Debug_PutString(str);
        }        
    }
}

/* [] END OF FILE */

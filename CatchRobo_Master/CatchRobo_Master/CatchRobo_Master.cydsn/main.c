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

enum machine_state
{
    default_state,
    first_state,
    second_state,
    end_state
};


int main()
{
    PS2Controller psData;
    char str[20];
    uint8 debug_val1;
    enum machine_state air_state;
    uint8 PutData[3] = {0xaa,0xff,0x55};
    
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
            air_state = air_state + 1;
            if(air_state == end_state)
            {
                air_state = default_state;
            }
            CyDelay(200);
        }else{
            //○ボタンが押されていないときの処理
            
        }
        
        /*air_state*/
        if(air_state == default_state){
            LIN_Master_PutArray(0x02,1,PutData);
        }else if(air_state == first_state){
            LIN_Master_PutArray(0x02,1,PutData+1);
        }else if(air_state == second_state){
            LIN_Master_PutArray(0x02,1,PutData+2);
        }else{
        
        }
        
        /*デバック*/
        if(debug_val1 != air_state){
            debug_val1 = air_state;
            sprintf(str,"air_state = %d\n",(int)air_state);
            Debug_PutString(str);
        }        
    }
}

/* [] END OF FILE */

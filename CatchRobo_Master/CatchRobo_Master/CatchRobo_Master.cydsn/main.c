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

#define AirDelay 200

uint8 PutData[6] = {arm_stop,arm_up,arm_down,base_stop,base_front,base_back};

void Automatic_State(uint8 number){
    if(number == 1){
    
    }
    
    else if(number == 2){
    
    }
    
    else if(number == 3){
    
    }
    
    else{
    
    }
}

/*Arm*/
void Arm_Motion(CYBIT button){
    static CYBIT button_flag = 0;
    static CYBIT previous_state = 0;
    char str[20];
    if(button != previous_state){
        previous_state = button;
        if(button == 1){
            if(button_flag == 0){
                LIN_Master_PutArray(2,1,PutData+1);
                sprintf(str,"UP\n");
                Debug_PutString(str);
            }
            else if(button_flag == 1){
                LIN_Master_PutArray(2,1,PutData+2);
                sprintf(str,"DOWN\n");
                Debug_PutString(str);
            }
            button_flag = ~button_flag;
        }
    }
}

/*Pantograph*/
void Pantograph_Motion(CYBIT button){
    static CYBIT button_flag;
    static CYBIT previous_state = 0;
    char str[20];
    if(button != previous_state){
        previous_state = button;
        if(button == 1){
            if(button_flag == 0){
                Pantograph_Write(Open);
                sprintf(str,"Pantograph Open\n");
                Debug_PutString(str);
            }
            else if(button_flag == 1){
                Pantograph_Write(Close);
                sprintf(str,"Pantograph Close\n");
                Debug_PutString(str);
            }
            button_flag = ~button_flag;
        }
    }
}

/*PantographHand*/
void PantographHand_Motion(CYBIT button){
    static CYBIT button_flag;
    static CYBIT previous_state = 0;
    char str[21];
    if(button != previous_state){
        previous_state = button;
        if(button == 1){
            if(button_flag == 0){
                PantographHand_Write(Open);
                sprintf(str,"PantographHand Open\n");
                Debug_PutString(str);
            }
            else if(button_flag == 1){
                PantographHand_Write(Close);
                sprintf(str,"PantographHand Close\n");
                Debug_PutString(str);
            }
            button_flag = ~button_flag;
        }
    }
}

/*MainHand*/
void MainHand_Motion(CYBIT button){
    static CYBIT button_flag;
    static CYBIT previous_state = 0;
    char str[20];
    if(button != previous_state){
        previous_state = button;
        if(button == 1){
            if(button_flag == 0){
                MainHand_Write(Open);
                sprintf(str,"MainHand Open\n");
                Debug_PutString(str);
            }
            else if(button_flag == 1){
                MainHand_Write(Close);
                sprintf(str,"MainHand Close\n");
                Debug_PutString(str);
            }
            button_flag = ~button_flag;
        }
    }
}

/*SidesHands*/
void SidesHands_Motion(CYBIT button){
    static CYBIT button_flag;
    static CYBIT previous_state = 0;
    char str[20];
    if(button != previous_state){
        previous_state = button;
        if(button == 1){
            if(button_flag == 0){
                SidesHands_Write(Open);
                sprintf(str,"SidesHands Open\n");
                Debug_PutString(str);
            }
            else if(button_flag == 1){
                SidesHands_Write(Close);
                sprintf(str,"SidesHands Close\n");
                Debug_PutString(str);
            }
            button_flag = ~button_flag;
        }
    }
}

int main()
{
    PS2Controller psData;
    char str[20];
    uint8 UP,DOWN;
    uint8 arm_stop_flag = 0;
    uint8 base_stop_flag = 0;
    uint8 state;
    CYBIT CIRCLE,CROSS;
    
    CyGlobalIntEnable; /* Enable global interrupts. */
    PS2_Start();
    Debug_Start();
    initLin();
    /* Place your initialization/startup code here (e.g. MyInst_Start()) */

    while(1){
        
        psData = PS2_Controller_get();
        
        /*-----Automatic Control------*/
        if((psData.SELECT == 1) && (psData.CIRCLE == 1)){
            sprintf(str,"automatic mode\n");
            Debug_PutString(str);
            CyDelay(1000);
            while(1){
                psData = PS2_Controller_get();
                
                if((psData.SELECT == 1) &&(psData.START == 1)){
                    state = 0;
                    sprintf(str,"mode reset\n");
                    Debug_PutString(str);
                    break;
                }
                if(psData.CIRCLE == 1){
                    if(CIRCLE == 1){
                    
                    }
                }
                
                Automatic_State(state);
            
            }
        
        }
        
        /*-----Manual Control------*/
        
        if((psData.SELECT == 1) && (psData.CROSS == 1)){
            sprintf(str,"manual mode\n");
            Debug_PutString(str);
            CyDelay(1000);
            while(1){
                psData = PS2_Controller_get();
                
                if((psData.SELECT == 1) &&(psData.START == 1)){
                    sprintf(str,"mode reset\n");
                    Debug_PutString(str);
                    break;
                }
                
                /*Arm*/
                Arm_Motion(psData.L1);
                
                /*Base*/
                if(psData.UP != UP){
                    UP = psData.UP;
                    if(UP == 1){
                        base_stop_flag = 0;
                        LIN_Master_PutArray(2,1,PutData+4);
                        sprintf(str,"FRONT\n");
                        Debug_PutString(str);
                    }
                }
                if(psData.DOWN != DOWN){
                    DOWN = psData.DOWN;
                    if(DOWN == 1){
                        base_stop_flag = 0;
                        LIN_Master_PutArray(2,1,PutData+5);
                        sprintf(str,"BACK\n");
                        Debug_PutString(str);
                    }
                }
                
                if(UP == DOWN){
                    if(base_stop_flag == 0)
                    {
                        base_stop_flag = 1;
                        LIN_Master_PutArray(2,1,PutData+3);
                        sprintf(str,"FRONT BACK stop\n");
                        Debug_PutString(str);
                    }
                }
                
                /*Air*/
                Pantograph_Motion(psData.TRIANGLE);
                PantographHand_Motion(psData.CIRCLE);
                MainHand_Motion(psData.SQUARE);
                SidesHands_Motion(psData.CROSS);
            }
        }
    }
}

/* [] END OF FILE */

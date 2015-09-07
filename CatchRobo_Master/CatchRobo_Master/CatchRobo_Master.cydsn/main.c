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

uint8 arm_stop = 0x00;
uint8 arm_go_up =  0x01;
uint8 arm_go_down = 0x02;
uint8 base_stop = 0x00;
uint8 base_go_front = 0x10;
uint8 base_go_back = 0x20;
uint8 base_go_mid = 0x40;
CYBIT flag;

CY_ISR(flag_isr)
{
    flag = 1;
}

void Automatic_State(uint8 number){
    
    /*state list*/
    if(number == 0){
        LIN_Master_PutArray(2,1,&arm_go_up);
        Pantograph_Write(Close);
        PantographHand_Write(Open);
        SidesHands_Write(Open);
        MainHand_Write(Close);
        LIN_Master_PutArray(2,1,&base_go_back);
    }
    else if(number == 1){
        LIN_Master_PutArray(2,1,&base_go_mid);
    }
    else if(number == 2){
        Pantograph_Write(Open);
        MainHand_Write(Open);
    }
    else if(number == 3){
        PantographHand_Write(Close);
    }
    else if(number == 4){
        Pantograph_Write(Close);
    }
    else if(number == 5){
        PantographHand_Write(Open);
    }
    else if(number == 6){
        SidesHands_Write(Close);
    }
    else if(number == 7){
        LIN_Master_PutArray(2,1,&arm_go_down);
    }
    else if(number == 8){
        MainHand_Write(Close);
    }
    else if(number == 9){
        LIN_Master_PutArray(2,1,&arm_go_up);
    }
    else if(number == 10){
        LIN_Master_PutArray(2,1,&base_go_back);
    }
    else if(number == 11){
        MainHand_Write(Open);
        SidesHands_Write(Open);
    }
    else if(number == 12){
        LIN_Master_PutArray(2,1,&base_go_front);
    }
    else if(number == 13){
        LIN_Master_PutArray(2,1,&arm_go_down);
    }
    else if(number == 14){
         MainHand_Write(Close);
    }
    else if(number == 15){
        LIN_Master_PutArray(2,1,&arm_go_up);    
    }
    else if(number == 16){
       LIN_Master_PutArray(2,1,&base_go_back);
    }
    else if(number == 17){
         MainHand_Write(Open);
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
                LIN_Master_PutArray(2,1,&arm_go_up);
                sprintf(str,"UP\n");
                Debug_PutString(str);
            }
            else if(button_flag == 1){
                LIN_Master_PutArray(2,1,&arm_go_down);
                sprintf(str,"DOWN\n");
                Debug_PutString(str);
            }
            button_flag = ~button_flag;
        }
    }
}

/*Base*/
void Base_Motion(CYBIT front,CYBIT mid,CYBIT back){
    static CYBIT previous_state_front = 0;
    static CYBIT previous_state_mid = 0;
    static CYBIT previous_state_back = 0;
    char str[20];
    
    if(front != previous_state_front){
        previous_state_front = front;
        if(front == 1){
            sprintf(str,"FRONT\n");
            Debug_PutString(str);
            LIN_Master_PutArray(2,1,&base_go_front);
        }
    }
    
    if(mid != previous_state_mid){
        previous_state_mid = mid;
        if(mid == 1){
            sprintf(str,"MID\n");
            Debug_PutString(str);
            LIN_Master_PutArray(2,1,&base_go_mid);
        }
    }
    
    if(back != previous_state_back){
        previous_state_back = back;
        if(back == 1){
            sprintf(str,"BACK\n");
            Debug_PutString(str);
            LIN_Master_PutArray(2,1,&base_go_back);
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
    uint8 state = 0;
    CYBIT circle_flag=0,cross_flag=0,previous_circle=0,previous_cross=0;
    
    CyGlobalIntEnable; /* Enable global interrupts. */
    PS2_Start();
    Debug_Start();
    initLin();
    flag_StartEx(flag_isr);

    while(1){
        
        psData = PS2_Controller_get();
        
        /*Machine Initialization*/
        Automatic_State(0);
        
        /*-----Automatic Control------*/
        if((psData.SELECT == 1) && (psData.TRIANGLE == 1)){
            sprintf(str,"automatic mode\n");
            Debug_PutString(str);
            while(1){
                psData = PS2_Controller_get();
                
                //mode　reset
                if((psData.SELECT == 1) &&(psData.START == 1)){
                    state = 0;
                    sprintf(str,"mode reset\n");
                    Debug_PutString(str);
                    break;
                }
                
                //State Increment
                if(psData.CIRCLE != previous_circle){
                    previous_circle = psData.CIRCLE;
                    if(psData.CIRCLE == 1){
                        state = state + 1;
                    }
                }
                
                //State Decrement
                if(psData.CROSS != previous_cross){
                    previous_cross = psData.CROSS;
                    if(psData.CROSS == 1){
                        if(state >= 1){
                            state = state - 1;
                        }
                    }
                }
                
                if(flag == 1){
                    Automatic_State(state);
                    flag = 0;
                }
                
            }
        
        }
        
        /*-----Manual Control------*/
        if((psData.SELECT == 1) && (psData.CROSS == 1)){
            sprintf(str,"manual mode\n");
            Debug_PutString(str);
            while(1){
                psData = PS2_Controller_get();
                
                //mode reset
                if((psData.SELECT == 1) &&(psData.START == 1)){
                    sprintf(str,"mode reset\n");
                    Debug_PutString(str);
                    break;
                }
                
                /*Arm*/
                Arm_Motion(psData.L1);
                
                /*Base*/
                Base_Motion(psData.UP,psData.RIGHT,psData.DOWN);
                
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

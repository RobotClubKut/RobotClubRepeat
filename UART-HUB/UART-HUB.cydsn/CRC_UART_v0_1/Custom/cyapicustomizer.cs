/*******************************************************************************
* Copyright 2008-2012, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

using System;
using System.Collections.Generic;
using System.Text;
using CyDesigner.Extensions.Common;
using CyDesigner.Extensions.Gde;

namespace CRC_UART_v0_1
{
    public partial class CyCustomizer : ICyAPICustomize_v1
    {
        #region ICyAPICustomize_v1 Members
        public IEnumerable<CyAPICustomizer> CustomizeAPIs(ICyInstQuery_v1 query, ICyTerminalQuery_v1 termQuery,
            IEnumerable<CyAPICustomizer> apis)
        {
            List<CyAPICustomizer> customizers = new List<CyAPICustomizer>(apis);
            Dictionary<string, string> paramDict = new Dictionary<string, string>();

            for (int i = 0; i < customizers.Count; i++)
            {
                // Get dict from main file. 
                if ((customizers[i].OriginalName.EndsWith("CRC_UART.c")) || (customizers[i].OriginalName.EndsWith("CRC_UART.h")))
                {
                    paramDict = customizers[i].MacroDictionary;
                    break;
                }
            }
            CyCRCParameters.GenerateParameters(ref paramDict);

            //If No Data in Main object than no data will be generate
            for (int i = 0; i < customizers.Count; i++)
            {
                customizers[i].MacroDictionary = paramDict;
            }
            return customizers;
        }
        #endregion
    }
}

/*******************************************************************************
* Copyright 2008-2012, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Diagnostics;

namespace CRC_UART_v0_1
{
    public partial class CyCRCParameters
    {
        public static void GenerateParameters(ref Dictionary<string, string> paramDict)
        {
            uint crcMask;
            int j;

            string resolution;
            string polyValueLower;
            string polyValueUpper;
            string seedValueUpper;
            string seedValueLower;

            paramDict.TryGetValue(S_RESOLUTION, out resolution);
            uint n = uint.Parse(resolution);

            //Create parameters in HEX format
            paramDict.TryGetValue(S_POLY_VALUE + S_LOWER, out polyValueLower);
            paramDict.TryGetValue(S_POLY_VALUE + S_UPPER, out polyValueUpper);
            paramDict.TryGetValue(S_SEED_VALUE + S_UPPER, out seedValueUpper);
            paramDict.TryGetValue(S_SEED_VALUE + S_LOWER, out seedValueLower);

            paramDict[S_POLY_VALUE + S_LOWER] = "0x" + Convert.ToUInt32(polyValueLower).ToString("X");
            paramDict[S_POLY_VALUE + S_UPPER] = "0x" + Convert.ToUInt32(polyValueUpper).ToString("X");
            paramDict[S_SEED_VALUE + S_LOWER] = "0x" + Convert.ToUInt32(seedValueLower).ToString("X");
            paramDict[S_SEED_VALUE + S_UPPER] = "0x" + Convert.ToUInt32(seedValueUpper).ToString("X");

            #region  CRC_Mask
            crcMask = 0;
            if (n > 32) n -= 32;

            for (j = 0; j < n; j++)
            {
                crcMask = (uint)(crcMask | (uint)(1 << j));
            }
            #endregion

            paramDict.Add("Mask", "0x" + crcMask.ToString("X"));
        }
    }
}

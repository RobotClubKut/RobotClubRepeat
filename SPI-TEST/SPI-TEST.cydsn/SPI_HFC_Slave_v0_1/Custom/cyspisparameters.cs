/*******************************************************************************
* Copyright 2008-2013, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.ComponentModel;
using CyDesigner.Extensions.Common;
using CyDesigner.Extensions.Gde;

namespace SPI_HFC_Slave_v0_1
{
    #region Component Parameter Names
    public class CyParamNames
    {
        // Basic tab parameners
        public const string MODE = "Mode";
        //public const string BIDIRECT_MODE = "BidirectMode";
        public const string NUMBER_OF_DATA_BITS = "NumberOfDataBits";
        public const string SHIFT_DIR = "ShiftDir";
        public const string DESIRED_BIT_RATE = "DesiredBitRate";

        // Advanced tab parameters
        public const string CLOCK_INTERNAL = "ClockInternal";
        public const string INTERRUPT_ON_DONE = "InterruptOnDone";
        public const string INTERRUPT_ON_RX_EMPTY = "InterruptOnRXEmpty";
        public const string INTERRUPT_ON_TX_NOT_FULL = "InterruptOnTXNotFull";
        public const string INTERRUPT_ON_TX_EMPTY = "InterruptOnTXEmpty";
        public const string INTERRUPT_ON_RX_NOT_EMPTY = "InterruptOnRXNotEmpty";
        public const string INTERRUPT_ON_RX_OVERRUN = "InterruptOnRXOverrun";
        public const string INTERRUPT_ON_RX_FULL = "InterruptOnRXFull";
        public const string INTERRUPT_ON_BYTE_COMPLETE = "InterruptOnByteComplete";
        public const string RX_BUFFER_SIZE = "RxBufferSize";
        public const string TX_BUFFER_SIZE = "TxBufferSize";
        public const string USE_INTERNAL_INTERRUPT = "UseInternalInterrupt";
        public const string USE_TX_INTERNAL_INTERRUPT = "UseTxInternalInterrupt";
        public const string USE_RX_INTERNAL_INTERRUPT = "UseRxInternalInterrupt";
        public const string MULTI_SLAVE_ENABLE = "MultiSlaveEnable";
        public const string FIXED_PLACEMENT_ENABLED = "FixedPlacementEnabled";

        // Hidden tab parameters
        public const string CONTROL_FILE_NAME = "ControlFileName";
    }
    #endregion

    #region Component Parameters Range
    public class CyParamRange
    {
        // Basic Tab Constants
        public const byte NUM_BITS_MIN = 3;
        public const byte NUM_BITS_MAX = 16;
        public const int FREQUENCY_MIN = 1;
        public const int FREQUENCY_MAX = 33000000;

        // Advanced Tab Constants
        public const byte BUFFER_SIZE_MIN = 4;
        public const byte BUFFER_SIZE_MAX = 255;
    }
    #endregion

    #region Component types
    public enum E_SPI_MODES { Mode_00 = 0, Mode_01 = 1, Mode_10 = 2, Mode_11 = 3 };
    public enum E_B_SPI_SLAVE_SHIFT_DIRECTION
    {
        [Description("MSB First")]
        MSB_First_revA = 0,
        [Description("LSB First")]
        LSB_First_revA = 1
    };
    #endregion

    public class CySPISParameters
    {
        public ICyInstEdit_v1 m_inst;
        public CySPISControl m_basicTab;
        public CySPISControlAdv m_advTab;

        /// <summary>
        /// During first getting of parameters this variable is false, what means that assigning
        /// values to form controls will not immediatly overwrite parameters with the same values.
        /// </summary>
        public bool m_bGlobalEditMode = false;

        public List<string> m_modeList;
        public List<string> m_shiftDirectionList;

        #region Constructor(s)
        public CySPISParameters(ICyInstEdit_v1 inst)
        {
            this.m_inst = inst;
            m_modeList = new List<string>(inst.GetPossibleEnumValues(CyParamNames.MODE));
            m_shiftDirectionList = new List<string>(inst.GetPossibleEnumValues(CyParamNames.SHIFT_DIR));
        }
        #endregion

        #region Basic Tab Properties
        public E_SPI_MODES Mode
        {
            get
            {
                return GetValue<E_SPI_MODES>(CyParamNames.MODE);
            }
            set
            {
                SetValue(CyParamNames.MODE, value);
                SetControlFileName();
            }
        }

		/*
        public bool BidirectMode
        {
            get
            {
                return GetValue<bool>(CyParamNames.BIDIRECT_MODE);
            }
            set
            {
                SetValue(CyParamNames.BIDIRECT_MODE, value);
                SetControlFileName();
            }
        }
		*/

        public byte? NumberOfDataBits
        {
            get
            {
                return GetValue<byte>(CyParamNames.NUMBER_OF_DATA_BITS);
            }
            set
            {
                SetValue(CyParamNames.NUMBER_OF_DATA_BITS, value);
                SetControlFileName();
            }
        }

        public E_B_SPI_SLAVE_SHIFT_DIRECTION ShiftDir
        {
            get
            {
                return GetValue<E_B_SPI_SLAVE_SHIFT_DIRECTION>(CyParamNames.SHIFT_DIR);
            }
            set
            {
                SetValue(CyParamNames.SHIFT_DIR, value);
            }
        }

        public double? DesiredBitRate
        {
            get
            {
                return GetValue<double>(CyParamNames.DESIRED_BIT_RATE);
            }
            set
            {
                SetValue(CyParamNames.DESIRED_BIT_RATE, value);
            }
        }
        #endregion

        #region Advanced Tab Properties
        public bool ClockInternal
        {
            get
            {
                return GetValue<bool>(CyParamNames.CLOCK_INTERNAL);
            }
            set
            {
                SetValue(CyParamNames.CLOCK_INTERNAL, value);
            }
        }

        public bool InterruptOnTXEmpty
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_TX_EMPTY);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_TX_EMPTY, value);
            }
        }

        public bool InterruptOnTXNotFull
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_TX_NOT_FULL);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_TX_NOT_FULL, value);
            }
        }

        public bool InterruptOnSPIDone
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_DONE);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_DONE, value);
            }
        }

        public bool InterruptOnRXOverrun
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_RX_OVERRUN);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_RX_OVERRUN, value);
            }
        }

        public bool InterruptOnRXEmpty
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_RX_EMPTY);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_RX_EMPTY, value);
            }
        }

        public bool InterruptOnRXNotEmpty
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_RX_NOT_EMPTY);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_RX_NOT_EMPTY, value);
            }
        }

        public bool InterruptOnRXFull
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_RX_FULL);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_RX_FULL, value);
            }
        }

        public bool InterruptOnByteComplete
        {
            get
            {
                return GetValue<bool>(CyParamNames.INTERRUPT_ON_BYTE_COMPLETE);
            }
            set
            {
                SetValue(CyParamNames.INTERRUPT_ON_BYTE_COMPLETE, value);
            }
        }

        public byte? RxBufferSize
        {
            get
            {
                return GetValue<byte>(CyParamNames.RX_BUFFER_SIZE);
            }
            set
            {
                SetValue(CyParamNames.RX_BUFFER_SIZE, value);
            }
        }

        public byte? TxBufferSize
        {
            get
            {
                return GetValue<byte>(CyParamNames.TX_BUFFER_SIZE);
            }
            set
            {
                SetValue(CyParamNames.TX_BUFFER_SIZE, value);
            }
        }

        public bool UseTxInternalInterrupt
        {
            get
            {
                return GetValue<bool>(CyParamNames.USE_TX_INTERNAL_INTERRUPT);
            }
            set
            {
                SetValue(CyParamNames.USE_TX_INTERNAL_INTERRUPT, value);
            }
        }

        public bool UseRxInternalInterrupt
        {
            get
            {
                return GetValue<bool>(CyParamNames.USE_RX_INTERNAL_INTERRUPT);
            }
            set
            {
                SetValue(CyParamNames.USE_RX_INTERNAL_INTERRUPT, value);
            }
        }

        public bool MultiSlaveEnable
        {
            get
            {
                return GetValue<bool>(CyParamNames.MULTI_SLAVE_ENABLE);
            }
            set
            {
                SetValue(CyParamNames.MULTI_SLAVE_ENABLE, value);
            }
        }

        public bool UseInternalInterrupt
        {
            get
            {
                // Backward compatibility. This parameter isn't in use anymore but have to be analyzed 
                // during update from versions lower than 2.0.
                bool useInternalInterrupt = GetValue<bool>(CyParamNames.USE_INTERNAL_INTERRUPT);

                if (useInternalInterrupt)
                {
                    this.UseTxInternalInterrupt = useInternalInterrupt;
                    this.UseRxInternalInterrupt = useInternalInterrupt;
                }
                else
                {
                    // UseTXInternalInterrupt
                    this.UseTxInternalInterrupt = GetValue<bool>(CyParamNames.USE_TX_INTERNAL_INTERRUPT);
                    // UseRXInternalInterrupt
                    this.UseRxInternalInterrupt = GetValue<bool>(CyParamNames.USE_RX_INTERNAL_INTERRUPT);
                }
                return useInternalInterrupt;
            }
            set
            {
                SetValue(CyParamNames.USE_INTERNAL_INTERRUPT, value);
            }
        }

        public bool FixedPlacementEnabled
        {
            get
            {
                return GetValue<bool>(CyParamNames.FIXED_PLACEMENT_ENABLED);
            }
            set
            {
                SetValue(CyParamNames.FIXED_PLACEMENT_ENABLED, value);
                SetControlFileName();
            }
        }
        #endregion

        #region Getting parameters
        private T GetValue<T>(string paramName)
        {
            T value;

            CyCustErr err = m_inst.GetCommittedParam(paramName).TryGetValueAs<T>(out value);
            if (err.IsOK)
            {
                return value;
            }
            else
            {
                m_basicTab.ShowError(paramName, err);
                return default(T);
            }
        }

        public void LoadParameters(ICyInstEdit_v1 inst)
        {
            m_bGlobalEditMode = false;
            m_basicTab.UpdateUI();
            m_advTab.UpdateUI();
            m_bGlobalEditMode = true;
        }
        #endregion

        #region Setting parameters
        private void SetValue<T>(string paramName, T value)
        {
            if (m_bGlobalEditMode)
            {
                switch (paramName)
                {
                    case CyParamNames.MODE:
                    case CyParamNames.CONTROL_FILE_NAME:
                        SetParam<T>(paramName, value, false);
                        break;
                    case CyParamNames.SHIFT_DIR:
                        string desc = CyEnumConverter.GetEnumDesc(value);
                        string valueToSet = m_inst.ResolveEnumDisplayToId(paramName, desc);
                        SetParam<string>(paramName, valueToSet, false);
                        break;
                    default:
                        SetParam<T>(paramName, value, true);
                        break;
                }

                m_inst.CommitParamExprs();
            }
        }

        private void SetParam<T>(string paramName, T value, bool toLowerCase)
        {
            if (toLowerCase)
            {
                m_inst.SetParamExpr(paramName, value.ToString().ToLower());
            }
            else
            {
                m_inst.SetParamExpr(paramName, value.ToString());
            }
        }
        #endregion

        #region Setting ControlFileName parameter
        private void SetControlFileName()
        {
            string fileName = "SPI_Slave_Default.ctl";
            if (FixedPlacementEnabled)
            {
                //string dataLines = (BidirectMode) ? "BD" : "FD";
				string dataLines = "FD";
                int dataBits = (NumberOfDataBits > 8) ? 16 : 8;
                if (m_inst.DeviceQuery.IsPSoC3)
                {
                    fileName = string.Format("SPI_Slave_{0}_{1}_CPHA_{2}.ctl", dataBits, dataLines,
                        ((Mode == E_SPI_MODES.Mode_00 || Mode == E_SPI_MODES.Mode_01) ? 0 : 1));
                }
                else if (m_inst.DeviceQuery.IsPSoC5)
                {
                    fileName = string.Format("SPI_Slave_{0}_{1}_ARM.ctl", dataBits, dataLines);
                }
            }
            SetValue(CyParamNames.CONTROL_FILE_NAME, fileName);
        }
        #endregion
    }
}

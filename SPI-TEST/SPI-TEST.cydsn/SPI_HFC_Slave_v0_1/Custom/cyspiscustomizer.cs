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
using System.Diagnostics;
using CyDesigner.Extensions.Common;
using CyDesigner.Extensions.Gde;

namespace SPI_HFC_Slave_v0_1
{
    [CyCompDevCustomizer()]
    public class CyCustomizer : ICyParamEditHook_v1, ICyDRCProvider_v1, ICyBootLoaderSupport
    {
        public const string BASIC_TABNAME = "Basic";
        public const string ADVANCED_TABNAME = "Advanced";

        #region ICyParamEditHook_v1 Members
        public DialogResult EditParams(ICyInstEdit_v1 edit, ICyTerminalQuery_v1 termQuery, ICyExpressMgr_v1 mgr)
        {
            CySPISParameters parameters = new CySPISParameters(edit);
            ICyTabbedParamEditor editor = edit.CreateTabbedParamEditor();

            CyParamExprDelegate configureExpressionViewDataChanged =
            delegate(ICyParamEditor custEditor, CyCompDevParam param)
            {
                parameters.LoadParameters(edit);
            };
            editor.AddCustomPage(Resources.BasicTabTitle, new CySPISControl(parameters),
                configureExpressionViewDataChanged, BASIC_TABNAME);
            editor.AddCustomPage(Resources.AdvancedTabTitle, new CySPISControlAdv(parameters, edit.DeviceQuery),
                configureExpressionViewDataChanged, ADVANCED_TABNAME);
            editor.AddDefaultPage(Resources.BuiltInTabTitle, "Built-in");
            parameters.LoadParameters(edit);
            parameters.m_bGlobalEditMode = true;
            return editor.ShowDialog();
        }

        public bool EditParamsOnDrop
        {
            get { return false; }
        }

        public CyCompDevParamEditorMode GetEditorMode()
        {
            return CyCompDevParamEditorMode.COMPLETE;
        }
        #endregion

        #region ICyDRCProvider_v1 Members
        public IEnumerable<CyDRCInfo_v1> GetDRCs(ICyDRCProviderArgs_v1 args)
        {
            CyCustErr err = VerifyNumberOfDatabits(args.InstQueryV1);
            if (err.IsOk == false)
                yield return new CyDRCInfo_v1(CyDRCInfo_v1.CyDRCType_v1.Error, err.Message);
            err = VerifyFixedPlacement(args.InstQueryV1);
            if (err.IsOk == false)
                yield return new CyDRCInfo_v1(CyDRCInfo_v1.CyDRCType_v1.Error, err.Message);
        }

        CyCustErr VerifyNumberOfDatabits(ICyInstQuery_v1 instQuery)
        {
            CyCustErr result = CyCustErr.OK;

            byte value = 0;
            instQuery.GetCommittedParam(CyParamNames.NUMBER_OF_DATA_BITS).TryGetValueAs<byte>(out value);

            if (value < CyParamRange.NUM_BITS_MIN)
            {
                result = new CyCustErr(string.Format(Resources.DRCNumberOfDataBitsMsg,
                    CyParamRange.NUM_BITS_MIN, CyParamRange.NUM_BITS_MAX));
            }
            return result;
        }

        CyCustErr VerifyFixedPlacement(ICyInstQuery_v1 instQuery)
        {
            CyCustErr result = CyCustErr.OK;
            bool fixedPlacement;
            CyCompDevParam param = instQuery.GetCommittedParam(CyParamNames.FIXED_PLACEMENT_ENABLED);
            if (param.ErrorCount == 0)
            {
                param.TryGetValueAs<bool>(out fixedPlacement);
                if (instQuery.DeviceQuery.IsPSoC4 && fixedPlacement)
                {
                    result = new CyCustErr(Resources.FixedPlacementDRC);
                }
            }
            return result;
        }
        #endregion

        #region ICyBootLoaderSupport Members
        public CyCustErr IsBootloaderReady(ICyInstQuery_v1 inst)
        {
            return CyCustErr.OK;
        }
        #endregion
    }
}

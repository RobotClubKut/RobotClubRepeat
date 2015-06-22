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
using System.Windows.Forms;
using System.Diagnostics;

namespace CRC_UART_v0_1
{
    [CyCompDevCustomizer()]
    partial class CyCustomizer : ICyParamEditHook_v1
    {
        public const string PARAM_TAB_POLYNOMIAL = "General";
        public const string PARAM_TAB_ADVANCED = "Advanced";

        #region ICyParamEditHook_v1 Members
        public DialogResult EditParams(ICyInstEdit_v1 edit, ICyTerminalQuery_v1 termQuery, ICyExpressMgr_v1 mgr)
        {
            CyCRCParameters parameters = new CyCRCParameters(edit);
            CyConfigurationEditingControl m_editControl = new CyConfigurationEditingControl(parameters);
            CyAdvancedEditingControl m_advControl = new CyAdvancedEditingControl(parameters);

            CyParamExprDelegate ExpView_ParamChanged =
                delegate(ICyParamEditor custEditor, CyCompDevParam param)
                {
                    parameters.m_exprViewParam = param;
                    parameters.GetExprParams(param);
                    if (param.TabName == PARAM_TAB_POLYNOMIAL)
                        ((CyCRCControl)(m_editControl.DisplayControl)).UpdateControls();
                    else if (param.TabName == PARAM_TAB_ADVANCED)
                        ((CyAdvancedControl)(m_advControl.DisplayControl)).UpdateForm();
                    parameters.m_exprViewParam = null;
                };

            ICyTabbedParamEditor editor = edit.CreateTabbedParamEditor();
            editor.AddCustomPage(Properties.Resources.PAGE_TITLE_POLYNOMIAL, m_editControl, ExpView_ParamChanged,
                                 PARAM_TAB_POLYNOMIAL);
            editor.AddCustomPage(Properties.Resources.PAGE_TITLE_ADVANCED, m_advControl, ExpView_ParamChanged,
                                 PARAM_TAB_ADVANCED);
            editor.AddDefaultPage(Properties.Resources.PAGE_TITLE_BUILTIN, "Built-in");
            DialogResult result = editor.ShowDialog();
            return result;
        }

        public bool EditParamsOnDrop
        {
            get
            {
                return false;
            }
        }

        public CyCompDevParamEditorMode GetEditorMode()
        {
            return CyCompDevParamEditorMode.COMPLETE;
        }
        #endregion
    }

    public class CyConfigurationEditingControl : ICyParamEditingControl
    {
        readonly CyCRCControl m_control;

        public CyConfigurationEditingControl(CyCRCParameters parameters)
        {
            Debug.Assert(parameters != null);

            m_control = new CyCRCControl(parameters);
            m_control.Dock = DockStyle.Fill;
        }

        #region ICyParamEditingControl Members
        public Control DisplayControl
        {
            get { return m_control; }
        }

        public IEnumerable<CyCustErr> GetErrors()
        {
            CyCustErr error1 = null;

            // Error with Zero Polynomial value
            if (m_control.m_parameters.PolyValue == 0)
            {
                error1 = new CyCustErr(Properties.Resources.MSG_POLYNOMIAL_SHOULD_BE_GREATER_ZERO);
                return new CyCustErr[] { error1 };
            }

            // Error with Seed value
            UInt64 maxSeed = m_control.GetMaxSeedValue();
            if (m_control.m_parameters.SeedValue > maxSeed)
            {
                error1 = new CyCustErr(string.Format(Properties.Resources.MSG_MAX_VALID_SEED_VALUE,
                    m_control.m_parameters.Resolution, maxSeed.ToString("X")));
                return new CyCustErr[] { error1 };
            }

            return new CyCustErr[] { };
        }
        #endregion
    }

    public class CyAdvancedEditingControl : ICyParamEditingControl
    {
        private readonly CyAdvancedControl m_control;
        private CyCRCParameters m_params;

        public CyAdvancedEditingControl(CyCRCParameters parameters)
        {
            m_control = new CyAdvancedControl(parameters);
            m_control.Dock = DockStyle.Fill;
            parameters.m_advancedPage = m_control;
            m_params = parameters;
        }

        #region ICyParamEditingControl Members
        public Control DisplayControl
        {
            get { return m_control; }
        }

        public IEnumerable<CyCustErr> GetErrors()
        {
            foreach (string paramName in m_params.m_inst.GetParamNames())
            {
                CyCompDevParam param = m_params.m_inst.GetCommittedParam(paramName);
                if (param.TabName.Equals(CyCustomizer.PARAM_TAB_ADVANCED))
                {
                    if (param.ErrorCount > 0)
                    {
                        foreach (string errMsg in param.Errors)
                        {
                            yield return new CyCustErr(errMsg);
                        }
                    }
                }
            }
        }
        #endregion
    }
}

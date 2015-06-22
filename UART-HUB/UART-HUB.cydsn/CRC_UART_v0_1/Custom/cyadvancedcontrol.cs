/*******************************************************************************
* Copyright 2008-2012, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided. 
********************************************************************************/

using System;
using System.Windows.Forms;

namespace CRC_UART_v0_1
{
    public partial class CyAdvancedControl : UserControl
    {
        private const byte TM_MIN_CHECKPOINT = 8;
        private const byte TM_MAX_CHECKPOINT = 32;
        private const byte WAKEUP_RESUME = 1;
        private const byte WAKEUP_START = 0;

        public CyCRCParameters m_parameters;

        public CyAdvancedControl()
        {
            InitializeComponent();
        }

        public CyAdvancedControl(CyCRCParameters parameters)
        {
            InitializeComponent();
            m_parameters = parameters;
            UpdateForm();
        }

        public void UpdateForm()
        {
            if (m_parameters.TimeMultiplexing)
                radioButtonEnabled.Checked = true;
            else
                radioButtonDisabled.Checked = true;

            EnableTimeMultiplexing();
        }

        public void EnableTimeMultiplexing()
        {
            bool shouldEnable = m_parameters.Resolution > TM_MAX_CHECKPOINT;
            bool shouldDisable = m_parameters.Resolution <= TM_MIN_CHECKPOINT;
            if (shouldEnable)
            {
                if (radioButtonDisabled.Checked)
                {
                    errorProvider.SetError(radioButtonDisabled, Properties.Resources.MSG_ENABLE_TIME_MULTIPLEXING);
                    errorProvider.SetError(radioButtonEnabled, String.Empty);
                }
                else
                {
                    errorProvider.SetError(radioButtonEnabled, String.Empty);
                    errorProvider.SetError(radioButtonDisabled, String.Empty);
                }
            }
            else if (shouldDisable)
            {
                if (radioButtonEnabled.Checked)
                {
                    errorProvider.SetError(radioButtonEnabled, Properties.Resources.MSG_DISABLE_TIME_MULTIPLEXING);
                    errorProvider.SetError(radioButtonDisabled, String.Empty);
                }
                else
                {
                    errorProvider.SetError(radioButtonEnabled, String.Empty);
                    errorProvider.SetError(radioButtonDisabled, String.Empty);
                }
            }
            else
            {
                errorProvider.SetError(radioButtonDisabled, String.Empty);
                errorProvider.SetError(radioButtonEnabled, String.Empty);
            }
        }

        private void radioButtonEnabled_CheckedChanged(object sender, EventArgs e)
        {
            if (m_parameters.TimeMultiplexing != radioButtonEnabled.Checked)
            {
                m_parameters.TimeMultiplexing = radioButtonEnabled.Checked;
                m_parameters.SetParam(CyCRCParameters.S_TIMEMULTIPLEXING);

                EnableTimeMultiplexing();
            }
        }

        private void CyAdvancedControl_SizeChanged(object sender, EventArgs e)
        {
            radioButtonDisabled.Left = groupBoxTimeMultiplexing.Width / 2;
            labelDisable.Left = radioButtonDisabled.Left;
            labelEnable.Width = labelDisable.Left - labelEnable.Left - 5;
            labelDisable.Width = labelEnable.Width;
        }

        private void CyAdvancedControl_VisibleChanged(object sender, EventArgs e)
        {
            EnableTimeMultiplexing();
        }
    }
}

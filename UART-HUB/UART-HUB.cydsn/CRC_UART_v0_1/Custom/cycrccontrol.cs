/*******************************************************************************
* Copyright 2008-2012, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using System.Collections;
using System.Diagnostics;

namespace CRC_UART_v0_1
{
    public partial class CyCRCControl : UserControl
    {
        private enum CyPolynomEditModes
        {
            NONE, STANDARD, N, CELL, POLYNOMIAL
        };

        #region Fields, Properties
        public CyCRCParameters m_parameters;
        private bool[] m_checkedCells = new bool[64];
        private ArrayList[] m_standartPolynomials = new ArrayList[22];
        private Bitmap m_polynomBmp;
        private CyPolynomEditModes m_editmode = CyPolynomEditModes.NONE;
        private int m_n;

        private DataGridViewCellStyle m_checkedCellsStyle;

        public int N
        {
            get { return m_n; }
            set
            {
                if ((value <= 64) && (value > 0))
                {
                    m_n = value;
                    m_parameters.Resolution = m_n;
                    for (int i = 0; i < 4; i++)
                    {
                        for (int j = 0; j < dataGridCheck.ColumnCount; j++)
                        {
                            if (i * dataGridCheck.ColumnCount + j < N)
                            {
                                dataGridCheck[j, i].Value = N - (i * dataGridCheck.ColumnCount + j);
                            }
                            else
                            {
                                dataGridCheck[j, i].Value = string.Empty;

                            }
                            dataGridCheck[j, i].Style = dataGridCheck.DefaultCellStyle;
                            dataGridCheck[j, i].Style.SelectionBackColor = Color.White;
                            dataGridCheck[j, i].Style.SelectionForeColor = Color.Black;
                            m_checkedCells[i * dataGridCheck.ColumnCount + j] = false;
                        }
                    }
                    DrawPolynomBmp();
                    pictureBoxPolynom.Height = (m_n / 16 + 1) * 22;
                    groupBoxPolynom.Height = pictureBoxPolynom.Top + pictureBoxPolynom.Height + 3;
                    pictureBoxPolynom.Invalidate();

                    string seed = "0";
                    if (m_parameters.SeedValue.ToString("x").Length <= (N - 1) / 4 + 1)
                    {
                        seed = m_parameters.SeedValue.ToString("X");
                    }
                    else
                    {
                        m_parameters.SeedValue = 0;
                    }
                    for (int i = seed.Length; i < (N - 1) / 4 + 1; i++)
                    {
                        seed = "0" + seed;
                    }
                    textBoxSeed.Text = seed;
                }
            }
        }
        #endregion Fields, Properties

        #region Constructors
        public CyCRCControl()
        {
            InitializeComponent();

            InitStandartPolynomials();
            InitDataGrid();
            InitBmp();
            m_parameters = new CyCRCParameters();
        }

        public CyCRCControl(CyCRCParameters parameters)
        {
            InitializeComponent();

            InitStandartPolynomials();
            InitDataGrid();
            InitBmp();

            this.m_parameters = parameters;
            UpdateControls();
        }
        #endregion Constructors

        public void UpdateControls()
        {
            try
            {
                if (m_editmode == CyPolynomEditModes.NONE) m_editmode = CyPolynomEditModes.STANDARD;

                textBoxSeed.Text = m_parameters.SeedValue.ToString("X");
                comboBoxStandard.Text = m_parameters.PolyName;
                if ((m_parameters.PolyValue > 0) && (comboBoxStandard.SelectedIndex < 1))
                {
                    m_editmode = CyPolynomEditModes.POLYNOMIAL;
                    textBoxResult.Text = m_parameters.PolyValue.ToString("X");
                    textBoxResult_Validated(textBoxResult, EventArgs.Empty);
                }

                m_editmode = CyPolynomEditModes.NONE;
            }
            catch
            {
                MessageBox.Show(Properties.Resources.MSG_PARAMETER_INITIALIZATION, "Error", MessageBoxButtons.OK,
                                MessageBoxIcon.Error);
            }
        }

        public UInt64 GetMaxSeedValue()
        {
            ulong maxSeed = (((ulong)1 << m_parameters.Resolution) - 1);
            if (m_parameters.Resolution == 64)
                maxSeed = UInt64.MaxValue;
            return maxSeed;
        }

        #region Private functions
        private void InitDataGrid()
        {
            m_checkedCellsStyle = new DataGridViewCellStyle();
            m_checkedCellsStyle.BackColor = Color.SkyBlue;
            dataGridCheck.Rows.Clear();
            for (int i = 0; i < 4; i++)
            {
                dataGridCheck.Rows.Add();
            }
        }

        private void InitStandartPolynomials()
        {
            for (int i = 0; i < m_standartPolynomials.Length; i++)
            {
                m_standartPolynomials[i] = new ArrayList();
            }
            //CRC-1
            m_standartPolynomials[0].Add(1);
            m_standartPolynomials[0].Add("Parity");
            //CRC-4-ITU
            m_standartPolynomials[1].Add(4);
            m_standartPolynomials[1].Add(1);
            m_standartPolynomials[1].Add("ITU G.704");
            //CRC-5-ITU
            m_standartPolynomials[2].Add(5);
            m_standartPolynomials[2].Add(4);
            m_standartPolynomials[2].Add(2);
            m_standartPolynomials[2].Add("ITU G.704");
            //CRC-5-USB
            m_standartPolynomials[3].Add(5);
            m_standartPolynomials[3].Add(2);
            m_standartPolynomials[3].Add("USB");
            //CRC-6-ITU
            m_standartPolynomials[4].Add(6);
            m_standartPolynomials[4].Add(1);
            m_standartPolynomials[4].Add("ITU G.704");
            //CRC-7
            m_standartPolynomials[5].Add(7);
            m_standartPolynomials[5].Add(3);
            m_standartPolynomials[5].Add("Telecom systems, MMC");
            //CRC-8-ATM
            m_standartPolynomials[6].Add(8);
            m_standartPolynomials[6].Add(2);
            m_standartPolynomials[6].Add(1);
            m_standartPolynomials[6].Add("ATM HEC");
            //CRC-8-CCITT
            m_standartPolynomials[7].Add(8);
            m_standartPolynomials[7].Add(7);
            m_standartPolynomials[7].Add(3);
            m_standartPolynomials[7].Add(2);
            m_standartPolynomials[7].Add("1-Wire bus");
            //CRC-8-Maxim
            m_standartPolynomials[8].Add(8);
            m_standartPolynomials[8].Add(5);
            m_standartPolynomials[8].Add(4);
            m_standartPolynomials[8].Add("1-Wire bus");
            //CRC-8
            m_standartPolynomials[9].Add(8);
            m_standartPolynomials[9].Add(7);
            m_standartPolynomials[9].Add(6);
            m_standartPolynomials[9].Add(4);
            m_standartPolynomials[9].Add(2);
            m_standartPolynomials[9].Add("General");
            //CRC-8-SAE
            m_standartPolynomials[10].Add(8);
            m_standartPolynomials[10].Add(4);
            m_standartPolynomials[10].Add(3);
            m_standartPolynomials[10].Add(2);
            m_standartPolynomials[10].Add("SAE J1850");
            //CRC-10
            m_standartPolynomials[11].Add(10);
            m_standartPolynomials[11].Add(9);
            m_standartPolynomials[11].Add(5);
            m_standartPolynomials[11].Add(4);
            m_standartPolynomials[11].Add(1);
            m_standartPolynomials[11].Add("General");
            //CRC-12
            m_standartPolynomials[12].Add(12);
            m_standartPolynomials[12].Add(11);
            m_standartPolynomials[12].Add(3);
            m_standartPolynomials[12].Add(2);
            m_standartPolynomials[12].Add(1);
            m_standartPolynomials[12].Add("Telecom systems");
            //CRC-15-CAN
            m_standartPolynomials[13].Add(15);
            m_standartPolynomials[13].Add(14);
            m_standartPolynomials[13].Add(10);
            m_standartPolynomials[13].Add(8);
            m_standartPolynomials[13].Add(7);
            m_standartPolynomials[13].Add(4);
            m_standartPolynomials[13].Add(3);
            m_standartPolynomials[13].Add("CAN");
            //CRC-16-CCITT
            m_standartPolynomials[14].Add(16);
            m_standartPolynomials[14].Add(12);
            m_standartPolynomials[14].Add(5);
            m_standartPolynomials[14].Add("XMODEM,X.25, V.41, Bluetooth, PPP, IrDA, CRC-CCITT");
            //CRC-16
            m_standartPolynomials[15].Add(16);
            m_standartPolynomials[15].Add(15);
            m_standartPolynomials[15].Add(2);
            m_standartPolynomials[15].Add("USB");
            //CRC-24-Radix64
            m_standartPolynomials[16].Add(24);
            m_standartPolynomials[16].Add(23);
            m_standartPolynomials[16].Add(18);
            m_standartPolynomials[16].Add(17);
            m_standartPolynomials[16].Add(14);
            m_standartPolynomials[16].Add(11);
            m_standartPolynomials[16].Add(10);
            m_standartPolynomials[16].Add(7);
            m_standartPolynomials[16].Add(6);
            m_standartPolynomials[16].Add(5);
            m_standartPolynomials[16].Add(4);
            m_standartPolynomials[16].Add(3);
            m_standartPolynomials[16].Add(1);
            m_standartPolynomials[16].Add("General");
            //CRC-32-IEEE802.3
            m_standartPolynomials[17].Add(32);
            m_standartPolynomials[17].Add(26);
            m_standartPolynomials[17].Add(23);
            m_standartPolynomials[17].Add(22);
            m_standartPolynomials[17].Add(16);
            m_standartPolynomials[17].Add(12);
            m_standartPolynomials[17].Add(11);
            m_standartPolynomials[17].Add(10);
            m_standartPolynomials[17].Add(8);
            m_standartPolynomials[17].Add(7);
            m_standartPolynomials[17].Add(5);
            m_standartPolynomials[17].Add(4);
            m_standartPolynomials[17].Add(2);
            m_standartPolynomials[17].Add(1);
            m_standartPolynomials[17].Add("Ethernet, MPEG2");
            //CRC-32C
            m_standartPolynomials[18].Add(32);
            m_standartPolynomials[18].Add(28);
            m_standartPolynomials[18].Add(27);
            m_standartPolynomials[18].Add(26);
            m_standartPolynomials[18].Add(25);
            m_standartPolynomials[18].Add(23);
            m_standartPolynomials[18].Add(22);
            m_standartPolynomials[18].Add(20);
            m_standartPolynomials[18].Add(19);
            m_standartPolynomials[18].Add(18);
            m_standartPolynomials[18].Add(14);
            m_standartPolynomials[18].Add(13);
            m_standartPolynomials[18].Add(11);
            m_standartPolynomials[18].Add(10);
            m_standartPolynomials[18].Add(9);
            m_standartPolynomials[18].Add(8);
            m_standartPolynomials[18].Add(6);
            m_standartPolynomials[18].Add("General");
            //CRC-32K                  
            m_standartPolynomials[19].Add(32);
            m_standartPolynomials[19].Add(30);
            m_standartPolynomials[19].Add(29);
            m_standartPolynomials[19].Add(28);
            m_standartPolynomials[19].Add(26);
            m_standartPolynomials[19].Add(20);
            m_standartPolynomials[19].Add(19);
            m_standartPolynomials[19].Add(17);
            m_standartPolynomials[19].Add(16);
            m_standartPolynomials[19].Add(15);
            m_standartPolynomials[19].Add(11);
            m_standartPolynomials[19].Add(10);
            m_standartPolynomials[19].Add(7);
            m_standartPolynomials[19].Add(6);
            m_standartPolynomials[19].Add(4);
            m_standartPolynomials[19].Add(2);
            m_standartPolynomials[19].Add(1);
            m_standartPolynomials[19].Add("General");
            //CRC-64-ISO
            m_standartPolynomials[20].Add(64);
            m_standartPolynomials[20].Add(4);
            m_standartPolynomials[20].Add(3);
            m_standartPolynomials[20].Add(1);
            m_standartPolynomials[20].Add("ISO 3309");
            //CRC-64-ECMA
            m_standartPolynomials[21].Add(64);
            m_standartPolynomials[21].Add(62);
            m_standartPolynomials[21].Add(57);
            m_standartPolynomials[21].Add(55);
            m_standartPolynomials[21].Add(54);
            m_standartPolynomials[21].Add(53);
            m_standartPolynomials[21].Add(52);
            m_standartPolynomials[21].Add(47);
            m_standartPolynomials[21].Add(46);
            m_standartPolynomials[21].Add(45);
            m_standartPolynomials[21].Add(40);
            m_standartPolynomials[21].Add(39);
            m_standartPolynomials[21].Add(38);
            m_standartPolynomials[21].Add(37);
            m_standartPolynomials[21].Add(35);
            m_standartPolynomials[21].Add(33);
            m_standartPolynomials[21].Add(32);
            m_standartPolynomials[21].Add(31);
            m_standartPolynomials[21].Add(29);
            m_standartPolynomials[21].Add(27);
            m_standartPolynomials[21].Add(24);
            m_standartPolynomials[21].Add(23);
            m_standartPolynomials[21].Add(22);
            m_standartPolynomials[21].Add(21);
            m_standartPolynomials[21].Add(19);
            m_standartPolynomials[21].Add(17);
            m_standartPolynomials[21].Add(13);
            m_standartPolynomials[21].Add(12);
            m_standartPolynomials[21].Add(10);
            m_standartPolynomials[21].Add(9);
            m_standartPolynomials[21].Add(7);
            m_standartPolynomials[21].Add(4);
            m_standartPolynomials[21].Add(1);
            m_standartPolynomials[21].Add("ECMA-182");
        }

        private UInt64 CalcPolynomial()
        {
            UInt64 result = 0;

            for (int i = N; i > 0; i--)
            {
                if (m_checkedCells[i - 1])
                {
                    result += Convert.ToUInt64(Math.Pow(2, i - 1));
                }
            }

            m_parameters.PolyValue = result;

            string PolyTextHexValue = result.ToString("x");
            for (int i = PolyTextHexValue.Length; i < (N - 1) / 4 + 1; i++)
            {
                PolyTextHexValue = "0" + PolyTextHexValue;
            }
            textBoxResult.Text = PolyTextHexValue.ToUpper();
            return result;
        }

        private void DrawPolynomBmp()
        {
            Graphics g = Graphics.FromImage(m_polynomBmp);
            int space = m_polynomBmp.Width / 16;//28
            int spaceVert = 22;
            Point initPos = new Point(5, 3);
            Font xFont = new Font("Arial", 10, FontStyle.Bold);
            Font degreeFont = new Font("Arial", 7);
            StringBuilder str = new StringBuilder();
            int realCount = 0;

            for (int i = 0; i < N; i++)
            {
                if (m_checkedCells[i])
                {
                    str.Append("X + ");

                }
            }
            str.Append("1");

            g.Clear(Color.White);

            SizeF xSize = g.MeasureString("X", xFont);

            for (int i = N - 1; i >= 0; i--)
            {
                if (m_checkedCells[i])
                {
                    g.DrawString("X", xFont, new SolidBrush(Color.Black), space * (realCount % 16), initPos.Y +
                        spaceVert * (realCount / 16));
                    g.DrawString("+", xFont, new SolidBrush(Color.Black), space * (realCount % 16) + space * 2 / 3,
                        initPos.Y + spaceVert * (realCount / 16));
                    g.DrawString((i + 1).ToString(), degreeFont, new SolidBrush(Color.Black), space * (realCount % 16) +
                        (int)xSize.Width * 3 / 4, spaceVert * (realCount / 16));
                    realCount++;
                }
            }
            g.DrawString("1", xFont, new SolidBrush(Color.Black), space * (realCount % 16), initPos.Y +
                spaceVert * (realCount / 16));
        }

        private void InitBmp()
        {
            pictureBoxPolynom.Image = null;
            m_polynomBmp = new Bitmap(pictureBoxPolynom.Width, 120); //450
            Graphics g = Graphics.FromImage(m_polynomBmp);
            g.Clear(Color.Gray);
            pictureBoxPolynom.Image = m_polynomBmp;
        }

        private void CellClick(int RowIndex, int ColumnIndex)
        {
            if (RowIndex * dataGridCheck.ColumnCount + ColumnIndex >= N)
            {
                return;
            }

            if (!m_checkedCells[N - (RowIndex * dataGridCheck.ColumnCount + ColumnIndex) - 1])
            {
                dataGridCheck[ColumnIndex, RowIndex].Style = m_checkedCellsStyle;
                m_checkedCells[N - (RowIndex * dataGridCheck.ColumnCount + ColumnIndex) - 1] = true;
            }
            else
            {
                dataGridCheck[ColumnIndex, RowIndex].Style = dataGridCheck.DefaultCellStyle;
                m_checkedCells[N - (RowIndex * dataGridCheck.ColumnCount + ColumnIndex) - 1] = false;
            }
            if (m_editmode == CyPolynomEditModes.CELL)
            {
                CalcPolynomial();
            }
            DrawPolynomBmp();
            pictureBoxPolynom.Invalidate();
        }
        #endregion Private functions

        #region Events
        private void comboBoxStandard_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (m_editmode == CyPolynomEditModes.NONE) m_editmode = CyPolynomEditModes.STANDARD;

            if (comboBoxStandard.SelectedIndex > 0)
            {
                int length = m_standartPolynomials[comboBoxStandard.SelectedIndex - 1].Count - 1;
                textBoxN.Text = m_standartPolynomials[comboBoxStandard.SelectedIndex - 1][0].ToString();
                toolTipDescription.SetToolTip(comboBoxStandard, "Use: " +
                    (string)(m_standartPolynomials[comboBoxStandard.SelectedIndex - 1][length]));
                N = (int)m_standartPolynomials[comboBoxStandard.SelectedIndex - 1][0];

                int deg = 0;
                for (int i = 0; i < length; i++)
                {
                    deg = (int)(m_standartPolynomials[comboBoxStandard.SelectedIndex - 1][i]);
                    CellClick((N - deg) / dataGridCheck.ColumnCount, (N - deg) % dataGridCheck.ColumnCount);
                }
                CalcPolynomial();
            }
            else
            {
                toolTipDescription.SetToolTip(comboBoxStandard, "");
            }
            m_parameters.PolyName = comboBoxStandard.Text;

            if (m_editmode == CyPolynomEditModes.STANDARD) m_editmode = CyPolynomEditModes.NONE;
        }

        #region dataGridCheck
        private void dataGridCheck_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex * dataGridCheck.ColumnCount + e.ColumnIndex >= N)
            {
                return;
            }
            m_editmode = CyPolynomEditModes.CELL;
            comboBoxStandard.SelectedIndex = 0;
            CellClick(e.RowIndex, e.ColumnIndex);
            m_editmode = CyPolynomEditModes.NONE;
        }

        private void dataGridCheck_CellEnter(object sender, DataGridViewCellEventArgs e)
        {
            dataGridCheck.CurrentCell.Selected = false;
        }

        private void dataGridCheck_CellStateChanged(object sender, DataGridViewCellStateChangedEventArgs e)
        {
            dataGridCheck.CurrentCell.Selected = false;
        }
        #endregion dataGridCheck

        #region textBoxN
        private void textBoxN_KeyPress(object sender, KeyPressEventArgs e)
        {
            comboBoxStandard.SelectedIndex = 0;
        }

        private void textBoxN_KeyUp(object sender, KeyEventArgs e)
        {
            UInt16 res;
            m_editmode = CyPolynomEditModes.N;
            if (UInt16.TryParse(textBoxN.Text, out res) && (N != res))
            {
                N = res;
                if ((res > 0) && (res <= 64))
                {
                    CellClick(0, 0);
                }
                CalcPolynomial();
            }
            else if (textBoxN.Text == "")
            {
                N = 0;
            }
            m_editmode = CyPolynomEditModes.NONE;
        }

        private void textBoxN_TextChanged(object sender, EventArgs e)
        {
            // ErrorProvider
            UInt16 res;
            if (UInt16.TryParse(textBoxN.Text, out res))
            {
                if ((res > 0) && (res <= 64))
                {
                    errorProvider.SetError(textBoxN, string.Empty);
                }
                else
                {
                    errorProvider.SetError(textBoxN, Properties.Resources.ERROR_N_RANGE);
                }
            }
            else if (textBoxN.Text == string.Empty)
            {
                errorProvider.SetError(textBoxN, string.Empty);
            }
            else
            {
                errorProvider.SetError(textBoxN, Properties.Resources.ERROR_N_RANGE);
            }
        }
        #endregion textBoxN

        #region textBoxResult
        private void textBoxResult_KeyPress(object sender, KeyPressEventArgs e)
        {
            m_editmode = CyPolynomEditModes.POLYNOMIAL;
            textBox_KeyHexLengthValidation(sender, e);
        }

        private void textBoxResult_TextChanged(object sender, EventArgs e)
        {
            if (m_editmode == CyPolynomEditModes.NONE) m_editmode = CyPolynomEditModes.POLYNOMIAL;
            try
            {
                if ((Convert.ToUInt64(textBoxResult.Text, 16) > 0) && (Convert.ToUInt64(textBoxResult.Text, 16)
                    <= Math.Pow(2, 64)))
                {
                    errorProvider.SetError(textBoxResult, "");
                }
                else
                {
                    errorProvider.SetError(textBoxResult, Properties.Resources.MSG_POLYNOMIAL_SHOULD_BE_GREATER_ZERO);
                }
            }
            catch
            {
                errorProvider.SetError(textBoxResult, Properties.Resources.MSG_INVALID_POLYNOMIAL_VALUE);
            }
        }

        private void textBoxResult_Validated(object sender, EventArgs e)
        {
            if (m_editmode == CyPolynomEditModes.POLYNOMIAL)
            {
                try
                {
                    comboBoxStandard.SelectedIndex = 0;
                    if (textBoxResult.Text != string.Empty)
                    {
                        UInt64 polyVal = Convert.ToUInt64(textBoxResult.Text, 16);
                        string s = String.Empty;
                        if (polyVal >= ((ulong)1 << 63))
                        {
                            s = polyVal.ToString("X");

                            s = Convert.ToString(Convert.ToInt64(s.Substring(0, 4), 16), 2) +
                                Convert.ToString(Convert.ToInt64(s.Substring(4), 16), 2).PadLeft(48, '0');
                        }
                        else
                        {
                            s = Convert.ToString(Convert.ToInt64(textBoxResult.Text, 16), 2);
                        }
                        if ((s.Length <= 64) && (polyVal > 0))
                        {
                            N = s.Length;

                            textBoxN.Text = N.ToString();

                            for (int i = 0; i < N; i++)
                            {
                                if (s[i] == '1')
                                    CellClick(i / dataGridCheck.ColumnCount, i % dataGridCheck.ColumnCount);
                            }

                            m_parameters.PolyValue = polyVal;
                        }
                        else if (polyVal == 0)
                        {
                            m_parameters.PolyValue = polyVal;
                        }
                    }
                }
                catch
                {
                }
                m_editmode = CyPolynomEditModes.NONE;
            }
        }
        #endregion textBoxResult

        #region textBoxSeed
        private void textBoxSeed_KeyPress(object sender, KeyPressEventArgs e)
        {
            textBox_KeyHexLengthValidation(sender, e);
        }

        private void textBoxSeed_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (Convert.ToUInt64(textBoxSeed.Text, 16) <= GetMaxSeedValue())
                {
                    errorProvider.SetError(textBoxSeed, string.Empty);
                }
                else
                {
                    errorProvider.SetError(textBoxSeed, string.Format(Properties.Resources.MSG_MAX_VALID_SEED_VALUE,
                        m_parameters.Resolution, GetMaxSeedValue().ToString("X")));
                }
            }
            catch
            {
                errorProvider.SetError(textBoxSeed, Properties.Resources.MSG_INVALID_SEED_VALUE);
            }
        }

        private void textBoxSeed_Validated(object sender, EventArgs e)
        {
            try
            {
                ulong newSeed = 0;
                if (textBoxSeed.Text != "")
                {
                    newSeed = Convert.ToUInt64(textBoxSeed.Text, 16);
                }
                m_parameters.SeedValue = newSeed;
            }
            catch
            {
            }
        }
        #endregion textBoxSeed

        #region Common textBox validation
        private void textBox_Validating(object sender, CancelEventArgs e)
        {
            if (errorProvider.GetError((Control)sender) != String.Empty)
                e.Cancel = true;
        }

        private void textBox_KeyHexLengthValidation(object sender, KeyPressEventArgs e)
        {
            TextBox tb = (TextBox)sender;
            if ((e.KeyChar != (char)Keys.Enter) && (e.KeyChar != (char)Keys.Back))
            {
                if (((e.KeyChar < '0') || (e.KeyChar > '9')) && ((e.KeyChar < 'A') || (e.KeyChar > 'F')) &&
                    ((e.KeyChar < 'a') || (e.KeyChar > 'f')))
                    e.Handled = true;
                if ((tb.Text.Length >= 16) && (tb.SelectionLength == 0))
                    e.Handled = true;
            }
        }
        #endregion Common textBox validation

        #endregion Events

        #region Enter key processing
        protected override bool ProcessCmdKey(ref Message msg, Keys keyData)
        {
            if (keyData == Keys.Enter)
            {
                SendKeys.Send("{TAB}");
                return true;
            }
            else
                return base.ProcessCmdKey(ref msg, keyData);
        }
        #endregion Enter key processing
    }
}

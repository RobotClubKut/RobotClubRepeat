/*******************************************************************************
* Copyright 2008-2012, Cypress Semiconductor Corporation.  All rights reserved.
* You may use this file only in accordance with the license, terms, conditions, 
* disclaimers, and limitations in the end user license agreement accompanying 
* the software package with which this file was provided.
********************************************************************************/

using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.Windows.Forms;
using CyDesigner.Extensions.Gde;

namespace CRC_UART_v0_1
{
    public partial class CyCRCParameters
    {
        #region Parameter names constants
        public const string S_UPPER = "Upper";
        public const string S_LOWER = "Lower";
        public const string S_POLY_VALUE = "PolyValue";
        public const string S_SEED_VALUE = "SeedValue";
        public const string S_POLY_NAME = "PolyName";
        public const string S_RESOLUTION = "Resolution";
        public const string S_TIMEMULTIPLEXING = "TimeMultiplexing";
        #endregion

        public readonly ICyInstEdit_v1 m_inst;
        private string m_polyName = "CRC-16";
        private int m_resolution = 2;
        private UInt64 m_seedValue = 0;
        private UInt64 m_polyValue = 1;
        private bool m_timeMultiplexing;

        public CyCompDevParam m_exprViewParam;
        public CyAdvancedControl m_advancedPage;

        #region Class properties
        public string PolyName
        {
            get { return m_polyName; }
            set
            {
                if (m_polyName != value)
                {
                    m_polyName = value;
                    SetParam(S_POLY_NAME);
                }
            }
        }

        public int Resolution
        {
            get { return m_resolution; }
            set
            {
                if (m_resolution != value)
                {
                    m_resolution = value;
                    SetParam(S_RESOLUTION);
                }
            }
        }

        public UInt64 PolyValue
        {
            get { return m_polyValue; }
            set
            {
                if (m_polyValue != value)
                {
                    m_polyValue = value;
                    SetParam(S_POLY_VALUE);
                }
            }
        }

        public UInt64 SeedValue
        {
            get { return m_seedValue; }
            set
            {
                if (m_seedValue != value)
                {
                    m_seedValue = value;
                    SetParam(S_SEED_VALUE);
                }
            }
        }

        public bool TimeMultiplexing
        {
            get { return m_timeMultiplexing; }
            set
            {
                if (m_timeMultiplexing != value)
                {
                    m_timeMultiplexing = value;
                    SetParam(S_TIMEMULTIPLEXING);
                }
            }
        }
        #endregion

        #region Constructors
        public CyCRCParameters()
        {
        }

        public CyCRCParameters(ICyInstEdit_v1 inst)
        {
            m_inst = inst;
            GetParams();
        }
        #endregion

        #region Getting parameters
        public void GetParams()
        {
            if (m_inst != null)
            {
                m_polyName = m_inst.GetCommittedParam(S_POLY_NAME).Value;
                m_resolution = Convert.ToInt32(m_inst.GetCommittedParam(S_RESOLUTION).Value);
                m_seedValue = (Convert.ToUInt64(m_inst.GetCommittedParam(S_SEED_VALUE + S_UPPER).Value) << 32) +
                              Convert.ToUInt64(m_inst.GetCommittedParam(S_SEED_VALUE + S_LOWER).Value);
                m_polyValue = (Convert.ToUInt64(m_inst.GetCommittedParam(S_POLY_VALUE + S_UPPER).Value) << 32) +
                              Convert.ToUInt64(m_inst.GetCommittedParam(S_POLY_VALUE + S_LOWER).Value);
                m_inst.GetCommittedParam(S_TIMEMULTIPLEXING).TryGetValueAs(out m_timeMultiplexing);
            }
        }

        public void GetExprParams(CyCompDevParam param)
        {
            if (m_inst != null)
            {
                switch (param.Name)
                {
                    case S_POLY_VALUE + S_UPPER:
                    case S_POLY_VALUE + S_LOWER:
                        m_polyValue = (Convert.ToUInt64(m_inst.GetCommittedParam(S_POLY_VALUE + S_UPPER).Value) << 32) +
                                      Convert.ToUInt64(m_inst.GetCommittedParam(S_POLY_VALUE + S_LOWER).Value);
                        PolyName = "Custom";
                        break;
                    case S_SEED_VALUE + S_UPPER:
                    case S_SEED_VALUE + S_LOWER:
                        m_seedValue = (Convert.ToUInt64(m_inst.GetCommittedParam(S_SEED_VALUE + S_UPPER).Value) << 32) +
                                      Convert.ToUInt64(m_inst.GetCommittedParam(S_SEED_VALUE + S_LOWER).Value);
                        break;
                    case S_TIMEMULTIPLEXING:
                        m_inst.GetCommittedParam(S_TIMEMULTIPLEXING).TryGetValueAs(out m_timeMultiplexing);
                        break;
                    default:
                        break;
                }
            }
        }
        #endregion

        #region Setting parameters
        public void SetParam(string paramName)
        {
            if ((m_exprViewParam != null) &&
                ((paramName.Contains(S_POLY_VALUE)) || ((paramName.Contains(S_SEED_VALUE)))))
                return;

            try
            {
                if (m_inst != null)
                {
                    switch (paramName)
                    {
                        case S_POLY_VALUE:
                            m_inst.SetParamExpr(S_POLY_VALUE + S_UPPER, (m_polyValue >> 32).ToString() + "u");
                            m_inst.SetParamExpr(S_POLY_VALUE + S_LOWER, (m_polyValue & 0xFFFFFFFF).ToString() + "u");
                            CommitParams();

                            break;
                        case S_SEED_VALUE:
                            m_inst.SetParamExpr(S_SEED_VALUE + S_UPPER, (m_seedValue >> 32).ToString() + "u");
                            m_inst.SetParamExpr(S_SEED_VALUE + S_LOWER, (m_seedValue & 0xFFFFFFFF).ToString() + "u");
                            CommitParams();

                            break;
                        case S_RESOLUTION:
                            m_inst.SetParamExpr(S_RESOLUTION, m_resolution.ToString());
                            CommitParams();

                            break;
                        case S_POLY_NAME:
                            m_inst.SetParamExpr(S_POLY_NAME, m_polyName);
                            CommitParams();

                            break;
                        case S_TIMEMULTIPLEXING:
                            m_inst.SetParamExpr(S_TIMEMULTIPLEXING, m_timeMultiplexing.ToString().ToLower());
                            CommitParams();

                            break;
                        default:
                            break;
                    }
                }
            }
            catch
            {
            }
        }

        public void SetParams()
        {
            if (m_inst != null)
            {
                m_inst.SetParamExpr(S_SEED_VALUE + S_UPPER, (m_seedValue >> 32).ToString() + "u");
                m_inst.SetParamExpr(S_SEED_VALUE + S_LOWER, (m_seedValue & 0xFFFFFFFF).ToString() + "u");
                m_inst.SetParamExpr(S_POLY_VALUE + S_UPPER, (m_polyValue >> 32).ToString() + "u");
                m_inst.SetParamExpr(S_POLY_VALUE + S_LOWER, (m_polyValue & 0xFFFFFFFF).ToString() + "u");
                m_inst.SetParamExpr(S_RESOLUTION, m_resolution.ToString());
                m_inst.SetParamExpr(S_POLY_NAME, m_polyName);
                m_inst.SetParamExpr(S_TIMEMULTIPLEXING, m_timeMultiplexing.ToString().ToLower());
                CommitParams();
            }
        }

        public void CommitParams()
        {
            if (m_inst != null)
            {
                m_inst.CommitParamExprs();
            }
        }
        #endregion
    }
}

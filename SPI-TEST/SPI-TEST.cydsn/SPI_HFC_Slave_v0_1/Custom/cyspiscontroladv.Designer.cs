
namespace SPI_HFC_Slave_v0_1
{
    partial class CySPISControlAdv
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.ep_Errors = new System.Windows.Forms.ErrorProvider(this.components);
            this.numTXBufferSize = new System.Windows.Forms.NumericUpDown();
            this.numRXBufferSize = new System.Windows.Forms.NumericUpDown();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.chbxIntOnRXFull = new System.Windows.Forms.CheckBox();
            this.chbxEnableRXInternalInterrupt = new System.Windows.Forms.CheckBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.chbxEnableTXInternalInterrupt = new System.Windows.Forms.CheckBox();
            this.chbxIntOnRXNotEmpty = new System.Windows.Forms.CheckBox();
            this.chbxIntOnByteComplete = new System.Windows.Forms.CheckBox();
            this.chbxIntOnRXEmpty = new System.Windows.Forms.CheckBox();
            this.chbxIntOnRXOverrun = new System.Windows.Forms.CheckBox();
            this.chbxIntOnSPIDone = new System.Windows.Forms.CheckBox();
            this.chbxIntOnTXNotFull = new System.Windows.Forms.CheckBox();
            this.chbxIntOnTXEmpty = new System.Windows.Forms.CheckBox();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.chbxFixedPlacement = new System.Windows.Forms.CheckBox();
            this.chbxMultiSlaveEnable = new System.Windows.Forms.CheckBox();
            this.gbClocks = new System.Windows.Forms.GroupBox();
            this.rbExternalClock = new System.Windows.Forms.RadioButton();
            this.rbInternalClock = new System.Windows.Forms.RadioButton();
            this.gbBufferSizes = new System.Windows.Forms.GroupBox();
            this.lblTXBufferSize = new System.Windows.Forms.Label();
            this.lblRXBufferSize = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.ep_Errors)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numTXBufferSize)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numRXBufferSize)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.gbClocks.SuspendLayout();
            this.gbBufferSizes.SuspendLayout();
            this.SuspendLayout();
            // 
            // ep_Errors
            // 
            this.ep_Errors.ContainerControl = this;
            // 
            // numTXBufferSize
            // 
            this.numTXBufferSize.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.ep_Errors.SetIconAlignment(this.numTXBufferSize, System.Windows.Forms.ErrorIconAlignment.MiddleLeft);
            this.numTXBufferSize.Location = new System.Drawing.Point(183, 44);
            this.numTXBufferSize.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.numTXBufferSize.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numTXBufferSize.Name = "numTXBufferSize";
            this.numTXBufferSize.Size = new System.Drawing.Size(231, 20);
            this.numTXBufferSize.TabIndex = 1;
            this.numTXBufferSize.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // numRXBufferSize
            // 
            this.numRXBufferSize.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.ep_Errors.SetIconAlignment(this.numRXBufferSize, System.Windows.Forms.ErrorIconAlignment.MiddleLeft);
            this.numRXBufferSize.Location = new System.Drawing.Point(183, 17);
            this.numRXBufferSize.Maximum = new decimal(new int[] {
            255,
            0,
            0,
            0});
            this.numRXBufferSize.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numRXBufferSize.Name = "numRXBufferSize";
            this.numRXBufferSize.Size = new System.Drawing.Size(231, 20);
            this.numRXBufferSize.TabIndex = 0;
            this.numRXBufferSize.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // groupBox1
            // 
            this.groupBox1.AutoSize = true;
            this.groupBox1.Controls.Add(this.chbxIntOnRXFull);
            this.groupBox1.Controls.Add(this.chbxEnableRXInternalInterrupt);
            this.groupBox1.Controls.Add(this.groupBox2);
            this.groupBox1.Controls.Add(this.chbxEnableTXInternalInterrupt);
            this.groupBox1.Controls.Add(this.chbxIntOnRXNotEmpty);
            this.groupBox1.Controls.Add(this.chbxIntOnByteComplete);
            this.groupBox1.Controls.Add(this.chbxIntOnRXEmpty);
            this.groupBox1.Controls.Add(this.chbxIntOnRXOverrun);
            this.groupBox1.Controls.Add(this.chbxIntOnSPIDone);
            this.groupBox1.Controls.Add(this.chbxIntOnTXNotFull);
            this.groupBox1.Controls.Add(this.chbxIntOnTXEmpty);
            this.groupBox1.Dock = System.Windows.Forms.DockStyle.Top;
            this.groupBox1.ForeColor = System.Drawing.SystemColors.ControlText;
            this.groupBox1.Location = new System.Drawing.Point(0, 128);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(438, 157);
            this.groupBox1.TabIndex = 2;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Interrupts:";
            // 
            // chbxIntOnRXFull
            // 
            this.chbxIntOnRXFull.AutoSize = true;
            this.chbxIntOnRXFull.Location = new System.Drawing.Point(237, 121);
            this.chbxIntOnRXFull.Name = "chbxIntOnRXFull";
            this.chbxIntOnRXFull.Size = new System.Drawing.Size(143, 17);
            this.chbxIntOnRXFull.TabIndex = 9;
            this.chbxIntOnRXFull.Text = "Interrupt On Rx FIFO Full";
            this.chbxIntOnRXFull.UseVisualStyleBackColor = true;
            this.chbxIntOnRXFull.CheckedChanged += new System.EventHandler(this.chbxIntOnRXFull_CheckedChanged);
            // 
            // chbxEnableRXInternalInterrupt
            // 
            this.chbxEnableRXInternalInterrupt.AutoSize = true;
            this.chbxEnableRXInternalInterrupt.Location = new System.Drawing.Point(237, 21);
            this.chbxEnableRXInternalInterrupt.Name = "chbxEnableRXInternalInterrupt";
            this.chbxEnableRXInternalInterrupt.Size = new System.Drawing.Size(155, 17);
            this.chbxEnableRXInternalInterrupt.TabIndex = 5;
            this.chbxEnableRXInternalInterrupt.Text = "Enable Rx Internal Interrupt";
            this.chbxEnableRXInternalInterrupt.UseVisualStyleBackColor = true;
            this.chbxEnableRXInternalInterrupt.CheckedChanged += new System.EventHandler(this.chbxEnableRXInternalInterrupt_CheckedChanged);
            // 
            // groupBox2
            // 
            this.groupBox2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.groupBox2.Location = new System.Drawing.Point(6, 44);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(426, 2);
            this.groupBox2.TabIndex = 64;
            this.groupBox2.TabStop = false;
            // 
            // chbxEnableTXInternalInterrupt
            // 
            this.chbxEnableTXInternalInterrupt.AutoSize = true;
            this.chbxEnableTXInternalInterrupt.Location = new System.Drawing.Point(8, 21);
            this.chbxEnableTXInternalInterrupt.Name = "chbxEnableTXInternalInterrupt";
            this.chbxEnableTXInternalInterrupt.Size = new System.Drawing.Size(154, 17);
            this.chbxEnableTXInternalInterrupt.TabIndex = 0;
            this.chbxEnableTXInternalInterrupt.Text = "Enable Tx Internal Interrupt";
            this.chbxEnableTXInternalInterrupt.UseVisualStyleBackColor = true;
            this.chbxEnableTXInternalInterrupt.CheckedChanged += new System.EventHandler(this.chbxEnableTXInternalInterrupt_CheckedChanged);
            // 
            // chbxIntOnRXNotEmpty
            // 
            this.chbxIntOnRXNotEmpty.AutoSize = true;
            this.chbxIntOnRXNotEmpty.Location = new System.Drawing.Point(237, 75);
            this.chbxIntOnRXNotEmpty.Name = "chbxIntOnRXNotEmpty";
            this.chbxIntOnRXNotEmpty.Size = new System.Drawing.Size(176, 17);
            this.chbxIntOnRXNotEmpty.TabIndex = 7;
            this.chbxIntOnRXNotEmpty.Text = "Interrupt On Rx FIFO Not Empty";
            this.chbxIntOnRXNotEmpty.UseVisualStyleBackColor = true;
            this.chbxIntOnRXNotEmpty.CheckedChanged += new System.EventHandler(this.chbxIntOnRXNotEmpty_CheckedChanged);
            // 
            // chbxIntOnByteComplete
            // 
            this.chbxIntOnByteComplete.AutoSize = true;
            this.chbxIntOnByteComplete.Location = new System.Drawing.Point(8, 121);
            this.chbxIntOnByteComplete.Name = "chbxIntOnByteComplete";
            this.chbxIntOnByteComplete.Size = new System.Drawing.Size(226, 17);
            this.chbxIntOnByteComplete.TabIndex = 4;
            this.chbxIntOnByteComplete.Text = "Interrupt On Byte/Word Transfer Complete";
            this.chbxIntOnByteComplete.UseVisualStyleBackColor = true;
            this.chbxIntOnByteComplete.CheckedChanged += new System.EventHandler(this.chbxIntOnByteComplete_CheckedChanged);
            // 
            // chbxIntOnRXEmpty
            // 
            this.chbxIntOnRXEmpty.AutoSize = true;
            this.chbxIntOnRXEmpty.Location = new System.Drawing.Point(237, 52);
            this.chbxIntOnRXEmpty.Name = "chbxIntOnRXEmpty";
            this.chbxIntOnRXEmpty.Size = new System.Drawing.Size(156, 17);
            this.chbxIntOnRXEmpty.TabIndex = 6;
            this.chbxIntOnRXEmpty.Text = "Interrupt On Rx FIFO Empty";
            this.chbxIntOnRXEmpty.UseVisualStyleBackColor = true;
            this.chbxIntOnRXEmpty.CheckedChanged += new System.EventHandler(this.chbxIntOnRXEmpty_CheckedChanged);
            // 
            // chbxIntOnRXOverrun
            // 
            this.chbxIntOnRXOverrun.AutoSize = true;
            this.chbxIntOnRXOverrun.Location = new System.Drawing.Point(237, 98);
            this.chbxIntOnRXOverrun.Name = "chbxIntOnRXOverrun";
            this.chbxIntOnRXOverrun.Size = new System.Drawing.Size(165, 17);
            this.chbxIntOnRXOverrun.TabIndex = 8;
            this.chbxIntOnRXOverrun.Text = "Interrupt On Rx FIFO Overrun";
            this.chbxIntOnRXOverrun.UseVisualStyleBackColor = true;
            this.chbxIntOnRXOverrun.CheckedChanged += new System.EventHandler(this.chbxIntOnRXOverrun_CheckedChanged);
            // 
            // chbxIntOnSPIDone
            // 
            this.chbxIntOnSPIDone.AutoSize = true;
            this.chbxIntOnSPIDone.Location = new System.Drawing.Point(8, 52);
            this.chbxIntOnSPIDone.Name = "chbxIntOnSPIDone";
            this.chbxIntOnSPIDone.Size = new System.Drawing.Size(131, 17);
            this.chbxIntOnSPIDone.TabIndex = 1;
            this.chbxIntOnSPIDone.Text = "Interrupt On SPI Done";
            this.chbxIntOnSPIDone.UseVisualStyleBackColor = true;
            this.chbxIntOnSPIDone.CheckedChanged += new System.EventHandler(this.chbxIntOnSPIDone_CheckedChanged);
            // 
            // chbxIntOnTXNotFull
            // 
            this.chbxIntOnTXNotFull.AutoSize = true;
            this.chbxIntOnTXNotFull.Location = new System.Drawing.Point(8, 75);
            this.chbxIntOnTXNotFull.Name = "chbxIntOnTXNotFull";
            this.chbxIntOnTXNotFull.Size = new System.Drawing.Size(162, 17);
            this.chbxIntOnTXNotFull.TabIndex = 2;
            this.chbxIntOnTXNotFull.Text = "Interrupt On Tx FIFO Not Full";
            this.chbxIntOnTXNotFull.UseVisualStyleBackColor = true;
            this.chbxIntOnTXNotFull.CheckedChanged += new System.EventHandler(this.chbxIntOnTXNotFull_CheckedChanged);
            // 
            // chbxIntOnTXEmpty
            // 
            this.chbxIntOnTXEmpty.AutoSize = true;
            this.chbxIntOnTXEmpty.Location = new System.Drawing.Point(8, 98);
            this.chbxIntOnTXEmpty.Name = "chbxIntOnTXEmpty";
            this.chbxIntOnTXEmpty.Size = new System.Drawing.Size(155, 17);
            this.chbxIntOnTXEmpty.TabIndex = 3;
            this.chbxIntOnTXEmpty.Text = "Interrupt On Tx FIFO Empty";
            this.chbxIntOnTXEmpty.UseVisualStyleBackColor = true;
            this.chbxIntOnTXEmpty.CheckedChanged += new System.EventHandler(this.chbxIntOnTXEmpty_CheckedChanged);
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.chbxFixedPlacement);
            this.groupBox4.Controls.Add(this.chbxMultiSlaveEnable);
            this.groupBox4.Dock = System.Windows.Forms.DockStyle.Top;
            this.groupBox4.Location = new System.Drawing.Point(0, 285);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(438, 69);
            this.groupBox4.TabIndex = 3;
            this.groupBox4.TabStop = false;
            // 
            // chbxFixedPlacement
            // 
            this.chbxFixedPlacement.AutoSize = true;
            this.chbxFixedPlacement.Location = new System.Drawing.Point(8, 42);
            this.chbxFixedPlacement.Name = "chbxFixedPlacement";
            this.chbxFixedPlacement.Size = new System.Drawing.Size(140, 17);
            this.chbxFixedPlacement.TabIndex = 1;
            this.chbxFixedPlacement.Text = "Enable Fixed Placement";
            this.chbxFixedPlacement.UseVisualStyleBackColor = true;
            this.chbxFixedPlacement.CheckedChanged += new System.EventHandler(this.chbxFixedPlacement_CheckedChanged);
            // 
            // chbxMultiSlaveEnable
            // 
            this.chbxMultiSlaveEnable.AutoSize = true;
            this.chbxMultiSlaveEnable.Location = new System.Drawing.Point(8, 19);
            this.chbxMultiSlaveEnable.Name = "chbxMultiSlaveEnable";
            this.chbxMultiSlaveEnable.Size = new System.Drawing.Size(143, 17);
            this.chbxMultiSlaveEnable.TabIndex = 0;
            this.chbxMultiSlaveEnable.Text = "Enable Multi-Slave mode";
            this.chbxMultiSlaveEnable.UseVisualStyleBackColor = true;
            this.chbxMultiSlaveEnable.CheckedChanged += new System.EventHandler(this.chbxMultiSlaveEnable_CheckedChanged);
            // 
            // gbClocks
            // 
            this.gbClocks.Controls.Add(this.rbExternalClock);
            this.gbClocks.Controls.Add(this.rbInternalClock);
            this.gbClocks.Dock = System.Windows.Forms.DockStyle.Top;
            this.gbClocks.ForeColor = System.Drawing.SystemColors.ControlText;
            this.gbClocks.Location = new System.Drawing.Point(0, 0);
            this.gbClocks.Margin = new System.Windows.Forms.Padding(2);
            this.gbClocks.Name = "gbClocks";
            this.gbClocks.Padding = new System.Windows.Forms.Padding(2);
            this.gbClocks.Size = new System.Drawing.Size(438, 51);
            this.gbClocks.TabIndex = 0;
            this.gbClocks.TabStop = false;
            this.gbClocks.Text = "Clock Selection:";
            // 
            // rbExternalClock
            // 
            this.rbExternalClock.AutoSize = true;
            this.rbExternalClock.Location = new System.Drawing.Point(138, 19);
            this.rbExternalClock.Margin = new System.Windows.Forms.Padding(2);
            this.rbExternalClock.Name = "rbExternalClock";
            this.rbExternalClock.Size = new System.Drawing.Size(93, 17);
            this.rbExternalClock.TabIndex = 1;
            this.rbExternalClock.Text = "External Clock";
            this.rbExternalClock.UseVisualStyleBackColor = true;
            this.rbExternalClock.CheckedChanged += new System.EventHandler(this.rbExternalClock_CheckedChanged);
            // 
            // rbInternalClock
            // 
            this.rbInternalClock.AutoSize = true;
            this.rbInternalClock.Location = new System.Drawing.Point(13, 19);
            this.rbInternalClock.Margin = new System.Windows.Forms.Padding(2);
            this.rbInternalClock.Name = "rbInternalClock";
            this.rbInternalClock.Size = new System.Drawing.Size(90, 17);
            this.rbInternalClock.TabIndex = 0;
            this.rbInternalClock.Text = "Internal Clock";
            this.rbInternalClock.UseVisualStyleBackColor = true;
            this.rbInternalClock.CheckedChanged += new System.EventHandler(this.rbInternalClock_CheckedChanged);
            // 
            // gbBufferSizes
            // 
            this.gbBufferSizes.Controls.Add(this.numTXBufferSize);
            this.gbBufferSizes.Controls.Add(this.numRXBufferSize);
            this.gbBufferSizes.Controls.Add(this.lblTXBufferSize);
            this.gbBufferSizes.Controls.Add(this.lblRXBufferSize);
            this.gbBufferSizes.Dock = System.Windows.Forms.DockStyle.Top;
            this.gbBufferSizes.ForeColor = System.Drawing.SystemColors.ControlText;
            this.gbBufferSizes.Location = new System.Drawing.Point(0, 51);
            this.gbBufferSizes.Name = "gbBufferSizes";
            this.gbBufferSizes.Size = new System.Drawing.Size(438, 77);
            this.gbBufferSizes.TabIndex = 1;
            this.gbBufferSizes.TabStop = false;
            this.gbBufferSizes.Text = "Buffer Sizes:";
            // 
            // lblTXBufferSize
            // 
            this.lblTXBufferSize.AutoSize = true;
            this.lblTXBufferSize.Location = new System.Drawing.Point(28, 46);
            this.lblTXBufferSize.Name = "lblTXBufferSize";
            this.lblTXBufferSize.Size = new System.Drawing.Size(136, 13);
            this.lblTXBufferSize.TabIndex = 147;
            this.lblTXBufferSize.Text = "Tx Buffer Size (n-bit words):";
            this.lblTXBufferSize.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // lblRXBufferSize
            // 
            this.lblRXBufferSize.AutoSize = true;
            this.lblRXBufferSize.Location = new System.Drawing.Point(27, 21);
            this.lblRXBufferSize.Name = "lblRXBufferSize";
            this.lblRXBufferSize.Size = new System.Drawing.Size(137, 13);
            this.lblRXBufferSize.TabIndex = 144;
            this.lblRXBufferSize.Text = "Rx Buffer Size (n-bit words):";
            this.lblRXBufferSize.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // CySPISControlAdv
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoScroll = true;
            this.Controls.Add(this.groupBox4);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.gbBufferSizes);
            this.Controls.Add(this.gbClocks);
            this.Name = "CySPISControlAdv";
            this.Size = new System.Drawing.Size(438, 355);
            this.Load += new System.EventHandler(this.CySPISControlAdv_Load);
            this.VisibleChanged += new System.EventHandler(this.CySPISControlAdv_VisibleChanged);
            ((System.ComponentModel.ISupportInitialize)(this.ep_Errors)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numTXBufferSize)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numRXBufferSize)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.gbClocks.ResumeLayout(false);
            this.gbClocks.PerformLayout();
            this.gbBufferSizes.ResumeLayout(false);
            this.gbBufferSizes.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ErrorProvider ep_Errors;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.CheckBox chbxIntOnRXFull;
        private System.Windows.Forms.CheckBox chbxEnableRXInternalInterrupt;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.CheckBox chbxEnableTXInternalInterrupt;
        private System.Windows.Forms.CheckBox chbxIntOnRXNotEmpty;
        private System.Windows.Forms.CheckBox chbxIntOnByteComplete;
        private System.Windows.Forms.CheckBox chbxIntOnRXEmpty;
        private System.Windows.Forms.CheckBox chbxIntOnRXOverrun;
        private System.Windows.Forms.CheckBox chbxIntOnSPIDone;
        private System.Windows.Forms.CheckBox chbxIntOnTXNotFull;
        private System.Windows.Forms.CheckBox chbxIntOnTXEmpty;
        private System.Windows.Forms.GroupBox gbBufferSizes;
        private System.Windows.Forms.NumericUpDown numTXBufferSize;
        private System.Windows.Forms.NumericUpDown numRXBufferSize;
        private System.Windows.Forms.Label lblTXBufferSize;
        private System.Windows.Forms.Label lblRXBufferSize;
        private System.Windows.Forms.GroupBox gbClocks;
        private System.Windows.Forms.RadioButton rbExternalClock;
        private System.Windows.Forms.RadioButton rbInternalClock;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.CheckBox chbxMultiSlaveEnable;
        private System.Windows.Forms.CheckBox chbxFixedPlacement;
    }
}

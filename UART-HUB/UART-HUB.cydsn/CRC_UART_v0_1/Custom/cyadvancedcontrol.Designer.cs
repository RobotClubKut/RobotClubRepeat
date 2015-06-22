namespace CRC_UART_v0_1
{
    partial class CyAdvancedControl
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(CyAdvancedControl));
            this.groupBoxTimeMultiplexing = new System.Windows.Forms.GroupBox();
            this.labelDisable = new System.Windows.Forms.Label();
            this.labelEnable = new System.Windows.Forms.Label();
            this.radioButtonDisabled = new System.Windows.Forms.RadioButton();
            this.radioButtonEnabled = new System.Windows.Forms.RadioButton();
            this.errorProvider = new System.Windows.Forms.ErrorProvider(this.components);
            this.groupBoxTimeMultiplexing.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).BeginInit();
            this.SuspendLayout();
            // 
            // groupBoxTimeMultiplexing
            // 
            resources.ApplyResources(this.groupBoxTimeMultiplexing, "groupBoxTimeMultiplexing");
            this.groupBoxTimeMultiplexing.Controls.Add(this.labelDisable);
            this.groupBoxTimeMultiplexing.Controls.Add(this.labelEnable);
            this.groupBoxTimeMultiplexing.Controls.Add(this.radioButtonDisabled);
            this.groupBoxTimeMultiplexing.Controls.Add(this.radioButtonEnabled);
            this.groupBoxTimeMultiplexing.ForeColor = System.Drawing.SystemColors.ControlText;
            this.groupBoxTimeMultiplexing.Name = "groupBoxTimeMultiplexing";
            this.groupBoxTimeMultiplexing.TabStop = false;
            // 
            // labelDisable
            // 
            resources.ApplyResources(this.labelDisable, "labelDisable");
            this.labelDisable.Name = "labelDisable";
            // 
            // labelEnable
            // 
            resources.ApplyResources(this.labelEnable, "labelEnable");
            this.labelEnable.Name = "labelEnable";
            // 
            // radioButtonDisabled
            // 
            resources.ApplyResources(this.radioButtonDisabled, "radioButtonDisabled");
            this.radioButtonDisabled.ForeColor = System.Drawing.SystemColors.ControlText;
            this.radioButtonDisabled.Name = "radioButtonDisabled";
            this.radioButtonDisabled.UseVisualStyleBackColor = true;
            this.radioButtonDisabled.CheckedChanged += new System.EventHandler(this.radioButtonEnabled_CheckedChanged);
            // 
            // radioButtonEnabled
            // 
            resources.ApplyResources(this.radioButtonEnabled, "radioButtonEnabled");
            this.radioButtonEnabled.Checked = true;
            this.radioButtonEnabled.ForeColor = System.Drawing.SystemColors.ControlText;
            this.radioButtonEnabled.Name = "radioButtonEnabled";
            this.radioButtonEnabled.TabStop = true;
            this.radioButtonEnabled.UseVisualStyleBackColor = true;
            this.radioButtonEnabled.CheckedChanged += new System.EventHandler(this.radioButtonEnabled_CheckedChanged);
            // 
            // errorProvider
            // 
            this.errorProvider.BlinkStyle = System.Windows.Forms.ErrorBlinkStyle.NeverBlink;
            this.errorProvider.ContainerControl = this;
            // 
            // CyAdvancedControl
            // 
            resources.ApplyResources(this, "$this");
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.groupBoxTimeMultiplexing);
            this.Name = "CyAdvancedControl";
            this.VisibleChanged += new System.EventHandler(this.CyAdvancedControl_VisibleChanged);
            this.SizeChanged += new System.EventHandler(this.CyAdvancedControl_SizeChanged);
            this.groupBoxTimeMultiplexing.ResumeLayout(false);
            this.groupBoxTimeMultiplexing.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBoxTimeMultiplexing;
        private System.Windows.Forms.RadioButton radioButtonDisabled;
        private System.Windows.Forms.RadioButton radioButtonEnabled;
        private System.Windows.Forms.ErrorProvider errorProvider;
        private System.Windows.Forms.Label labelEnable;
        private System.Windows.Forms.Label labelDisable;
    }
}

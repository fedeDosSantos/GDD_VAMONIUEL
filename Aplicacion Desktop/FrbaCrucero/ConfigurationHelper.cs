﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FrbaCrucero
{
    class ConfigurationHelper
    {
        public static string ConnectionString { get { return Properties.Settings.Default.ConnectionString; } }
        public static DateTime fechaActual { get { return Properties.Settings.Default.MyDate; } }
    }
}

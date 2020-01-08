using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ManagerBLLibrary;
using ReleaseManagementProjectLibrary;
using System.Web.Http.Cors;

namespace ReleaseManagementProject.Controllers
{
  [EnableCors("http://localhost:4200","*","GET,POST,PUT")]
    public class AdminDataController : ApiController
    {
    ManagerBL bl = new ManagerBL();
    public ReleaseManagementModel Get(string empId)
    {
      try
      {
        return bl.GetEmployeeData(empId)
      }
      catch(Exception e)
      {
        return new ReleaseManagementModel();
      }
    }
    }
}

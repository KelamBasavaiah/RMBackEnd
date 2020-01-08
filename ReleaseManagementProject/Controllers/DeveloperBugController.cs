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
    [EnableCors("http://localhost:4200", "*", "GET,POST,PUT,DELETE")]

    public class DeveloperBugController : ApiController
    {
        ManagerBL bl = new ManagerBL();

        public List<ReleaseManagementModel> Get(string username)
        {
            try
            {
                return bl.GetAllModuleNamesAndBugNames(username);

            }
            catch(Exception e)
            {
                return new List<ReleaseManagementModel>();
            }


        }
        public List<ReleaseManagementModel> Get(string moduleid,string value)
        {
            try
            {
                return bl.GetAllModuleNamesAndModuleDescription(moduleid);

            }
            catch(Exception e)
            {
                return new List<ReleaseManagementModel>();
            }

        }
        // PUT: api/ModuleNameAndDescription/5
        public bool Put(string value, [FromBody]string value1)
        {
            try
            {
                return bl.UpdateBugStatusToTester(value);

            }
            catch(Exception e)
            {
                return false;
            }
        }

    }
}

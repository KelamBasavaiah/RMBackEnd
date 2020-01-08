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

    public class TesterBugController : ApiController
    {
        ManagerBL bl = new ManagerBL();

        public  List<ReleaseManagementModel> Get(string username)
        {
            try
            {
                return bl.bugFixedModuleData(username);

            }
            catch(Exception e)
            {
                return new List<ReleaseManagementModel>();
            }
        }
        public ReleaseManagementModel Post([FromBody] ReleaseManagementModel tcb)
        {
            try
            {
                if (tcb != null)
                    return bl.testerCreateBug(tcb);
                else
                    return new ReleaseManagementModel();

            }
            catch(Exception e)
            {
                return new ReleaseManagementModel();
            }
            
        }
        public ReleaseManagementModel delete(string moduleid)
        {
            try
            {
                return bl.GetBugFixedModule(moduleid);

            }
            catch(Exception e)
            {
                return new ReleaseManagementModel();
            }
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ManagerBLLibrary;
using ReleaseManagementProjectLibrary;
using System.Web.Http.Cors;
using ReleaseManagementProject.Models;
namespace ReleaseManagementProject.Controllers
{
    [EnableCors("http://localhost:4200", "*", "GET,POST,PUT","DELETE")]
    public class ValuesController : ApiController
    {
        ManagerBL bl = new ManagerBL();
        //GET api/values
        

        public List<ReleaseManagementModel> Get(string username)
         {
            try
            {
                return bl.GetAllAssignedModules(username);
            }
            catch(Exception e)
            {
                return new List<ReleaseManagementModel>();
            }
        }


        public List<ReleaseManagementModel> Get()
        {
            try{
            return bl.GetEmployeesToAssign();

            }
            catch(Exception e)
            {
                return new List<ReleaseManagementModel>();
            }
        }

        // POST api/values
        public bool Post([FromBody]ReleaseManagementModel value)
        {
            try
            {
                return bl.AssignModuleToTester(value);

            }
            catch(Exception e)
            {
                return false;
            }

        }

        // PUT api/values/5
        //public bool Put(string modulename,string module)
        //{
        //    return bl.UpdateModuleStatusAfterTesting(modulename);
        //}
        public bool Put(string modulename,[FromBody]ReleaseManagementModel values)
        {
            try
            {
                return bl.UpdateModuleStatusAfterTesting(values.ModuleId);

            }
            catch(Exception e)
            {
                return false;
            }
        }
        public bool Delete(string projectId)
        {
            try
            {
                return bl.UpdateCompletedModuleStatus(projectId);

            }
            catch(Exception e)
            {
                return false;
            }
        }
        // DELETE api/values/5
       
    }
}

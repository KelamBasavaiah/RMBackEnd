﻿using System;
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
    [EnableCors("http://localhost:4200", "*", "GET,POST,PUT", "DELETE")]

    public class AdminController : ApiController
    {
        ManagerBL bl = new ManagerBL();
        [SkipMyGlobalActionFilter]
        public List<ReleaseManagementModel> Get()
        {
            try
            {
                return bl.GetAllEmps();

            }
            catch
            {
                return new List<ReleaseManagementModel>();
            }

        }

        // GET api/values/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        [SkipMyGlobalActionFilter]
        public bool Post([FromBody]ReleaseManagementModel[] value)
        {
            try
            {
                if (bl.InsertEmpDetails(value))
                    return true;
                else
                    return false;

            }
            catch(Exception e)
            {
                return false;
            }

        }

        // PUT api/values/5
        [SkipMyGlobalActionFilter]
        public bool Put([FromBody]ReleaseManagementModel admin)
        {
            try
            {
                bool update = false;
                update = bl.UpdateEmpDetails(admin);
                return update;

            }
            catch(Exception e)
            {
                return false;
            }

        }

    }
}

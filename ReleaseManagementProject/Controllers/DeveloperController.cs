using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using ManagerBLLibrary;
using ReleaseManagementProjectLibrary;
using System.Web.Http.Cors;
using System.Net.Mail;

namespace ReleaseManagementProject.Controllers
{
    [EnableCors("http://localhost:4200", "*", "GET,POST,PUT,DELETE")]

    public class DeveloperController : ApiController
    {
        ManagerBL bl = new ManagerBL();

        public List<ReleaseManagementModel> Get(string username)
        {
            try
            {
                return bl.GetAllProjectsForDeveloperFromManager(username);

            }
            catch(Exception e)
            {
                return new List<ReleaseManagementModel>();
            }


        }
        public List<ReleaseManagementModel> Get(string projectId,string username)
        {
            try
            {
                return bl.GetAllModulesForDeveloper(projectId, username);

            }
            catch(Exception e)
            {
                return new List<ReleaseManagementModel>();
            }
        }
        public bool Put(string value,ReleaseManagementModel manager)
        {
            try
            {
                bool updated = false;
                string email = bl.GetEmail(manager.Username);
                updated = bl.UpdateModuleStatustoManager(value);
                if (updated)
                {
                    MailMessage mail = new MailMessage();
                    SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");
                    mail.From = new MailAddress("divhyadarsh429@gmail.com");
                    mail.To.Add(email);
                    mail.Subject = "Module Status Update To Manager";
                    mail.Body = manager.Username + " " + "Modules Completed Successfully";
                    SmtpServer.Port = 587;
                    SmtpServer.Credentials = new System.Net.NetworkCredential("divhyadarsh429@gmail.com", "dbinfosys29");
                    SmtpServer.EnableSsl = true;
                    SmtpServer.Send(mail);
                }
                return updated;

            }
            catch(Exception e)
            {
                return false;
            }

        }




    }

}


using System.Collections.Generic;
using System.Configuration;
using System.ServiceModel.Configuration;
using System.Web.Http;

namespace TokenizableWebAPI.Controllers
{
    public class ValuesController : ApiController
    {
        // GET api/values
        public IEnumerable<string> Get()
        {
            var environment = ConfigurationManager.AppSettings["environment"];
            var clientSection = (ClientSection)ConfigurationManager.GetSection("system.serviceModel/client");
            string address = "NOT AVAILABLE";
            for (int i = 0; i < clientSection.Endpoints.Count; i++)
            {
                if (clientSection.Endpoints[i].Name == "DomainServiceEndpoint")
                    address = clientSection.Endpoints[i].Address.ToString();
            }
            return new string[] { $"environment: {environment}", $"DomainServiceEndpoint address: {address}" };
        }

        // GET api/values/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        public void Delete(int id)
        {
        }
    }
}

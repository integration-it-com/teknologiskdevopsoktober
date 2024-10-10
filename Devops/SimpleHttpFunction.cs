using System.Net;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace teknologisk.devops
{
    public class SimpleHttpFunction
    {
        private readonly ILogger _logger;

        public SimpleHttpFunction(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<SimpleHttpFunction>();
        }

        [Function("SimpleHttpFunction")]
        public HttpResponseData Run([HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request on the TI course.");

            var response = req.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");

            response.WriteString("Velkommen til Teknologisk Kursus!!!!!! Den 9. oktober.... Det er ved at lakke imod enden.");

            return response;
        }
    }
}

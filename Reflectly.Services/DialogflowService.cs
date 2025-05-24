using Google.Apis.Auth.OAuth2;
using Google.Cloud.Dialogflow.V2;
using Grpc.Auth;
using Grpc.Core;
using System;
using System.Threading.Tasks;
using Environment = System.Environment;
using Reflectly.Model;

namespace Reflectly.Services
{
	public class DialogflowService
	{
		private readonly SessionsClient _client;

		public DialogflowService()
		{
			// Get the path to your JSON credentials file from the environment variable
			string credentialPath = Path.Combine(AppContext.BaseDirectory, "Secrets", "dialog_flow_auth.json");

			if (string.IsNullOrEmpty(credentialPath))
				throw new Exception("environment variable is not set.");

			// Use SessionsClientBuilder to build the client with the credentials
			var builder = new SessionsClientBuilder
			{
				CredentialsPath = credentialPath
				// Endpoint defaults to dialogflow.googleapis.com:443, no need to set manually
			};

			_client = builder.Build();
		}

		public DetectIntentResponse DetectIntent(string sessionId, string text, string languageCode = "en-US")
		{
			var sessionName = new SessionName("reflectly-458009", sessionId);

			var queryInput = new QueryInput
			{
				Text = new TextInput
				{
					Text = text,
					LanguageCode = languageCode
				}
			};

			return _client.DetectIntent(sessionName, queryInput);
		}


		public async Task<string> DetectIntentAsync(string sessionId, string text, string languageCode = "en-US")
		{
			var sessionName = SessionName.FromProjectSession("reflectly-458009", sessionId);

			var queryInput = new QueryInput
			{
				Text = new TextInput
				{
					Text = text,
					LanguageCode = languageCode,
				}
			};

			var response = await _client.DetectIntentAsync(sessionName, queryInput);
			return response.QueryResult.FulfillmentText;
		}

	}
}

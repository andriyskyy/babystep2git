provider "aws" {
   profile    = "default"
   region     = "us-east-2"
 }
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.datadoghq.eu/"
}

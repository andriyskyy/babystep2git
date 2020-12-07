provider "aws" {
   profile    = default
   region     = var.region
 }
provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.api_url
}

locals {
  # Path to the YAML file
  resource_path = "${abspath(path.root)}/config/"

  # Decode the YAML file directly using simple string concatenation
  tags_file = yamldecode(file("${local.resource_path}/tags.yaml"))

  # Access the "tags" key from the parsed YAML
  tags = local.tags_file["tags"]


  storage_file = yamldecode((file("${local.resource_path}/storage.yaml")))
  storage = local.storage_file["config"]

}
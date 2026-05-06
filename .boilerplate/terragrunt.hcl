locals {
  local_vars  = yamldecode(file("./inputs.yaml"))
  spoke_vars  = yamldecode(file(find_in_parent_folders("spoke-inputs.yaml")))
  region_vars = yamldecode(file(find_in_parent_folders("region-inputs.yaml")))
  env_vars    = yamldecode(file(find_in_parent_folders("env-inputs.yaml")))
  global_vars = yamldecode(file(find_in_parent_folders("global-inputs.yaml")))

  local_tags  = jsondecode(file("./local-tags.json"))
  spoke_tags  = jsondecode(file(find_in_parent_folders("spoke-tags.json")))
  region_tags = jsondecode(file(find_in_parent_folders("region-tags.json")))
  env_tags    = jsondecode(file(find_in_parent_folders("env-tags.json")))
  global_tags = jsondecode(file(find_in_parent_folders("global-tags.json")))

  tags = merge(
    local.global_tags,
    local.env_tags,
    local.region_tags,
    local.spoke_tags,
    local.local_tags
  )
}

include "root" {
  path = find_in_parent_folders("{{ .RootFileName }}")
}
{{ if .vpc_enabled }}
dependency "vpc" {
  config_path = "{{ .vpc_module_path }}"
  #skip_outputs = true
  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate", "destroy"]
  mock_outputs = {
    ssh_admin_security_group_id = "sg-12345678901234"
    vpn_accesses = tolist([
      "1.2.3.4/32",
      "5.6.7.8/32",
    ])
    intra_subnets = [
      "subnet-01234567890123456",
      "subnet-01234567890123457",
      "subnet-01234567890123458",
    ]
    private_subnets = [
      "subnet-01234567890123456",
      "subnet-01234567890123457",
      "subnet-01234567890123458",
    ]
    vpc_id                      = "vpc-12345678901234"
    vpc_cidr_block = "1.0.0.0/8"
    database_route_table_ids = [
    ]
  }
}
{{ end }}
terraform {
  source = "{{ .sourceUrl }}"
}

inputs = {
  is_hub     = {{ .is_hub }}
  org        = local.env_vars.org
  spoke_def  = local.spoke_vars.spoke
  {{- range .requiredVariables }}
  {{- if and $.vpc_enabled (eq .Name "vpc") }}
  vpc = {
    vpc_id                      = dependency.vpc.outputs.vpc_id
    private_subnets             = dependency.vpc.outputs.{{ $.subnet_source }}_subnets
    ssh_admin_security_group_id = dependency.vpc.outputs.ssh_admin_security_group_id
    local_network_cidrs         = try(local.local_vars.vpc.local_network_cidrs, [])
    vpn_accesses                = dependency.vpc.outputs.vpn_accesses
  }
  {{- else if ne .Name "org" }}
  {{ .Name }} = local.local_vars.{{ .Name }}
  {{- end }}
  {{- end }}
  {{- range .optionalVariables }}
  {{- if not (eq .Name "extra_tags" "is_hub" "spoke_def" "org") }}
  {{- if and $.vpc_enabled (eq .Name "vpc") }}
  vpc = {
    vpc_id                      = dependency.vpc.outputs.vpc_id
    private_subnets             = dependency.vpc.outputs.{{ $.subnet_source }}_subnets
    ssh_admin_security_group_id = dependency.vpc.outputs.ssh_admin_security_group_id
    local_network_cidrs         = try(local.local_vars.vpc.local_network_cidrs, [])
    vpn_accesses                = dependency.vpc.outputs.vpn_accesses
  }
  {{- else if eq .Name "irsa" }}
  irsa = try(local.local_vars.irsa, local.local_vars.irsa_configuration, {})
  {{- else if eq .Name "public_api_server" }}
  public_api_server = try(local.local_vars.public_api_server, local.local_vars.api_server.public, {{ .DefaultValue }})
  {{- else if eq .Name "private_api_server" }}
  private_api_server = try(local.local_vars.private_api_server, local.local_vars.api_server.private, {{ .DefaultValue }})
  {{- else if eq .Name "node_volume_size" }}
  node_volume_size = try(local.local_vars.node_volume_size, local.local_vars.default_node_disk_size, local.local_vars.default_node.disk.size, {{ .DefaultValue }})
  {{- else if eq .Name "node_volume_type" }}
  node_volume_type = try(local.local_vars.node_volume_type, local.local_vars.default_node_disk_type, local.local_vars.default_node.disk.type, {{ .DefaultValue }})
  {{- else }}
  {{ .Name }} = try(local.local_vars.{{ .Name }}, {{ .DefaultValue }})
  {{- end }}
  {{- end }}
  {{- end }}
  extra_tags = local.tags
}
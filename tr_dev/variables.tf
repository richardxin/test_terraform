variable "instance_groups" {
  default = [
    {
      name           = "MasterInstanceGroup"
      instance_role  = "MASTER"
      instance_type  = "#INSTANCE_TYPE"
      instance_count = 1
    },
    {
      name           = "CoreInstanceGroup"
      instance_role  = "CORE"
      instance_type  = "#INSTANCE_TYPE"
      instance_count = #INSTANCE_COUNT
      bid_price      = "0.30"
    },
  ]

  type = "list"
}

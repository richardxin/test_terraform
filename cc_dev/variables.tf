variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "instance_groups" {
  default = [
    {
      name           = "MasterInstanceGroup"
      instance_role  = "MASTER"
      instance_type  = "#INSTANCE_TYPE_MASTER"
      instance_count = 1
    },
    {
      name           = "CoreInstanceGroup"
      instance_role  = "CORE"
      instance_type  = "#INSTANCE_TYPE_CORE"
      instance_count = #INSTANCE_COUNT
      #BID_PRICE
      autoscaling_policy = <<EOF
            {
                "Constraints": {
                    "MinCapacity": #MinCapacity,
                    "MaxCapacity": #MaxCapacity
                },
                "Rules": [
                {
                    "Name": "ScaleOutMemoryPercentage",
                    "Description": "Scale out if YARNMemoryAvailablePercentage is less than 15",
                    "Action": {
                        "SimpleScalingPolicyConfiguration": {
                            "AdjustmentType": "CHANGE_IN_CAPACITY",
                            "ScalingAdjustment": 1,
                            "CoolDown": 300
                        }
                    },
                    "Trigger": {
                        "CloudWatchAlarmDefinition": {
                            "ComparisonOperator": "LESS_THAN",
                            "EvaluationPeriods": 1,
                            "MetricName": "YARNMemoryAvailablePercentage",
                            "Namespace": "AWS/ElasticMapReduce",
                            "Period": 300,
                            "Statistic": "AVERAGE",
                            "Threshold": 15.0,
                            "Unit": "PERCENT"
                        }
                    }
                }
                ]
            }
            EOF
    },
  ]
  type = "list"
}

variable "cc_dev_ec2_attributes" {
    default = [
    {
        subnet_id                         = "subnet-a93c6ede"
        emr_managed_master_security_group = "sg-13eca968"
        emr_managed_slave_security_group  = "sg-cce9acb7"
        additional_master_security_groups = "sg-f6166289"
        instance_profile                  = "svc-aws-emr-ec2-default"
    }
    ]
}

variable "tr_dev_ec2_attributes" {
    default = [
    {
        subnet_id                         = "subnet-28028a5f"
        emr_managed_master_security_group = "sg-aec499d5"
        emr_managed_slave_security_group  = "sg-72c59809"
        additional_master_security_groups = "sg-e317639c"
        instance_profile                  = "svc-aws-emr-ec2-default"
    }
    ]
}

variable "cc_dev" {
  type = "map"

  default = {
      service_role = "arn:aws:iam::509786517216:role/cl/svc/aws/svc-aws-emr-default"
      autoscaling_role = "arn:aws:iam::509786517216:role/cl/svc/aws/svc-aws-emr-autoscaling"
      log_uri = "s3://aws-logs-509786517216-us-west-2/elasticmapreduce/"
  }
}

variable "tr_dev" {
  type = "map"

  default = {
      service_role = "arn:aws:iam::369874303498:role/cl/svc/aws/svc-aws-emr"
      autoscaling_role = "arn:aws:iam::369874303498:role/cl/svc/aws/svc-aws-emr-autoscaling"
      log_uri = "s3://aws-logs-369874303498-us-west-2/elasticmapreduce/"
  }
}

resource "aws_emr_cluster" "emr-test-cluster" {
  name          = "richardx-test-terraform"
  release_label = "emr-5.12.0"
  applications  = ["Hadoop", "Hive", "Spark", "Zeppelin", "Livy"]

  termination_protection = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "subnet-28028a5f"
    emr_managed_master_security_group = "sg-aec499d5"
    emr_managed_slave_security_group  = "sg-72c59809"
    additional_master_security_groups = "sg-e317639c"
    instance_profile                  = "svc-aws-emr-ec2-default"
  }
  
  instance_group = "${var.instance_groups}"

  ebs_root_volume_size     = 100

  tags {
    application = "my-test-app"
    created_by = "Richard Xin"
  }
  
  service_role = "arn:aws:iam::369874303498:role/cl/svc/aws/svc-aws-emr-default"

  step {
    name="my-spark-program"
    action_on_failure = "TERMINATE_CLUSTER"
    hadoop_jar_step {
    jar="command-runner.jar"
    args = ["spark-submit", "--deploy-mode","cluster","--class", "org.apache.spark.examples.JavaWordCount","s3://deeplens-sagemaker-richardxin/test/original-spark-examples_2.11-2.4.0-SNAPSHOT.jar", "s3://deeplens-sagemaker-richardxin/test/README.md"]
    }
    # keep_job_flow_alive_when_no_steps = "off"
  }
  scale_down_behavior = "TERMINATE_AT_TASK_COMPLETION"
  log_uri = "s3://aws-logs-369874303498-us-west-2/elasticmapreduce/"
}

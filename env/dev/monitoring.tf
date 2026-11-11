# resource "aws_cloudwatch_log_group" "app_logs" {
#   name              = "/ecs/dev-app"
#   retention_in_days = 7

#   tags = {
#     Environment = "dev"
#     ManagedBy   = "Terraform"
#   }
# }

resource "aws_cloudwatch_dashboard" "infra_dashboard" {
  dashboard_name = "dev-infra-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", "dev-ecs-cluster", "ServiceName", "dev-app"],
            [".", "MemoryUtilization", ".", ".", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "dev-app (ECS on EC2) CPU & Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "dev-rds"],
            [".", "DatabaseConnections", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "RDS PostgreSQL CPU & Connection Pool"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "app_dashboard" {
  dashboard_name = "dev-application-health"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", module.alb.arn_suffix],
            [".", "TargetResponseTime", ".", "."]
          ]
          period = 60
          stat   = "Sum"
          region = "ap-south-1"
          title  = "ALB Request Volume & Latency"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_2XX_Count", "LoadBalancer", module.alb.arn_suffix],
            [".", "HTTPCode_Target_4XX_Count", ".", "."],
            [".", "HTTPCode_Target_5XX_Count", ".", "."]
          ]
          period = 60
          stat   = "Sum"
          region = "ap-south-1"
          title  = "Target HTTP Response Codes (2xx, 4xx, 5xx)"
        }
      }
    ]
  })
}
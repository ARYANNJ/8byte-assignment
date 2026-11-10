output "alb_arn"      { value = aws_lb.this.arn }
output "alb_dns_name" { value = aws_lb.this.dns_name }
output "alb_zone_id"  { value = aws_lb.this.zone_id }
output "sg_id"        { value = aws_security_group.alb.id }
output "listener_arn" {
  value = local.https_enabled ? aws_lb_listener.https[0].arn : aws_lb_listener.http.arn
}
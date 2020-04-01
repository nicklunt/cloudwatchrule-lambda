variable target_acid {
  default = "329035065473"
}

variable my_arn {
  default = "arn:aws:iam::329035065473:user/Nick.Lunt@version1.com"
}

variable rule_arn {
  default = "arn:aws:events:eu-west-2:329035065473:rule/nl-eventrule-backups"
}

variable function_arn {
  default = "arn:aws:lambda:eu-west-2:329035065473:function:nl-lecp_backup_volumes"
}
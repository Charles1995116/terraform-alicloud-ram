resource "alicloud_ram_user" "this" {
  count = "${var.create_user?1:0}"
  name  = "${var.name}"
  force = "${var.force_destroy}"
}

resource "alicloud_ram_login_profile" "this" {
  count     = "${var.create_user && var.create_ram_user_login_profile ? 1 : 0}"
  user_name = "${alicloud_ram_user.this.name}"
  password  = "${var.password}"
}

resource "alicloud_ram_access_key" "this" {
  count       = "${var.create_user && var.create_ram_access_key ? 1 : 0}"
  user_name   = "${alicloud_ram_user.this.name}"
  secret_file = "${var.secret_file}"
}

data "alicloud_ram_policies" "admin" {
  name_regex = "AdministratorAccess"
  type       = "System"
}

resource "alicloud_ram_user_policy_attachment" "attach" {
  policy_name = "${data.alicloud_ram_policies.admin.policies.0.name}"
  policy_type = "System"
  user_name   = "${alicloud_ram_user.this.name}"
}

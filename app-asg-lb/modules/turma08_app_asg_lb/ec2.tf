resource "aws_instance" "mongodb" {
  ami                         = data.aws_ami.app_ami.id
  instance_type               = lookup(var.instance_type, var.env)
  subnet_id                   = data.aws_subnet.app_subnet1.id
  associate_public_ip_address = false
  tags = {
    Name = format("%s-mongodb_server-%s", var.project, var.env)
  }
  key_name  = aws_key_pair.app_ssh_key.id
  user_data = data.template_file.mongodb_startup_script.rendered
}

resource "aws_key_pair" "app_ssh_key" {
  key_name   = format("%s-ssh-%s", var.project, var.env)
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfgOsP5x6G5oA5y/zoX+Mx/K5kDBQXptPNGcv45oPPE981MWGtHCdnLyIJEHLaTR9azj1M/mrwqF0VP0YugvpsLuJKQ6Ul3XLQ7NJ/wnA8TXoOJh/j5snBAxSfJE7opk7n0Vx/aACWZTxMgNhfaAHFdNSfTbKpWwwpr69KeCzmex6WW96V7rPKLWj4+Xo0GU2+zYx+Ob+f4OMC3MMs1jVeyCKGTe2ncY0J9jlb4HRAognGLSSc9Pv+p0MCAQGuQa6hIX3LjHYseqxyEtC15jlkKlGcD/5Oatk7bmwYkcLYqkhbpucaTW7zl2Clz22tcQou/PDcYEbXVsnzEIRl7jLeVf/uCtjc2mhZ06YMtaKFZWF1wIE42S54k83hzyzBNZVyc/VVD/J/Z5LtdPKfJNCLppYNYIqEY/lr/1Yeb6luahGIQ0vtnw5N3Vu+5NgtD6/ZVAypQAeXP9msLeRRd7OBwwwwYGEBNkpUqAJ01uKmymsqSBskIySwZg1M6hbhUGU= app-turma08"
}
resource "aws_iam_user" "terraform" {
  name = "terraform"
  path = "/system/"

  tags = {
    tag-key = "test"
  }
}

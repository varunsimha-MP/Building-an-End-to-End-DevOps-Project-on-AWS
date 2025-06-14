resource "aws_ecr_repository" "main_ecr" {
    name = "python_web_application"
    image_tag_mutability = "MUTABLE"
}